extends Node

signal enter

var text = []
var currPoint:int = 0

var display

func _ready():
	text.clear()
	text.push_back("I only have so much control over my actions")
	text.push_back("I can merely attempt to control myself")
	text.push_back("I feel that losing myself will amplify my actions")
	text.push_back("A goblin approaches...")
	
	text.push_back("The goblin was triumphantly slain")
	text.push_back("However it returns to life as if by magic")
	
	text.push_back("You feel that this may keep happening...")
	text.push_back("Thanks for playing")
	
	text.push_back("The hero fell to his knees as he was bested by the goblin")

func _input(event):
	if event.is_pressed():
		emit_signal("enter")
		pass

func sequence0() -> void:
	var dialog:Dialog = Globals.getDialog()
	dialog.showAll()
	dialog.displayText(text[0])
	yield(self, "enter")
	dialog.displayText(text[1])
	yield(self, "enter")
	dialog.displayText(text[2])
	yield(self, "enter")
	dialog.displayText(text[3])
	yield(self, "enter")
	dialog.hideAll()

func sequence1() -> void:
	var dialog:Dialog = Globals.getDialog()
	dialog.showAll()
	dialog.displayText(text[4])
	yield(self, "enter")
	dialog.displayText(text[5])
	yield(self, "enter")
	dialog.hideAll()

func sequence2() -> void:
	var dialog:Dialog = Globals.getDialog()
	dialog.showAll()
	dialog.displayText(text[4])
	yield(self, "enter")
	dialog.displayText(text[5])
	yield(self, "enter")
	dialog.displayText(text[6])
	yield(self, "enter")
	dialog.displayText(text[7])
	yield(self, "enter")
	dialog.hideAll()

func fail() -> void:
	var dialog:Dialog = Globals.getDialog()
	dialog.showAll()
	dialog.displayText(text[8])
	yield(self, "enter")
	dialog.displayText(text[7])
	yield(self, "enter")
	# Reload game
	var ok = get_tree().change_scene("res://Scenes/World.tscn")
	
	# If reload fails just quit
	if ok != OK:
		get_tree().quit()

func advance() -> void:
	match currPoint:
		0:
			sequence0()
		1:
			sequence1()
		2:
			sequence2()
	
	currPoint += 1
	if currPoint > 2:
		currPoint = 2
