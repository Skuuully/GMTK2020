extends Control
class_name Shield

var currShield:int = 0

onready var shieldNum = $ShieldNum
onready var shieldTexture = $ShieldTexture

func _ready():
	updateDisplay()
	pass

func strengthen(strength:int) -> void:
	if currShield <= 0:
		shieldNum.visible = true
		shieldTexture.visible = true
	
	currShield += strength
	updateDisplay()

func takeDamage(damage:int) -> int:
	currShield -= damage
	var residual:int = 0
	if currShield < 0:
		residual = abs(currShield) as int
		currShield = 0

	updateDisplay()
	
	return residual

func updateDisplay() -> void:
	shieldNum.text = str(currShield)
	if currShield <= 0:
		shieldNum.visible = false
		shieldTexture.visible = false
