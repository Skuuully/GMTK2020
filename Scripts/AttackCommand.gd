extends Node
class_name AttackCommand

var rng = RandomNumberGenerator.new()

var attackMin:int
var attackMax:int
var attackVal:int
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
	if isOutOfControl:
		roll *= outOfControlEffectiveness as int
	
	attackVal = roll
	self.target.takeDamage(attackVal)
	
	if creator == "Player":
		Globals.createRisingLabel(false, false, "-" + str(attackVal))
	else:
		Globals.createRisingLabel(true, false, "-" + str(attackVal))
	
	queue_free()


func getLogString() -> String:
	var logStr = ""
	if isOutOfControl:
		logStr += "Control was ripped from " + creator + "'s hands\n"
	
	logStr += creator + " attacked " + target.displayName + " for " + str(attackVal) + " damage.\n"
	
	return logStr + "\n"

func setOutOfControl(effectiveness:float) -> void:
	outOfControlEffectiveness = effectiveness
	isOutOfControl = true
