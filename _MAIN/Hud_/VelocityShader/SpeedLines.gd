extends ParallaxBackground

onready var Scene = get_tree().current_scene
onready var SaveSystem = Global.get_node("SaveSystem")
onready var Monitor = Global.find_node("Monitor")
#onready var scroll_shader =  $speedlines.material
#onready var scroll_shader =  $"layer/speedlines"
onready var scroll_shader =  $"layer"
onready var Player_ = SaveSystem.get_resource(self, "Player.tres")
onready var Player = Scene.get_node("Player")
var to_monitor:Array = []

func _ready() -> void:
    Player_.connect("level_cleared", self, "level_cleared")
    #Player.res.connect("player_jumped", self, "player_jumped")
    Player_.connect("player_jumped", self, "player_jumped")
    if Monitor:Monitor.array.append(self)
    if Monitor:Monitor.set_array(Monitor.array)
    
    pass # Replace with function body.

func level_cleared(): # < Player
    print('Hud_/VelocityShader/SpeedLines.gd: signal')
#    TWEEN.speed_up(scroll_shader)
    

func player_jumped(): # < Player
    print('Hud_/VelocityShader/SpeedLines.gd: signal')
    
func speed_up():
    var t = Tween.new(); Scene.add_child(t)
    scroll_shader.visible = true
#    var t = self
    print('Hud_/VelocityShader/SpeedLines.gd: ',scroll_shader.name)
#    scroll_shader.set_shader_param("Direction", Vector2(0.0, 1.0))
#    t.set_speed_scale(1)
    var s = Vector2(0, 0)
    #var s = 0
    var e = Vector2(0, 999)
    #var e = 1
    var d = 4
    #var trans = Tween.TRANS_LINEAR
    var trans = t.TRANS_CUBIC
    #var trans = Tween.TRANS_CUBIC
    var ease_ = t.EASE_OUT

    #t.interpolate_property(scroll_shader, "shader_param/Speed",
    t.interpolate_property(scroll_shader, "motion_offset",
                           s, e, d, # start, end, duration
                           trans, ease_) # trans, ease, delay
    t.start()

    #return t


func _process(delta: float) -> void:
#    to_monitor = [str(scroll_shader.get_shader_param("Speed")), str(scroll_shader.get_shader_param("Direction"))]
    pass
