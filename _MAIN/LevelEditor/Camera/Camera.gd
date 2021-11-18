extends Camera2D

export var panSpeed = 10.0
export var speed = 20.0
export var zoomspeed = 30.0
export var zoommargin = 0.1

export var zoomMin = 0.25
export var zoomMax = 3.0
export var marginX = 288.0
export var marginY = 162.0

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
var to_monitor:Array

onready var POSITION = position
onready var Monitor = Hud.find_node("Monitor")

onready var camera_man
onready var Scene:Object

func _ready():

    if Monitor:Monitor.login(self)
    pass

func _process(delta):
    
    #zoom in
    zoom.x = lerp(zoom.x, zoom.x * zoomfactor, zoomspeed * delta)
    zoom.y = lerp(zoom.y, zoom.y * zoomfactor, zoomspeed * delta)
    zoom.x = clamp(zoom.x, zoomMin, zoomMax)
    zoom.y = clamp(zoom.y, zoomMin, zoomMax)

    to_monitor = [panSpeed, zoom.x, zoom.y]
    directional_scolling(delta)
    mouse_border_scroll(delta)

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

    if event is InputEventKey and event.scancode==KEY_KP_SUBTRACT:
        zoomfactor -= 0.01 * zoomspeed
    if event is InputEventKey and event.scancode==KEY_KP_ADD:
        zoomfactor += 0.01 * zoomspeed

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


func _on_Player_ready(sender):#signal
    Scene = get_tree().current_scene
    camera_man = sender.get_node("cam")
    pass

func mouse_border_scroll(delta):
    mousepos = get_local_mouse_position()
    var test_margin = 300
    
    #var move_position_left = position.x - abs(mousepos.x test_margin)/test_margin * panSpeed * zoom.x
    var move_position_left = position.x - abs(mousepos.x - marginX)/marginX * panSpeed * zoom.x
    var move_position_right = position.x + abs(mousepos.x - OS.window_size.x + marginX)/marginX+3 *  panSpeed * zoom.x
    #var move_position_up =  position.y - abs(mousepos.y - marginY)/marginY * panSpeed * zoom.y
    var move_position_up =  position.y - abs(mousepos.y)/marginY * panSpeed * zoom.y
    var move_position_down = position.y + abs(mousepos.y - OS.window_size.y + marginY)/marginY+3 * panSpeed * zoom.y

    if Input.is_key_pressed(KEY_SHIFT):
        if get_local_mouse_position().x < -600:#go left
            position.x = lerp(position.x, move_position_left, panSpeed * delta)
        elif mousepos.x > OS.window_size.x - 100:#go right
            position.x = lerp(position.x, move_position_right, panSpeed * delta)

        elif mousepos.y < -100:
            print('LevelEditor/Camera/Camera.gd: ')
            position.y = lerp(position.y, move_position_up, panSpeed * delta)
        elif mousepos.y > OS.window_size.y - 100:
            position.y = lerp(position.y, move_position_down, panSpeed * delta)

func directional_scolling(delta):
    var inpx = (int(Input.is_action_pressed("ui_right"))
                       - int(Input.is_action_pressed("ui_left")))
    var inpy = (int(Input.is_action_pressed("ui_down"))
                       - int(Input.is_action_pressed("ui_up")))
    position.x = lerp(position.x, position.x + inpx *speed * zoom.x,speed * delta)
    position.y = lerp(position.y, position.y + inpy *speed * zoom.y,speed * delta)

    if not zooming:
        zoomfactor = 1.0
