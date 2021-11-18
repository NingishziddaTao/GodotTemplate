extends StaticBody2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#    print($sprite.texture.get_size())
#    print($rect.shape.extents)
    var texture_size = $atlas.texture.get_size()
    $rect.shape.extents = texture_size * 0.5
    $rect.position.y = 1
    $"detect/area".shape.extents = texture_size * 0.6
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#    pass


func _on_detect_body_entered(body: Node) -> void:
    if body.name == "Player":
        body.platform = self
    pass # Replace with function body.
