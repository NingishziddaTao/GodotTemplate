extends Control

var milli_seconds = 0
var minute = 0
var second = 0


func _ready() -> void:
    $label.text = str(milli_seconds)
    pass # Replace with function body.

func _process(delta: float) -> void:
    pass


func _on_timer_timeout() -> void:
    milli_seconds += 1
    _create_minute()
    _create_second()
    $label.text = str(minute)+":"+str(second)+":"+str(milli_seconds)
    
func _create_second():
    if milli_seconds > 99:
        second += 1
        milli_seconds = 0
            
func _create_minute():
    if second > 59:
        minute += 1
        second = 0       
    
    pass # Replace with function body.
