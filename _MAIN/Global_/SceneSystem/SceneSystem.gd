extends Node
export(String) var startpath_recursion
export(bool) var autoremove_savefile

var item:int
var start_button
var start:bool
export(String) var level_path = "res://Levels/"
var level_array = self.populate_level_array()
var index = 0
var current_scene
var rwalk = 0
var rwalk_res:Array
#var res:Resource

var resources:Dictionary
var save1:Dictionary 
var save1_resources:Dictionary
var save_file = "res://Save/save.dat"
var res:Resource
var loaded_resources:Dictionary

signal _on_SceneSystem_scene_change(_self)
#onready var 

func _ready() -> void:
    self.main()
    pass

func _input(event: InputEvent) -> void:
    if event is InputEventKey and event.scancode == KEY_Q:
        get_tree().quit()

func main():
    if  get_tree().get_root().has_node("Main"):
        var Main = get_node("/root/Main")
        var _err = get_tree().change_scene_to(Main.starting_scene)
        
func populate_level_array():
    var levels:Array
    var dir = Directory.new()
    dir.open(level_path)
    dir.list_dir_begin(true)
    #dir.list_dir_begin(true)
    var file = dir.get_next()
    while file != "":
        file = dir.get_next()
        if file.ends_with(".tscn"):
            var file_path = level_path.plus_file(file)
            levels.append(file_path)
    return levels

# Fu
func next_scene():
    get_tree().change_scene(level_path + level_array[index])
    if index < len(level_array)-1:
        index += 1
    else:
        index = 0
    pass

