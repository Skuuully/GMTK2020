extends Node

var playerNode = null
var enemyNode = null
var dialogNode = null

var world = null

func getPlayer() -> Player:
	if playerNode == null:
		for child in getWorld().get_children():
			if child.has_method("isPlayer"):
				playerNode = child

	return playerNode

func getEnemy() -> Node:
	for child in getWorld().get_children():
		if child.has_method("isEnemy"):
			enemyNode = child

	return enemyNode

func getWorld() -> Node:
	if world == null:
		world = get_tree().get_root().find_node("World", false, false)

	return world

func getDialog() -> Node:
	if dialogNode == null:
		for child in getWorld().get_children():
			if child.has_method("isDialog"):
				dialogNode = child

	return dialogNode

func createRisingLabel(playerLocation:bool, positive:bool, text:String) -> void:
	var label:RiseAndFadeLabel = RiseAndFadeLabel.new(text, positive)
	get_tree().get_root().add_child(label)
	if playerLocation:
		label.rect_position = getPlayer().getLabelSpawnPos()
	else:
		label.rect_position = getEnemy().getLabelSpawnPos()
