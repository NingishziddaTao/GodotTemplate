extends FileDialog

#onready var Scene = get_tree().current_scene    
#onready var LevelEditor
#onready var SelectedObject = LevelEditor.get_node("SelectedObject")
#onready var Scene = get_tree().current_scene
#onready var EditorFileDialog = LevelEditor.get_node("EditorFileDialog")

# Get node and its children

func _ready() -> void:
#    call_deferred("popup")
    rect_size.y = 233
#    popup()
#    current_dir = "res://Levels"
#    connect("file_selected", self, "_on_FileDialog_file_selected")
#    set_filters(PoolStringArray(['*.tscn']))
#    pass
#
#func _process(delta: float) -> void:
#    if Input.is_action_pressed("ui_focus_next"):
#        mode = 0#load
#        window_title = "load file"
#        popup()
#    elif Input.is_action_just_pressed("save_file"):
#        print('LevelEditor/EditorFIleDialog/EditorFileDialog.gd: ')
#        mode = 4#save
#        window_title = "save file"
#        popup()
#    elif Input.is_action_pressed("ui_cancel"):
#        visible = false
#    if visible:
#        SelectedObject.can_place = false
#
#func _set_owner(node, root):
#    if node != root:
#        node.owner = root
#    for child in node.get_children():
#        _set_owner(child, root)
#
#func _on_SceneSystem_scene_change(sender):
#    Scene = get_tree().current_scene
#
#func _on_FileDialog_file_selected(path: String) -> void:
#     if mode == 4:#save
#        var to_save = PackedScene.new()
#        #var scene_root = LevelEditor.get_children().back()
#        var scene_root = Scene
#        _set_owner(scene_root, scene_root)
#        to_save.pack(scene_root)
#        ResourceSaver.save(path, to_save)
#        SelectedObject.can_place = true
#
#     elif mode == 0:#load
#
#        var to_load = PackedScene.new()
#        to_load = ResourceLoader.load(path) 
#        var this_level = to_load.instance()
#        #LevelEditor.get_children().back().queue_free()
#        #LevelEditor.remove_child(LevelEditor.get_children().back())
#
#        Scene.queue_free()
#        LevelEditor.add_child(this_level)
#        Scene = this_level
#        SelectedObject.TileMap = this_level.get_node("TileMap")
#        SelectedObject.TileMap.set_cell_size(Vector2(16, 16))
#        yield(get_tree().create_timer(0.3), "timeout")
#        SelectedObject.can_place = true
#
#func _on_EditorFileDialog_tree_entered() -> void:
#    var LevelEditor_ = load("res://LevelEditor/LevelEditor.tres")
#    LevelEditor_.EditorFileDialog = self
#    pass # Replace with function body.
#
