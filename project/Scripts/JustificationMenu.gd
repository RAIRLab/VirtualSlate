extends Control

var selectArray
var selectionCount

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	selectArray = $"../CharacterBody3D".selectArray
	selectionCount = $"../CharacterBody3D".selectionCount


func _on_assumption_pressed():
	if selectionCount == 1:
		selectArray[0].setJustification("Assumption", "Assume")


func _on_negation_introduction_pressed():
	if selectionCount == 1:
		selectArray[0].setJustification("NotIntro", "¬I")


func _on_negation_elimination_pressed():
	if selectionCount == 1:
		selectArray[0].setJustification("NotElim", "¬E")


func _on_conjunction_introduction_pressed():
	if selectionCount == 1:
		selectArray[0].setJustification("AndIntro", "∧I")


func _on_conjunction_elimination_pressed():
	if selectionCount == 1:
		selectArray[0].setJustification("AndElim", "∧E")


func _on_disjunction_introduction_pressed():
	if selectionCount == 1:
		selectArray[0].setJustification("OrIntro", "∨I")


func _on_disjunction_elimination_pressed():
	if selectionCount == 1:
		selectArray[0].setJustification("OrElim", "∨E")


func _on_conditional_introductionon_pressed():
	if selectionCount == 1:
		selectArray[0].setJustification("IfIntro", "→I")


func _on_conditional_elimination_pressed():
	if selectionCount == 1:
		selectArray[0].setJustification("IfElim", "→E")


func _on_biconditional_introduction_pressed():
	if selectionCount == 1:
		selectArray[0].setJustification("IffIntro", "↔I")


func _on_biconditional_elimination_pressed():
	if selectionCount == 1:
		selectArray[0].setJustification("IffElim", "↔E")


func _on_universal_introduction_pressed():
	if selectionCount == 1:
		selectArray[0].setJustification("forallI", "∀I")


func _on_universal_elimination_pressed():
	if selectionCount == 1:
		selectArray[0].setJustification("forallE", "∀E")


func _on_existential_introduction_pressed():
	if selectionCount == 1:
		selectArray[0].setJustification("existsI", "∃I")


func _on_existential_elimination_pressed():
	if selectionCount == 1:
		selectArray[0].setJustification("existsE", "∃E")
