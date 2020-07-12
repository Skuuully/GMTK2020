extends Node
class_name StealCommand

var rng = RandomNumberGenerator.new()

var target
var creator:String

var chanceSuccess:int
var chanceFail:int
var success:bool = false
var healAmount:int
var dmgAmount:int

var outOfControlEffectiveness:float = 1.0
var isOutOfControl:bool = false

func _init(_creator, _chanceSuccess, _chanceFail) -> void:
	rng.randomize()
	self.chanceSuccess = _chanceSuccess
	self.chanceFail = _chanceFail
	self.creator = _creator

func _ready() -> void:

	if creator == "Player":
		self.target = Globals.getPlayer()
	else:
		self.target = Globals.getEnemy()

func execute() -> void:
	var roll:int = rng.randi_range(0, chanceSuccess + chanceFail)
	success = (roll <= chanceSuccess)
	
	if success:
		healAmount = rng.randi_range(5, 8)
		if isOutOfControl:
			healAmount *= outOfControlEffectiveness as int
		target.heal(healAmount)
	else:
		dmgAmount = rng.randi_range(3, 6)
		if isOutOfControl:
			healAmount /= outOfControlEffectiveness as int
		target.takeDamage(dmgAmount)
	
	if creator == "Player":
		if success:
			Globals.createRisingLabel(true, true, "+" + str(healAmount))
		else:
			Globals.createRisingLabel(false, false, "-" + str(dmgAmount))
	
	queue_free()


func getLogString() -> String:
	var logStr = ""
	
	if isOutOfControl:
		if success:
			logStr += "Control was ripped from " + creator + "'s hands, blessing the stolen food\n"
		else:
			logStr += "Control was ripped from " + creator + "'s hands, softening the pain\n"
	
	if success:
		logStr += creator + " stole food and devoured healing for " + str(healAmount) + ".\n"
	else:
		logStr += creator + " stole from " + target.displayName + " but its pockets were lined with glass hurting by " + str(dmgAmount) + ".\n"
	
	return logStr + "\n"

func setOutOfControl(effectiveness:float) -> void:
	outOfControlEffectiveness = effectiveness
	isOutOfControl = true
