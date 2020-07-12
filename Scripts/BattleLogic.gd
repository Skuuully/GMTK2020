extends Node
class_name BattleLogic


var enemy

onready var pInput = $PlayerInput
onready var battleTextLog = $BattleLog/TextureRect2/BattleText

var first:bool = true


func _ready():
	pInput.connect("readyUp", self, "_onPlayerReady")
	var world = get_tree().get_root().find_node("World", false, false)
	for child in world.get_children():
		if child is Enemy:
			enemy = child
	
	battleTextLog.scroll_following = true
	Story.advance()
	

func _onPlayerReady() -> void:
	var command = pInput.getNextCommand()
	command.execute()
	writeToBattleLog(command.getLogString())
	yield(get_tree().create_timer(0.3), "timeout")

	
	# Check for enemy killed
	if enemy.getCurrentHp() <= 0:
		Story.advance()
		enemy.revive()
	
	# Do enemy action
	if first:
		enemy.generateNextCommand()
		first = false
	command = enemy.nextCommand
	command.execute()
	writeToBattleLog(command.getLogString())
	enemy.generateNextCommand()
	yield(get_tree().create_timer(0.3), "timeout")
	
	# Check for player killed
	if Globals.getPlayer().getCurrentHp() <= 0:
		Story.fail()
	
	# Randomise players selectors, re enable the ready button
	pInput.randomiseSelectors()
	pInput.enableReady()
	pass

func writeToBattleLog(val:String):
	battleTextLog.text += val
	pass

