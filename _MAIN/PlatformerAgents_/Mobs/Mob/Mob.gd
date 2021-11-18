extends KinematicBody2D

export(Array, Resource) var stat_effects
export(int) var hp = 1

export(int) var ACCELERATION = 4000
export(float) var MAX_SPEED = 40000
export(float, 0, 1) var FRICTION = 0.2
export(float, 0, 1) var DAMP = 0.1
export(float) var GRAVITY = 2000
export(float) var JUMP = 800

var velocity:Vector2
var speed:float
var direction:int
#onready var Player = get_tree().current_scene.get_node("Player")
onready var space_state = get_world_2d().direct_space_state

#var Resources = Managers.get_node("Resources")
#var Player_ = Resources.Player_
var hit

onready var Scene = get_tree().current_scene
#onready var Player = Scene.get_node("Player")
#onready var player_anim = Player.get_node("anim")
onready var wall = $"Raycasts/wall"
onready var platform = $"Raycasts/platform"
onready var attack = $"Raycasts/attack"


func _ready() -> void:

    $anim.flip_h = true
    direction = -1
    $anim.scale.x = direction

func _physics_process(delta: float) -> void:
    change_direction()
    attack()
    $label.text = str(direction)
    #update()
    velocity.x = (direction * ACCELERATION) * delta
    velocity.y += GRAVITY * delta
    velocity = move_and_slide(velocity, Vector2.UP)

func change_direction():
    $anim.scale.x = direction
    #if !$"anim/platform".is_colliding() or $"anim/wall".is_colliding():
    if wall.is_colliding() and !hit:
        direction *= -1
        #platform.position.x *= -1
        #wall.cast_to.x *= -1
        _flip_raycasts()

    if !platform.is_colliding() and !hit:
        direction *= -1
        _flip_raycasts()
    pass

func _flip_raycasts():
    wall.position.x *= -1
    platform.position.x *= -1
    attack.position.x *= -1
    wall.cast_to.x *= -1
    platform.cast_to.x *= -1
    attack.cast_to.x *= -1

func attack():
    if attack.is_colliding():
        $anim.play("Attack")
        yield(get_node("anim"), "animation_finished")
        $anim.play("Run")

func _on_Timer_timeout() -> void:
    #position = start_position
    pass # Replace with function body.

func take_damage():
    if !hit:
        #direction *= -1
        hit = true
#        if player_anim.flip_h == true:direction = -1
#        elif player_anim.flip_h == false:direction = 1
        $anim.play("Hit")
        yield(get_node("anim"), "animation_finished")
        $anim.play("Idle")
        hit = false
        hp -= 1
    if hp <= 0:
        $hitbox.get_child(0).disabled = true
        $anim.play("Dead")
        yield(get_node("anim"), "animation_finished")
        queue_free()

func _on_hitbox_body_entered(body: Node) -> void:
    if body.name == "Player":
        body.take_damage()
    pass # Replace with function body.

