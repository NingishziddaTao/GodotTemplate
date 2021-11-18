extends Control

var monitor_number = 0
#var GameSettings = load("res://Main.gd")
#var GameSettings = 

export(String) var current
var monitored_object:Object
#var object_array:Array  = [] setget set_array

var tweening
onready var monitor_start_position = rect_position
export(Vector2) var monitor_destination = Vector2(0, 100)

func _ready() -> void:
    pass
    
func _physics_process(_delta):
    object_attributes()  
    pass

func _input(event: InputEvent) -> void:
    if event is InputEventKey and event.scancode == KEY_Q:
        get_tree().quit()
    if event is InputEventKey and event.scancode == KEY_M:
        if event.pressed:
            monitor_slide(monitor_destination)

func login(user:Object):
    if user.name == current:
        monitored_object = user

#func set_array(object_array): # < setter Called by objects that appended itself to object_array
#    # if name of the last appended object is the same as current(exported string) it becomes the monitored_object
#    if object_array[-1].name == current:
#        monitored_object = object_array[-1]
#    else:
#        object_array.erase(object_array[-1])
#    pass

func object_attributes():
    if monitored_object:
        for i in range(monitored_object.to_monitor.size()):
            get_tree().get_nodes_in_group("monitor_labels")[i].text = str(monitored_object.to_monitor[i])
        pass

func monitor_slide(end_position:Vector2):#tween back and forth
    if !tweening:
        tweening = true
        
        var s = monitor_start_position
        var e = end_position
        var d = 0.80
        var t = Tween.new(); add_child(t)
        if rect_position == monitor_start_position:
            t.interpolate_property(self, "rect_position", s, e, d, Tween.TRANS_ELASTIC)
            t.start()
            yield(t, "tween_completed")
            tweening = false
            #$Monitor.visible = false
            pass
        else:
            e = monitor_start_position
            s = rect_position
            visible = true
            t.interpolate_property(self, "rect_position", s, e, d, Tween.TRANS_ELASTIC)
            t.start()
            yield(t, "tween_completed")
            tweening = false

