extends CanvasLayer
class_name Dialog

onready var hider = $Hider
onready var textArea = $TextArea
onready var nextPrompt = $NextPrompt

func _ready():
	hideAll()

func hideAll() -> void:
	hider.visible = false
	textArea.visible = false
	nextPrompt.visible = false

func showAll() -> void:
	hider.visible = true
	textArea.visible = true
	nextPrompt.visible = true

func displayText(string:String) -> void:
	textArea.text = string

func isDialog() -> void:
	pass
