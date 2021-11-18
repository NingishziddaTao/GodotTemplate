extends Position2D

export(PackedScene) var Swing

var start_position = position

func _ready() -> void:
    pass

func swing():
    var swing = Swing.instance()
    if get_parent().get_node("anim").flip_h == true:
        position.x = -start_position.x
    else:
        position.x = start_position.x

    add_child(swing)
    swing.connect("body_entered", self, "swing_on_body")
    yield(get_tree().create_timer(0.3), "timeout")
    swing.queue_free()

func swing_on_body(body):
    if body.has_method("take_damage"):
        body.take_damage()
