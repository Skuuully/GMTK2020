extends Control
class_name Player

export var MAXHP = 100
export var displayName = "Player"

onready var hp = $HP
onready var shield = $Shield
onready var displayNameLabel = $DisplayNameLabel
onready var labelSpawn = $LabelSpawnPos


func takeDamage(damage) -> void:
	var residual = shield.takeDamage(damage)
	if (residual > 0):
		hp.takeDamage(residual)

func getCurrentHp() -> int:
	return hp.currHP

func heal(heal) -> void:
	hp.heal(heal)

func _ready():
	displayNameLabel.text = displayName
	hp.maxHP = MAXHP
	hp.currHP = MAXHP
	hp.updateDisplay()

func isPlayer() -> void:
	pass

func getLabelSpawnPos() -> Vector2:
	return labelSpawn.rect_global_position

