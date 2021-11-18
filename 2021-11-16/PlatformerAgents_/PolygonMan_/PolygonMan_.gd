extends KinematicBody2D

export(Array, Resource) var stat_effects
export(int) var hp = 1
#export(Directory) var dir

export(int) var ACCELERATION = 4000
export(float) var MAX_SPEED = 40000
export(float, 0, 1) var FRICTION = 0.2
export(float, 0, 1) var DAMP = 0.1
export(float) var GRAVITY = 2000
export(float) var JUMP = 800

var velocity:Vector2
var speed:float
var direction:int

onready var start_position = position
onready var ResourceManager = Global.get_node("ResourceManager")
onready var res = ResourceManager.Player_

onready var Monitor = Hud.find_node("Monitor")
var state_options = []
var to_monitor:Array

func _ready() -> void:
    res.emit_signal("player_ready")
    $anim.play("idle")
    if Monitor:Monitor.login(self)
    pass

func _physics_process(delta: float) -> void:
#    to_monitor = [is_on_floor(), $anim.current_animation, $cayote.collision]
    #print('Parents/PlatformerControls.gd: ', $anim.current_animation)
    #print('Parents/PlatformerControls.gd: ', y_ray_collision)

    speed = clamp(speed, 0, MAX_SPEED)
    velocity.x = (speed * direction) * delta
    velocity.y += GRAVITY * delta
    velocity = move_and_slide(velocity, Vector2.UP)

    animation_state()
    movement()
    jumping(delta)
    update()
    
func _draw() -> void:
    pass

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("Jump"):
    #if event is InputEventKey and event.scancode == KEY_SPACE:
        pass

    if event is InputEventKey and event.scancode == KEY_K:
        pass

func animation_state():
    match $anim.current_animation:
        "idle":
            state_options = ["run", "jump"]
        "jump":
            state_options = ["idle", "run"]
        "run":
            state_options = ["idle", "jump"]
        "fall":
            state_options = ["idle"]

func jumping(_delta):
    
    if Input.is_action_pressed("Jump") and $cayote.collision:
        if state_options.has("jump"):
            $anim.play("jump")
            velocity.y += -JUMP

    if velocity.y > 0 and !$cayote.collision:
        $anim.play("fall")

    if Input.is_action_just_released("Jump"):
        if $anim.current_animation != "fall":
            velocity = velocity * DAMP

    if is_on_ceiling():
        velocity = velocity * DAMP

    pass

func movement():

    if Input.is_action_pressed("left"):
        direction = -1
        speed += ACCELERATION
        if is_on_floor():
            $anim.play("run")
    elif Input.is_action_pressed("right"):
        direction = 1
        speed += ACCELERATION
        if is_on_floor():
            $anim.play("run")

    else:
        if is_on_floor():
            $anim.play("idle")
            speed = lerp(speed, 0, FRICTION)
        else:
            speed = lerp(speed, 0, DAMP)


