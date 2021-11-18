tool
extends Position2D

var results:Dictionary
var collision:bool
var result_array:Array

export(bool) var rays_visible
export(Vector2) var cast_to = Vector2(0, 20)
export(int) var rays_amount = 10

func _ready() -> void:
    #print('Parents/KINEMATIC_BODY_2D/mats/cayote.gd: ' , get_world_2d())
    pass

    
func _physics_process(delta: float) -> void:
    update()

func _draw() -> void:
    result_array = []
    var p = get_parent()
    var space_state = get_world_2d().direct_space_state
    var e = gizmo_extents
    for x in range(-e, e, e / rays_amount):
        var xOffset = Vector2(x, 0)

        results = space_state.intersect_ray(global_position+xOffset, global_position+xOffset+cast_to, [self, p])
        if results:
            result_array.append(results)
            draw_line(xOffset, results.position - p.position.rotated(-rotation), Color(1, 4, 1, rays_visible))
            collision = true
        if result_array.empty():
            collision = false

    pass
   
