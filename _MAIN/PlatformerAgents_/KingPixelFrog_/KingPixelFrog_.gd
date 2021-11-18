extends KinematicBody2D

export(int) var ACCELERATION = 4000
export(float) var MAX_SPEED = 40000
export(float, 0, 1) var FRICTION = 0.2
export(float, 0, 1) var DAMP = 0.1
export(float) var GRAVITY = 2000
export(float) var JUMP = 800

var velocity:Vector2
var speed:float
var direction:int

var state_options = []
#var SAVE_KEY = 'Player'
var SAVE_KEY: String = "party_member_" + name
onready var ObjectSelectPanel = LevelEditor.get_node("ObjectSelectPanel")

onready var Scene = get_tree().current_scene
#onready var Hud = get_node("Hud")
#var Resources = Managers.get_node("Resources")
#var res = Resources.Player_
onready var SaveSystem = Global.get_node("SaveSystem")
onready var res = SaveSystem.get_resource(self, "KingPixelFrog_.tres")
onready var start_position = global_position
var hit

var door:Object
var platform:Object

var weapon_flip setget set_weapon_direction

signal _on_Player_ready(_self)

func _ready() -> void:
    connect_recievers()

    print('PlatformerAgents_/KingPixelFrog_/KingPixelFrog_.gd: ', get_tree().get_nodes_in_group("_on_player_ready"))
    #if ObjectSelectPanel: ObjectSelectPanel.get_current_scene(Scene)
    emit_signal("_on_Player_ready", self)
    $anim.play("Idle")
    pass

func connect_recievers():
    for i in get_tree().get_nodes_in_group("_on_Player_ready"):
        connect("_on_Player_ready", i ,"_on_Player_ready")

func set_weapon_direction(b:bool):
    weapon_flip = b 
    if weapon_flip:$Hammer.position
    pass
    
func _physics_process(delta: float) -> void:
        #print('Spawner/Player/Player.gd: ', $cam.offset)

    speed = clamp(speed, 0, MAX_SPEED)
    velocity.x = (speed * direction) * delta
    velocity.y += GRAVITY * delta
    velocity = move_and_slide(velocity, Vector2.UP)

    open_door()
    platform_drop()
    animation_state()
    movement()
    jumping(delta)

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("Attack") and state_options.has("Attack") and is_on_floor():
        $anim.play("Attack")
        $Hammer.swing()
        yield(get_node("anim"), "animation_finished")
        $anim.stop()
        $anim.play("Idle")

        pass

    if event is InputEventKey and event.scancode == KEY_K:
        pass

func take_damage():
    if !hit:
        hit = true
        res.emit_signal("take_damage")
#        $Hud.player_takes_damage(1)
        res.lives -= 1
        $anim.play("Hit")
        yield(get_node("anim"), "animation_finished")
        $anim.play("Idle")
        hit = false
    if res.lives <= 0:#die
        $anim.play("Dead")
        yield(get_node("anim"), "animation_finished")
        $anim.stop()
        yield(get_tree().create_timer(1), "timeout")
        get_tree().change_scene("res://Levels/Level1/Level1.tscn")
        res.lives = 3

        $anim.play("Idle")

func platform_drop():
    if Input.is_action_just_pressed("down") and platform:
        platform.get_node("rect").disabled = true
        yield(get_tree().create_timer(0.2), "timeout")
        platform.get_node("rect").disabled = false

func animation_state():
    $label.text = $anim.animation
    match $anim.animation:
    #match $anim.current_animation:
        "Idle":
            state_options = ["Run", "Jump", "Attack"]
            #speed = lerp(speed, 0, FRICTION)
            pass
        "Jump":
            state_options = ["Idle", "Run"]
        "Run":
            state_options = ["Idle", "Jump", "Attack", "Run"]
        "Fall":
            state_options = ["Idle", "Attack"]
        "Attack":
            state_options = []
        "Dead":
            state_options = []
        "Hit":
            state_options = []

func jumping(_delta):
    
    if Input.is_action_pressed("Jump"):
        if state_options.has("Jump"):
            $anim.play("Jump")
            velocity.y += -JUMP

    if velocity.y > 0:
        $anim.play("Fall")

    if Input.is_action_just_released("Jump"):
        #if $anim.animation != "Fall":
        velocity = velocity * DAMP

    if is_on_ceiling():
        #velocity.y = velocity.y * DAMP
        velocity.y = 0

    pass


func cam_offset(start:Vector2, end:Vector2):
    var tween = Tween.new(); add_child(tween)
    tween.interpolate_property($cam, "offset", # node, property
                              start, end, # start, end 
                              0.4, # time
                              Tween.TRANS_LINEAR, 
                              Tween.EASE_IN, 
                              0) # delay
    tween.start()

func open_door():
    #return doorj
    if door and Input.is_action_pressed("up"):
        var door_anim = door.get_node("anim")
        door.get_node("anim").play("Opening")
        $anim.play("Door")
        yield(door.get_node("anim"), "animation_finished")
        #yield(get_tree().create_timer(1), "timeout")
        door.get_node("anim").play("Closing")
        yield(door.get_node("anim"), "animation_finished")
        door.get_node("anim").play("Idle")
        $anim.play("Idle")
        _exit_door()
        yield(door.get_node("anim"), "animation_finished")
        #door = null
        #door_anim.stop()

func _exit_door():
    if door.find_node("Door2"):
        global_position = door.find_node("Door2").global_position
        
        #door.get_node("Door2/shape").disabled = true
#        yield(get_tree().create_timer(0.5), "timeout")
        #door.get_node("Door2/shape").disabled = false
        print('Player/Player.gd: ', door.get_child(0))

    else:
        global_position = door.get_parent().get_node("opening").global_position
        pass

func movement():
    if Input.is_action_just_pressed("left"):
        cam_offset($cam.offset, Vector2(-60, -40))

    elif Input.is_action_just_pressed("right"):
        cam_offset($cam.offset, Vector2(60, -40))

    elif Input.is_action_pressed("left") and state_options.has("Run"):
        direction = -1
        set_weapon_direction(true)
        speed += ACCELERATION
        $anim.flip_h = true
        if is_on_floor():
            if $anim.animation == "Attack":
                yield(get_node("anim"), "animation_finished")
                #$anim.stop()
                #$anim.play("Idle")
            $anim.play("Run")

    elif Input.is_action_pressed("right") and state_options.has("Run"):
        #cam_offset($cam.offset, Vector2(80, -40))
        #$cam.offset.x = 80

        direction = 1
        set_weapon_direction(false)
        speed += ACCELERATION
        $anim.flip_h = false
        if is_on_floor():
            if $anim.animation == "Attack":
                yield(get_node("anim"), "animation_finished")
            $anim.play("Run")

    else:
        if is_on_floor() and state_options.has("Idle"):
            if $anim.animation == "Attack":
                yield(get_node("anim"), "animation_finished")
            $anim.play("Idle")
            speed = lerp(speed, 0, FRICTION)
        elif $anim.animation != "Fall":
            speed = lerp(speed, 0, DAMP)
            pass

func _input(event: InputEvent) -> void:
    if event is InputEventKey and event.scancode == KEY_W:
        if event.pressed:
#            health -= 10
             pass

func save(save_game: Resource):
#    save_game.data[SAVE_KEY] = {'health': health}
     pass
     

#func load(save_game: Resource):
#    var data: Dictionary = save_game.data[SAVE_KEY]
#    health = data['health']
#    print('Player/Player.gd: ', health)
