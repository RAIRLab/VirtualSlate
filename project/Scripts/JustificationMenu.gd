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
		selectArray[0].setJustification("assume", "Assume")


func _on_negation_introduction_pressed():
	if selectionCount == 1:
		selectArray[0].setJustification("notI", "¬I")


func _on_negation_elimination_pressed():
	if selectionCount == 1:
		selectArray[0].setJustification("notE", "¬E")


func _on_conjunction_introduction_pressed():
	if selectionCount == 1:
		selectArray[0].setJustification("andI", "∧I")


func _on_conjunction_elimination_pressed():
	if selectionCount == 1:
		selectArray[0].setJustification("andE", "∧E")


func _on_disjunction_introduction_pressed():
	if selectionCount == 1:
		selectArray[0].setJustification("orI", "∨I")


func _on_disjunction_elimination_pressed():
	if selectionCount == 1:
		selectArray[0].setJustification("orE", "∨E")


func _on_conditional_introductionon_pressed():
	if selectionCount == 1:
		selectArray[0].setJustification("ifI", "⇒I")


func _on_conditional_elimination_pressed():
	if selectionCount == 1:
		selectArray[0].setJustification("ifE", "⇒E")


func _on_biconditional_introduction_pressed():
	if selectionCount == 1:
		selectArray[0].setJustification("iffI", "⇔I")


func _on_biconditional_elimination_pressed():
	if selectionCount == 1:
		selectArray[0].setJustification("iffE", "⇔E")


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
