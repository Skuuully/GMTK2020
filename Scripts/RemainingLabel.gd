extends Label


func updateDisplay(selected:int, total:int) -> void:
	text = "Remaining: " + str(selected) + "/" + str(total)

