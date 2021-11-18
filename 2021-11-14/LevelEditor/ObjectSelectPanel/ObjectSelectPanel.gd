extends CanvasLayer

onready var container_list = []
onready var Scene = get_tree().current_scene
onready var LevelEditor = get_parent()
onready var SelectedObject = get_node(SelectedObjectNode)
onready var SceneSystem = Global.get_node("SceneSystem")
onready var cursor_sprite = SelectedObject.get_node("cursor")
#onready var ResourceManager = Global.get_node("ResourceManager")

onready var animated_containers = get_tree().get_nodes_in_group("animated_containers")
onready var autotile_containers = get_tree().get_nodes_in_group("autotile_containers")
onready var static_containers = get_tree().get_nodes_in_group("static_containers")
export(Resource) var statics# Array
export(Resource) var animated# Array
onready var SaveSystem = Global.get_node("SaveSystem")
onready var KingPixelFrog_ = SaveSystem.get_resource(self, "KingPixelFrog_.tres")

var autotiles:Array# on player_ready
var atlastiles:Array# on player_ready
var tileset = 0

export(NodePath) var SelectedObjectNode
export(Array, NodePath) var tabs

enum {CREATURES, TILES}

func _ready():
#    var Player_  = ResourceManager.Player_
    KingPixelFrog_.connect("player_ready", self, "player_ready")
    pass

func _process(delta):
    #key_input()
    pass


func on_KingPixelFrog_ready(sender):#signal
    pass

func player_ready(): # << Player_
    Scene = get_tree().current_scene
    autotile_container_setup()
    animated_container_setup()
    static_container_setup()
    #atlastile_container_setup()

func animated_container_setup():
    if animated:

        for nr in animated.array.size():
            #var icon = animated.array[nr].instance().get_node("anim").frames.get_frame("Idle", 0)
            animated_containers[nr].packed_scene = animated.array[nr].instance()
            var icon = animated_containers[nr].packed_scene.get_node("anim").frames.get_frame("Idle", 0).duplicate()
            animated_containers[nr].texture = icon
            #animated_containers[nr].texture.region.size = Vector2(32, 32)
            print('LevelEditor/ObjectSelectPanel/ObjectSelectPanel.gd: ', icon)
            #            animated_containers[nr].texture.region = animated_containers[nr].packed_scene.get_node("anim").frames.get_frame("Idle", 0).region
            #            animated_containers[nr].texture.region.size = Vector2(16, 16)

func autotile_container_setup():
    autotiles = get_tree().get_nodes_in_group("autotiles")
    for nr in autotiles.size():
        #autotiles[nr].get_tileset().tile_set_tile_mode(0, 0)
        autotile_containers[nr].texture = autotiles[nr].get_node("sprite").texture
        autotile_containers[nr].packed_scene = autotiles[nr]

func static_container_setup():
    if statics:
        for nr in statics.array.size():
            static_containers[nr].packed_scene = statics.array[nr].instance()
            static_containers[nr].texture = static_containers[nr].packed_scene.get_node("atlas").texture.duplicate()
            static_containers[nr].texture.region = static_containers[nr].packed_scene.get_node("atlas").texture.region
            static_containers[nr].texture.region.size = Vector2(16, 16)



#func key_input():
#    if Input.is_key_pressed(KEY_E):
#        tileset = _tileset_select(0)
#
#    if Input.is_key_pressed(KEY_R):
#        tileset = _tileset_select(1)
#
#    if Input.is_key_pressed(KEY_T):
#        tileset = _tileset_select(2)
#
#    if Input.is_key_pressed(KEY_1):
#        _creature_select(0)
#
#    if Input.is_key_pressed(KEY_Z):
#
#        SelectedObject.active = false

##    if Input.is_key_pressed(KEY_2):
##        current_tab = CREATURES
##        container_list = get_node("Creatures/scroll/vbox/hbox").get_children()
##        SelectedObject.current_object = container_list[1].object_scene
##        cursor_sprite.texture = container_list[1].texture
##    if Input.is_key_pressed(KEY_3):
##        current_tab = CREATURES
##        container_list = get_node("Creatures/scroll/vbox/hbox").get_children()
##        SelectedObject.current_object = container_list[2].object_scene
##        cursor_sprite.texture = container_list[2].texture
##    if Input.is_key_pressed(KEY_4):
##        current_tab = CREATURES
##        container_list = get_node("Creatures/scroll/vbox/hbox").get_children()
##        SelectedObject.current_object = container_list[3].object_scene
##        cursor_sprite.texture = container_list[3].texture
##    if Input.is_key_pressed(KEY_5):
##        current_tab = CREATURES
##        container_list = get_node("Creatures/scroll/vbox/hbox").get_children()
##        SelectedObject.current_object = container_list[4].object_scene
##        cursor_sprite.texture = container_list[4].texture
##    if Input.is_key_pressed(KEY_6):
##        current_tab = CREATURES
##        container_list = get_node("Creatures/scroll/vbox/hbox").get_children()
##        SelectedObject.current_object = container_list[5].object_scene
##        cursor_sprite.texture = container_list[5].texture
##    if Input.is_key_pressed(KEY_7):
##        current_tab = CREATURES
##        container_list = get_node("Creatures/scroll/vbox/hbox").get_children()
##        SelectedObject.current_object = container_list[6].object_scene
##        cursor_sprite.texture = container_list[6].texture
##    if Input.is_key_pressed(KEY_8):
##        current_tab = CREATURES
##        container_list = get_node("Creatures/scroll/vbox/hbox").get_children()
##        SelectedObject.current_object = container_list[7].object_scene
##        cursor_sprite.texture = container_list[7].texture
##    if Input.is_key_pressed(KEY_9):
##        current_tab = CREATURES
##        container_list = get_node("Creatures/scroll/vbox/hbox").get_children()
##        SelectedObject.current_object = container_list[8].object_scene
##        cursor_sprite.texture = container_list[8].texture

##    if Input.is_action_just_pressed("clear"):
##        if current_tab == CREATURES and Level.get_children():
##            Level.get_children().back().queue_free()

#func _tileset_select(tileset = 0):
#    current_tab = TILES
#    SelectedObject.panel_offset = TILES
#    container_list = get_node(tabs[TILES]).get_children()
#    SelectedObject.active = true
#    SelectedObject.current_object = container_list[0].object
#    cursor_sprite.texture = container_list[0].texture
#    return tileset

#func _creature_select(container):
#    current_tab = CREATURES
#    SelectedObject.panel_offset = CREATURES
#    container_list = get_node(tabs[CREATURES]).get_children()
#    SelectedObject.active = true
#    SelectedObject.current_object = container_list[container].object
#    cursor_sprite.texture = container_list[container].texture

