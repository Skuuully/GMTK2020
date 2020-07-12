extends Node
class_name DoubleAttackCommand

var rng = RandomNumberGenerator.new()

var attackMin:int
var attackMax:int
var attackVal:int
var attackVal2:int
var target
var creator:String

var outOfControlEffectiveness:float = 1.0
var isOutOfControl:bool = false

func _init(_creator, _attackMin, _attackMax) -> void:
	rng.randomize()
	self.attackMin = _attackMin
	self.attackMax = _attackMax
	self.creator = _creator

func _ready() -> void:
	# Setup target to be only enemy
	var treeRoot = get_tree().get_root()
	var world = treeRoot.find_node("World", false, false)
	if creator == "Player":
		for child in world.get_children():
			if child.has_method("isEnemy"):
				self.target = child
				break
	else:
		for child in world.get_children():
			if child.has_method("isPlayer"):
				self.target = child
				break

func execute() -> void:
	var roll:int = rng.randi_range(attackMin, attackMax)
	var roll2:int = rng.randi_range(attackMin, attackMax)
	if isOutOfControl:
		roll *= outOfControlEffectiveness as int
		roll2 *= outOfControlEffectiveness as int
	
	attackVal = roll
	attackVal2 = roll2
	self.target.takeDamage(attackVal)
	self.target.takeDamage(attackVal2)
	
	if creator == "Player":
		Globals.createRisingLabel(false, false, "-" + str(attackVal))
		yield(get_tree().create_timer(0.3), "timeout")
		Globals.createRisingLabel(false, false, "-" + str(attackVal2))
	else:
		Globals.createRisingLabel(true, false, "-" + str(attackVal))
		yield(get_tree().create_timer(0.3), "timeout")
		Globals.createRisingLabel(true, false, "-" + str(attackVal2))
		
	queue_free()


func getLogString() -> String:
	var logStr = ""
	if isOutOfControl:
		logStr += "Control was ripped from " + creator + "'s hands\n"
	
	logStr += creator + " attacked " + target.displayName + " for " + str(attackVal) + " damage.\n"
	logStr += creator + " followed up with another attack against " + target.displayName + " for " + str(attackVal2) + " damage.\n"
	
	return logStr + "\n"

func setOutOfControl(effectiveness:float) -> void:
	outOfControlEffectiveness = effectiveness
	isOutOfControl = true
