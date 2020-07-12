extends Control
class_name Enemy

export var MAXHP = 55
export var displayName = "Goblin"

onready var hp = $HP
onready var shield = $Shield
onready var displayNameLabel = $EnemyName
onready var labelSpawn = $LabelSpawnPos

var nextCommand
var rng = RandomNumberGenerator.new()
export var attackChance = 50
export var heavyAttackChance = 80
export var defendChance = 100

var attackMin = 8
var attackMax = 12

var defendMin = 15
var defendMax = 18

func isEnemy() -> void:
	pass

func takeDamage(damage) -> void:
	var residual = shield.takeDamage(damage)
	if (residual > 0):
		hp.takeDamage(residual)

func _ready():
	displayNameLabel.text = displayName
	hp.maxHP = MAXHP
	hp.currHP = MAXHP
	hp.updateDisplay()
	shield.updateDisplay()

func generateNextCommand() -> void:
	rng.randomize()
	var selected = rng.randi_range(0, 100)
	nextCommand = null
	if selected <= attackChance:
		nextCommand = AttackCommand.new(displayName, attackMin, attackMax)
	elif selected <= heavyAttackChance:
		nextCommand = DoubleAttackCommand.new(displayName, attackMin / 1.2, attackMax/ 1.2)
	elif selected <= defendChance:
		nextCommand = DefendCommand.new(displayName, defendMin, defendMax)
	
	if nextCommand == null:
		breakpoint
	
	get_tree().get_root().add_child(nextCommand)


func getLabelSpawnPos() -> Vector2:
	return labelSpawn.rect_global_position

func getCurrentHp() -> int:
	return hp.currHP

func revive() -> void:
	hp.maxHP *= 1.25
	hp.currHP = hp.maxHP
	hp.updateDisplay()
	shield.updateDisplay()
