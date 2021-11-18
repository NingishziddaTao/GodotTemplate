extends Camera2D

export var panSpeed = 10.0
export var speed = 40.0
export var zoomspeed = 10.0
export var zoommargin = 0.1

export var zoomMin = 0.25
export var zoomMax = 3.0
export var marginX = 200.0
export var marginY = 200.0

var mousepos = Vector2()
var mouseposGlobal = Vector2()
var start = Vector2()#local
var startv = Vector2()#global
var end = Vector2()#local
var endv = Vector2()#global
var zoomfactor = 1.0
var zooming = false
var is_dragging = false
var move_to_point = Vector2()
var drag_start:Vector2
var drag_end:Vector2
var selected = []

onready var POSITION = position

onready var camera_man
onready var Scene:Object

func _ready():
    pass

func on_KingPixelFrog_ready(sender):#signal
    Scene = get_tree().current_scene
    camera_man = sender.get_node("cam")
    pass

func get_camera_man(cam):#signal < Player
    camera_man = cam

func _unhandled_input(event):
    if event is InputEventMouseButton:
        if event.is_pressed():
            zooming = true
            if event.button_index == BUTTON_WHEEL_UP:
                zoomfactor -= 0.01 * zoomspeed
            if event.button_index == BUTTON_WHEEL_DOWN:
                zoomfactor += 0.01 * zoomspeed
        else:
            zooming = false

func _input(event):
    if event is InputEventKey and event.scancode==KEY_C:
        if event.is_pressed():
            print('LevelEditor/Camera/Camera.gd: ')
            #emit_signal("current_camera", self)
            #print(LevelEditor.get_node("Camera2D").current, self)
            if current: 
                current = false
                camera_man.current = true
            else:
                camera_man.current = false
                current = true

    if event is InputEventKey and event.scancode==KEY_N:
        if event.is_pressed():
            position = POSITION
            zoom = Vector2(1, 1)

func _draw():
    if is_dragging:
        #draw_rect(Rect2(drag_start, get_global_mouse_position() - drag_start),
        draw_rect(Rect2(drag_start, drag_start+drag_end),
                Color(.5, .5, .5), false)

        #func _unhandled_input(event):
        #    if event is InputEventKey:
        #        if event.scancode==KEY_C:
        #            if event.is_pressed():
        #                emit_signal("current_camera", self)

func _process(delta):
    #if Input.is_key_pressed(KEY_C):
        #if camera:

    
    # Key scroll
    var inpx = (int(Input.is_action_pressed("ui_right"))
                       - int(Input.is_action_pressed("ui_left")))
    var inpy = (int(Input.is_action_pressed("ui_down"))
                       - int(Input.is_action_pressed("ui_up")))
    position.x = lerp(position.x, position.x + inpx *speed * zoom.x,speed * delta)
    position.y = lerp(position.y, position.y + inpy *speed * zoom.y,speed * delta)
    
    #zoom in
    zoom.x = lerp(zoom.x, zoom.x * zoomfactor, zoomspeed * delta)
    zoom.y = lerp(zoom.y, zoom.y * zoomfactor, zoomspeed * delta)
    zoom.x = clamp(zoom.x, zoomMin, zoomMax)
    zoom.y = clamp(zoom.y, zoomMin, zoomMax)

    if not zooming:
        zoomfactor = 1.0

#    # Mouse border scroll
#    if Input.is_key_pressed(KEY_CONTROL):
#        if mousepos.x < marginX:
#            position.x = lerp(position.x, position.x - abs(mousepos.x - marginX)/marginX * panSpeed * zoom.x, panSpeed * delta)
#        elif mousepos.x > OS.window_size.x - marginX:
#            position.x = lerp(position.x, position.x + abs(mousepos.x - OS.window_size.x + marginX)/marginX *  panSpeed * zoom.x, panSpeed * delta)
#        if mousepos.y < marginY:
#            position.y = lerp(position.y, position.y - abs(mousepos.y - marginY)/marginY * panSpeed * zoom.y, panSpeed * delta)
#        elif mousepos.y > OS.window_size.y - marginY:
#            position.y = lerp(position.y, position.y + abs(mousepos.y - OS.window_size.y + marginY)/marginY * panSpeed * zoom.y, panSpeed * delta)

func _on_Camera2D_tree_entered() -> void:
#    LevelEditor = load("res://LevelEditor/LevelEditor.tres")
#    LevelEditor.Camera2D = self
    pass # Replace with function body.
