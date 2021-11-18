extends Node

export(String) var startpath_recursion
export(bool) var autoremove_savefile

var index = 0
var rwalk = 0
var rwalk_res:Array
#var res:Resource

var resources:Dictionary
var save1:Dictionary 
var save1_resources:Dictionary
var save_file = "res://Save/save.dat"
var res:Resource
var loaded_resources:Dictionary

func _ready() -> void:
    var dir = Directory.new()
    if autoremove_savefile: dir.remove("res://Save/save.dat")
    loaded_resources = self.read_resources()
    self.save_resources(save1)
    print('Global/SaveSystem/SaveSystem.gd: ', loaded_resources)
    
func _input(event: InputEvent) -> void:

    if event is InputEventKey and event.scancode == KEY_SPACE:
        if event.pressed:
            pass

#    elif event is InputEventKey and event.scancode == KEY_S:
#         if event.pressed and event.get_control() == true:
#            save_resources(save1)
#            print('Global/SaveSystem/SaveSystem.gd: ')

    elif event is InputEventKey and event.scancode == KEY_L:
         if event.pressed and event.get_control() == true:
            loaded_resources = read_resources()

#func get_resource(user:Object, key:String):
#    if key == user.name+".tres":
#        return loaded_resources[key]
#    else:
#        return loaded_resources[key].duplicate()
#
#    pass

func get_resource(user:Object, key:String):
    return loaded_resources[key]
    pass


func save_resources(save:Dictionary):
    for k in loaded_resources:
        save1[k] = "res://Save/%s"%[k]
        var _OK = ResourceSaver.save(save1[k], loaded_resources[k])
    var f = File.new()
    var _err = f.open_encrypted_with_pass(save_file,File.WRITE,"godot")
    f.store_var(save)
    f.close()
    return save

func read_resources():
    var path_dic:Dictionary
    var resource_dic:Dictionary
    var f = File.new()
    if f.file_exists(save_file):
        print('Global/SaveSystem/SaveSystem.gd: ', "retyrn")
        var OK = f.open_encrypted_with_pass(save_file,File.READ,"godot")
        path_dic=f.get_var()
        for k in path_dic:
            resource_dic[k] = ResourceLoader.load(path_dic[k], "Resource", true)
            #resource_dic[k] = load(path_dic[k])
        f.close()   
        return resource_dic
    else:
        return recursiveWalk(startpath_recursion)
        #return _populate_resource_array()

# Aux


func recursiveWalk(recursion):
    var dir = _openDir(recursion)
    dir.list_dir_begin()
    var fileName = dir.get_next()

    while fileName != "":
        var filePath = recursion.plus_file(fileName)
        if dir.current_is_dir() and filePath.ends_with("_"):
            recursiveWalk(filePath)

        else:
            if filePath.ends_with("tres") and recursion != "res://":
                resources[filePath.split("/")[-1]] = load(filePath)
                #resources[filePath] = load(filePath)
        fileName = dir.get_next()
    dir.list_dir_end()
    return resources

func _openDir(path):
    rwalk += 1
    var dir = Directory.new()
    if dir.open(path) != OK:
        assert(false)
        return null
    return dir

