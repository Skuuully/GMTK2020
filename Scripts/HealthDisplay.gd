extends Control

var maxHP:int = 10
var currHP:int = maxHP

onready var hpNum = $CurrentHP
onready var hpBar = $TextureProgress

func _ready():
	updateDisplay()
	pass

func takeDamage(damage:int) -> void:
	currHP -= damage
	if currHP < 0:
		currHP = 0

	updateDisplay()

func heal(heal:int) -> void:
	currHP += heal
	if currHP > maxHP:
		currHP = maxHP
	
	updateDisplay()

func updateDisplay() -> void:
	hpNum.text = str(currHP)
	hpBar.set_value((currHP as float / maxHP as float) * 100.0)
	pass
