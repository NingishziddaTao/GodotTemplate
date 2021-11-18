extends Node2D

var current_object
var signals_connected
var can_place = true
var dragging = false  # Are we currently dragging?
var deleting setget set_deleting
var rectangle_select setget set_rectangle_select
var selected = []  # Array of selected units.
var drag_start = Vector2.ZERO  # Location where drag began.
var select_rect = RectangleShape2D.new()  # Collision shape for drag box.
var panel_offset:int
var to_monitor:Array

onready var active = true
onready var Scene:Object

onready var LevelEditor = get_parent()
onready var TileMap:Object
onready var ObjectSelectPanel = get_parent()
#onready var EditorFileDialog = LevelEditor.get_node("EditorFileDialog")
#onready var SceneSystem = Global.get_node("SceneSystem")
onready var Monitor = Hud.find_node("Monitor")
onready var SceneSystem = Global.find_node("SceneSystem")
onready var SaveSystem = Global.get_node("SaveSystem")
onready var KingPixelFrog_ = SaveSystem.get_resource(self, "KingPixelFrog_.tres")

onready var autotile_containers = get_tree().get_nodes_in_group("autotile_containers")
onready var static_containers = get_tree().get_nodes_in_group("static_containers")
onready var animated_containers = get_tree().get_nodes_in_group("animated_containers")


func _ready():
    if Monitor:Monitor.login(self)
    KingPixelFrog_.connect("player_ready", self, "player_ready")# needed to get current level
    get_tree().get_nodes_in_group("SelectedObjectLabels")[0].text = "del"
    get_tree().get_nodes_in_group("SelectedObjectLabels")[1].text = "rect"
    #TileMap.set_cell_size(Vector2(16, 16))

func _process(delta):
    to_monitor = [dragging, deleting]
    $cursor.global_position = get_global_mouse_position()
    position = Vector2.ZERO
    place_tiles()
    place_statics()

func _input(event):
    if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
        var area = mousedrag_area(event)
        delete_node(area)
        add_tiles(area)
        delete_tiles(area)

    elif event is InputEventMouseButton and event.button_index == BUTTON_RIGHT:
        clear_tile(event)
        pass

    elif event is InputEventMouseMotion and dragging:
        update()# _draw

#func activate_modes():
    if event is InputEventKey and event.scancode == KEY_X:
        if event.pressed and !deleting:
            deleting = true
            get_tree().get_nodes_in_group("SelectedObjectLabels")[0].text = "del"
            get_tree().get_nodes_in_group("SelectedObjectLabels")[0].modulate = Color(1, 0, 0, 1)
        elif event.pressed:
            deleting = false
            get_tree().get_nodes_in_group("SelectedObjectLabels")[0].text = "del"
            get_tree().get_nodes_in_group("SelectedObjectLabels")[0].modulate = Color(1, 1, 1, 1)
    if event is InputEventKey and event.scancode == KEY_R:
        if event.pressed and !rectangle_select:
            rectangle_select = true
            get_tree().get_nodes_in_group("SelectedObjectLabels")[1].text = "rect"
            get_tree().get_nodes_in_group("SelectedObjectLabels")[1].modulate = Color(1, 0, 0, 1)
        elif event.pressed:
            rectangle_select = false
            get_tree().get_nodes_in_group("SelectedObjectLabels")[1].text = "rect"
            get_tree().get_nodes_in_group("SelectedObjectLabels")[1].modulate = Color(1, 1, 1, 1)


func set_deleting(boolean):
    pass
func set_rectangle_select(boolean):
    pass

func _on_Player_ready(sender):
    print('LevelEditor/SelectedObject/SelectedObject.gd: ready')
    Scene = get_tree().current_scene
    current_object = autotile_containers[0].packed_scene
    $cursor.texture = autotile_containers[0].texture
    if !signals_connected:
        signals_connected = true
        _connect_autotile_containers()
        _connect_static_containers()
        _connect_animated_containers()

func player_ready(): # << Player_
    pass

func _connect_autotile_containers():
    for i in autotile_containers:
        i.connect("mouse_entered", self, "mouse_entered", [i])

func _connect_static_containers():
    for i in static_containers:
        i.connect("mouse_entered", self, "mouse_entered", [i])
        #current_object = null

func _connect_animated_containers():
    for i in animated_containers:
        i.connect("mouse_entered", self, "mouse_entered", [i])
    pass
    
        #current_object = null

func mouse_entered(container):
    #deleting = false
    current_object = container.packed_scene
    print('LevelEditor/SelectedObject/SelectedObject.gd: ')
    if current_object:
        if current_object.has_node("atlas"):
            $cursor.texture = current_object.get_node("atlas").texture
        else:
        #if current_object.get_class() == "TileMap":
            $cursor.texture = container.texture
    
func scene_changed():
    Scene = get_tree().current_scene

func offset():
    if Scene:
        if not active:
            global_position = Vector2()
        if active and panel_offset == ObjectSelectPanel.CREATURES:
            global_position = TileMap.map_to_world(TileMap.world_to_map(get_global_mouse_position()))#grid
        elif active and panel_offset == ObjectSelectPanel.TILES:
            global_position = TileMap.map_to_world(TileMap.world_to_map(get_global_mouse_position()))+Vector2(8, 8) 

