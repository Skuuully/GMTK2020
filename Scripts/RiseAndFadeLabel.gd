extends Label
class_name RiseAndFadeLabel

var riseAmount = -0.33

func _init(inText:String, positive:bool):
	text = inText
	modulate.a = 1
	modulate.g = 0
	modulate.r = 0
	modulate.b = 0
	if positive:
		modulate.g = 1
	else:
		modulate.r = 1

func _process(delta):
	modulate.a -= 1.3 * delta
	rect_position.y += riseAmount
	if modulate.a <= 0:
		queue_free()
