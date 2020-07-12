extends Node2D
class_name Selector

signal increased()
signal decreased()

var numPreselected:int = 1
var numMax:int = 5
var num:int = numPreselected

var maxed:bool = false

export var TITLE = "Selector Title Here"

# tag  shows the type that this node, represents 'Attack' for attack, 'Defend' for defend etc.
export var tag:String = "" 

onready var numText = $Display
onready var titleText = $TitleText
onready var upArrow = $UpArrow
onready var downArrow = $DownArrow
onready var barDisplay = $SelectedDisplay


# Called when the node enters the scene tree for the first time.
func _ready():
	titleText.text = TITLE
	_updateDisplay()
	upArrow.connect("pressed", self, "_onUpPress");
	downArrow.connect("pressed", self, "_onDownPress");

func _updateDisplay() -> void:
	numText.text = str(num)
	barDisplay.updateDisplay(num, numPreselected)

func _onDownPress() -> void:
	if num - 1 >= numPreselected:
		num -= 1
		emit_signal("decreased")
		_updateDisplay()
	
func _onUpPress() -> void:
	if !maxed:
		if num + 1 <= numMax:
			num += 1
			emit_signal("increased")
			_updateDisplay()

func getNumSelected() -> int:
	return num

func getNumPreSelected() -> int:
	return numPreselected

func getTag() -> String:
	return tag

func setPreSelected(inNum:int) -> void:
	maxed = (inNum == numMax)
	numPreselected = inNum
	num = numPreselected
	_updateDisplay()