func place_tiles():
    if current_object and !deleting and !rectangle_select:
        if Input.is_action_pressed("leftM") and current_object.get_class() == "TileMap":
            var tilepos = current_object.world_to_map(get_global_mouse_position())
            current_object.set_cell(tilepos.x, tilepos.y, 0, false, false, false, Vector2(1, 1))
            current_object.update_bitmask_area(Vector2(tilepos.x, tilepos.y))

func place_statics():
    #Scene = get_tree().current_scene
    if current_object and !deleting:
        #if Input.is_action_pressed("leftM"):
        if Input.is_action_just_pressed("leftM") and current_object.get_class() != "TileMap":
            print('LevelEditor/SelectedObject/SelectedObject.gd: ')
            #var tilepos = current_object.world_to_map(get_global_mouse_position())
            var new_object = current_object.duplicate()
            new_object.global_position = get_global_mouse_position()
            #print('LevelEditor/SelectedObject/SelectedObject.gd: ' , Scene)
            #Scene.add_child(new_object)
            get_tree().current_scene.add_child(new_object)

#func place_anim():
#    #Scene = get_tree().current_scene
#    if current_object and !deleting:
#        #if Input.is_action_pressed("leftM"):
#        if Input.is_action_just_pressed("leftM") and current_object.get_class() != "TileMap":
#            print('LevelEditor/SelectedObject/SelectedObject.gd: ')
#            #var tilepos = current_object.world_to_map(get_global_mouse_position())
#            var new_object = current_object.instance()
#            new_object.global_position = get_global_mouse_position()
#            #print('LevelEditor/SelectedObject/SelectedObject.gd: ' , Scene)
#            #Scene.add_child(new_object)
#            get_tree().current_scene.add_child(new_object)
#            
#            


#func place_objects():
#     if current_object:
#            var new_object = current_object.instance()
#            Level.add_child(new_object)
#            #new_object.global_position = get_global_mouse_position()
#            new_object.global_position = TileMap.map_to_world(TileMap.world_to_map(get_global_mouse_position()))#grid
#    #if active and current_object:
##        level = EditorFileDialog.current_level
#        #if Scene:level = Scene
#        #global_position = TileMap.map_to_world(TileMap.world_to_map(get_global_mouse_position()))#grid
#        #if(current_object != null and can_place and Input.is_action_just_pressed("mb_left")):
#        #if (str(current_object).begins_with("[PackedScene") and can_place and Input.is_action_just_pressed("mb_left")):
#        #if current_object.is_in_group("autotile_containers") and Input.is_action_just_pressed("mb_left"):
#        #if Input.is_action_just_pressed("leftM"):
#        #if current_object.is_in_group("autotile_containers") and can_place and Input.is_action_just_pressed("mb_left"):
#
#        #elif (str(current_object).begins_with("[TileSet") and can_place and Input.is_action_pressed("mb_left")):

func clear_tile(event):
    if event.pressed:
        if current_object and current_object.get_class() == "TileMap":
            #if current_object.get_class() == "TileMap" and Input.is_action_just_pressed("rightM"):
            var tilepos = current_object.world_to_map(get_global_mouse_position())
            current_object.set_cell(tilepos.x, tilepos.y, -1, false, false, false, Vector2(1, 1))
            current_object.update_bitmask_area(Vector2(tilepos.x, tilepos.y))

func mousedrag_area(event):
    var area = []
    if event.pressed and rectangle_select:
            
        # We only want to start a drag if there's no selection.
        dragging = true
        drag_start = get_global_mouse_position()

        if selected.size() == 0:
            dragging = true
            drag_start = get_global_mouse_position()

    elif dragging:
        dragging = false
        update()

        # Get selection array
        var drag_end = get_global_mouse_position()
        area.append(Vector2(min(drag_start.x, drag_end.x), min(drag_start.y, drag_end.y)))# hight vec
        area.append(Vector2(max(drag_start.x, drag_end.x), max(drag_start.y, drag_end.y)))# low vec 

    return area

func delete_tiles(area:Array):
    if deleting and area:
        if current_object.get_class() == "TileMap":
            for x in range(area[0].x ,area[1].x):
                for y in range(area[0].y ,area[1].y):
                    var map = current_object.world_to_map(Vector2(x, y))
                    #if TileMap.get_cellv(map) >= 0:
                    current_object.set_cellv(map, -1)
                    current_object.update_bitmask_area(map)

func add_tiles(area:Array):
    if current_object and area:
        if current_object.get_class() == "TileMap":
            print('LevelEditor/SelectedObject/SelectedObject.gd: ')
            for x in range(area[0].x ,area[1].x):
                for y in range(area[0].y ,area[1].y):
                    var map = current_object.world_to_map(Vector2(x, y))
                    #if TileMap.get_cellv(map) >= 0:
                    current_object.set_cellv(map, 0)
                    current_object.update_bitmask_area(map)


func delete_node(area:Array):
    if deleting and area:
        for node in Scene.get_children():
            if node != Scene.get_node("WorldEnvironment") and current_object.get_class() != "TileMap":
                if !node.is_in_group("Players"):
                    if node.global_position.x > area[0].x and node.global_position.x < area[1].x:
                        if node.global_position.y > area[0].y and node.global_position.y < area[1].y:
                            node.queue_free()
                            pass
                pass

func _draw():
    if dragging:
        draw_rect(Rect2(drag_start, get_global_mouse_position() - drag_start),
                Color(.5, .5, .5), false)

