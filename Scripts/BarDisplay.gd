extends Control

var textures = []

var selectTexture = preload("res://Sprites/Full.png")
var unselectTexture = preload("res://Sprites/Empty.png")
var preselectedTexture = preload("res://Sprites/Preselected.png")

func _ready() -> void:
	for child in get_children():
		if child is TextureRect:
			textures.push_back(child)
			

func updateDisplay(numSelected:int, preselected:int) -> void:
	for i in range(0, textures.size(), 1):
		var texture = textures[i] as TextureRect
		i += 1

		if i > numSelected:
			texture.texture = unselectTexture
		elif i > preselected:
			texture.texture = selectTexture
		else:
			texture.texture = preselectedTexture

