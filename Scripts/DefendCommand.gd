extends Node
class_name DefendCommand

var rng = RandomNumberGenerator.new()

var defendMin:int
var defendMax:int
var defendVal:int
var creator:String

var outOfControlEffectiveness:float = 1.0
var isOutOfControl:bool = false

func _init(_creator, _defendMin, _defendMax) -> void:
	rng.randomize()
	defendMin = _defendMin
	defendMax = _defendMax
	creator = _creator

func execute() -> void:
	var roll:int = rng.randi_range(defendMin, defendMax)
	if isOutOfControl:
		roll *= outOfControlEffectiveness as int
	
	defendVal = roll
	if creator == "Player":
		Globals.getPlayer().shield.strengthen(defendVal)
		Globals.createRisingLabel(true, true, "+" + str(defendVal))
	else:
		Globals.getEnemy().shield.strengthen(defendVal)
		Globals.createRisingLabel(false, true, "+" + str(defendVal))
	
	queue_free()

func getLogString() -> String:
	var logStr = ""
	if isOutOfControl:
		logStr += "Control was ripped from " + creator + "'s hands\n"
	
	logStr += creator + " defends self for " + str(defendVal) + " damage.\n"
	
	return logStr + "\n"

func setOutOfControl(effectiveness:float) -> void:
	outOfControlEffectiveness = effectiveness
	isOutOfControl = true
