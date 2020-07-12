extends Node

signal readyUp()

var selectors = []
var rng = RandomNumberGenerator.new()
var nextCommand

var maxSelectable:int = 10
var numPreselected:int = 3
var numSelected:int = numPreselected

onready var readyButton = $ReadyButton/TextureButton
onready var remainingLabel = $RemainingLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	reloadSelectors()
	readyButton.connect("pressed", self, "_onReadyPressed")
	pass # Replace with function body.

func reloadSelectors() -> void:
	numSelected = 0
	selectors.clear()
	for child in get_children():
		if child is Selector:
			selectors.push_back(child)
			child.connect("decreased", self, "_onSelectorDecrease")
			child.connect("increased", self, "_onSelectorIncrease")
			numSelected += child.num
	remainingLabel.updateDisplay(numSelected, maxSelectable)

func _onReadyPressed() -> void:
	var count = []
	var countCurr:int = 0
	for selector in selectors:
		selector = selector as Selector
		count.push_back(selector.getNumSelected() + countCurr)
		countCurr += selector.getNumSelected()

	if countCurr < maxSelectable:
		#throw some error to tell player to select the rest
		pass
	else:
		readyButton.disabled = true
		generateNextCommand(count)

func generateNextCommand(count) -> void:
	var rand:int = rng.randi_range(0, maxSelectable)
	var chosenSelector:Selector
	for i in range(0, count.size(), 1):
		if count[i] >= rand:
			chosenSelector = selectors[i]
			break
	
	if chosenSelector == null:
		breakpoint
	
	
	rand = rng.randi_range(0, chosenSelector.getNumSelected())
	var playerDecision:bool = (rand > chosenSelector.getNumPreSelected())
	
	nextCommand = null
	match chosenSelector.getTag():
		"Attack":
			nextCommand = AttackCommand.new("Player", PlayerGlobals.attackMin, PlayerGlobals.attackMax)
		"Defend":
			nextCommand = DefendCommand.new("Player", PlayerGlobals.defendMin, PlayerGlobals.defendMax)
		"Steal":
			nextCommand = StealCommand.new("Player", PlayerGlobals.stealSuccess, PlayerGlobals.stealFail)
		"DoubleAttack":
			nextCommand = DoubleAttackCommand.new("Player", PlayerGlobals.attackMin, PlayerGlobals.attackMax)
	
	if nextCommand == null:
		breakpoint
	
	get_tree().get_root().add_child(nextCommand)
	
	if !playerDecision:
		nextCommand.setOutOfControl(PlayerGlobals.outOfControlEffectiveness)
	
	emit_signal("readyUp")

func randomiseSelectors() -> void:
	# Always give attack and defend selectors
	var numSelectors = selectors.size()
	
	var remaining = numPreselected
	numPreselected = 0
	for selector in selectors:
		var ind:int = selectors.find(selector)
		if ind == (numSelectors - 1):
			numPreselected += remaining
			selector.setPreSelected(remaining)
		else:
			var preselect:int = rng.randi_range(0, remaining)
			selector.setPreSelected(preselect)
			remaining -= preselect
			numPreselected += preselect
	numSelected = numPreselected
	remainingLabel.updateDisplay(numSelected, maxSelectable)


func getNextCommand() -> Object:
	return nextCommand

func enableReady() -> void:
	readyButton.disabled = false

func _onSelectorDecrease() -> void:
	numSelected -= 1
	if numSelected < maxSelectable:
		informSelectorsMaxed(false)
	remainingLabel.updateDisplay(numSelected, maxSelectable)
	
func _onSelectorIncrease() -> void:
	numSelected += 1
	if numSelected == maxSelectable:
		informSelectorsMaxed(true)
	remainingLabel.updateDisplay(numSelected, maxSelectable)

func informSelectorsMaxed(maxed:bool) -> void:
	for selector in selectors:
		selector.maxed = maxed
