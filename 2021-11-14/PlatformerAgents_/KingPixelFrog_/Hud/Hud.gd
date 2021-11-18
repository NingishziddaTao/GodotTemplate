extends CanvasLayer


var SaveSystem = Global.get_node("SaveSystem")
var KingPixelFrog_ = SaveSystem.get_resource(self, "KingPixelFrog_.tres")

func _ready() -> void:
    #KingPixelFrog_.connect("take_damage", self, "player_takes_damage")
    pass

func player_takes_damage(damage:int):
    var hearths = $HealthContainer.get_children()
    for i in range(damage):
        if hearths.size() > 0:
         
            hearths[-1].queue_free()
            hearths.pop_back()
