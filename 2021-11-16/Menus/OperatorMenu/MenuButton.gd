extends TextureButton

func _process(delta: float) -> void:
    if Input.is_action_pressed("jump"):
        focus_mode = 1
        print("button")
