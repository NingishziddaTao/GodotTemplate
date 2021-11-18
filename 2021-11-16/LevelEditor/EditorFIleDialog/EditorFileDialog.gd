extends FileDialog

#onready var Scene = get_tree().current_scene    
#onready var LevelEditor
#onready var SelectedObject = LevelEditor.get_node("SelectedObject")
onready var Scene = get_tree().current_scene
#onready var EditorFileDialog = LevelEditor.get_node("EditorFileDialog")

# Get node and its children

func _ready() -> void:
#    call_deferred("popup")
    rect_size.y = 233
    current_dir = "res://Levels"
    connect("file_selected", self, "_on_FileDialog_file_selected")
    set_filters(PoolStringArray(['*.tscn']))
    pass

func _process(delta: float) -> void:
    if Input.is_action_pressed("ui_focus_next"):
        mode = 0#load
        window_title = "load file"
        popup()
    elif Input.is_action_just_pressed("save_file"):
        print('LevelEditor/EditorFIleDialog/EditorFileDialog.gd: ')
        mode = 4#save
        window_title = "save file"
        popup()
    elif Input.is_action_pressed("ui_cancel"):
        visible = false
    if visible:
        #SelectedObject.can_place = false
        pass

func _on_Player_ready(sender):
    Scene = get_tree().current_scene

func _set_owner(node, root):

    # NOTE if you do not disable editable children on your nodes it wont iterate properly!
    var packed_scenes = []
    if node != root and node.get_filename():
        if node.get_parent() !=root:
            pass
        else:
            packed_scenes.append(node)
            node.owner = root

#    else:
#        for scene in packed_scenes:
#            for child in scene.get_childeren():
#                if child.get_filename():
#                    child.owner = scene
#                    pass

    for child in node.get_children():
        _set_owner(child, root)

#    if node != root:
#        node.owner = root
#    for child in node.get_children():
#        _set_owner(child, root)

func _on_FileDialog_file_selected(path: String) -> void:
    
     if mode == 4:#save
        var to_save = PackedScene.new()
        #var scene_root = Scene.get_children().back()
        #var scene_root = LevelEditor.get_children().back()
        var scene_root = Scene
        _set_owner(scene_root, scene_root)
        to_save.pack(scene_root)
        ResourceSaver.save(path, to_save)
        ResourceLoader.load(path)
        #SelectedObject.can_place = true

     elif mode == 0:#load
        get_tree().change_scene(path)

func _on_EditorFileDialog_tree_entered() -> void:
    var LevelEditor_ = load("res://LevelEditor/LevelEditor.tres")
    LevelEditor_.EditorFileDialog = self
    pass # Replace with function body.

