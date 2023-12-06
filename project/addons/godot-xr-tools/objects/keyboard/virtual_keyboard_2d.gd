@tool
class_name XRToolsVirtualKeyboard2D
extends CanvasLayer

@onready var player = $"../../../../../../../"

## Enumeration of keyboard view modes
enum KeyboardMode {
	LOWER_CASE,		## Lower-case keys mode
	UPPER_CASE,		## Upper-case keys mode
	ALTERNATE		## Alternate keys mode
}

var selectArray
var selectionCount

# Shift button down
var _shift_down := false

# Caps button down
var _caps_down := false

# Alt button down
var _alt_down := false

# Current keyboard mode
var _mode: int = KeyboardMode.LOWER_CASE


# Add support for is_xr_class on XRTools classes
func is_xr_class(name : String) -> bool:
	return name == "XRToolsVirtualKeyboard2D"


# Handle key pressed from VirtualKey
func on_key_pressed(scan_code_text: String, unicode: int, shift: bool):
	# Find the scan code
	var scan_code := OS.find_keycode_from_string(scan_code_text)

	# Create the InputEventKey
	var input := InputEventKey.new()
	input.physical_keycode = scan_code
	input.unicode = unicode if unicode else scan_code
	input.pressed = true
	input.keycode = scan_code
	input.shift_pressed = shift

	# Dispatch the input event
	Input.parse_input_event(input)

	# Pop any temporary shift key
	if _shift_down:
		$Background/Standard/ToggleShift.set_pressed_no_signal(false)
		_shift_down = false
		_update_visible()


func on_shift_toggle(button_pressed):
	# Update toggle keys
	$Background/Standard/ToggleCaps.set_pressed_no_signal(false)
	$Background/Standard/ToggleAlt.set_pressed_no_signal(false)
	_shift_down = button_pressed
	_caps_down = false
	_alt_down = false
	_update_visible()

# Handle caps-lock toggle
func on_caps_toggle(button_pressed):
	# Update toggle keys
	$Background/Standard/ToggleShift.set_pressed_no_signal(false)
	$Background/Standard/ToggleAlt.set_pressed_no_signal(false)
	_shift_down = false
	_caps_down = button_pressed
	_alt_down = false
	_update_visible()

func on_alt_toggle(button_pressed):
	# Update toggle keys
	$Background/Standard/ToggleShift.set_pressed_no_signal(false)
	$Background/Standard/ToggleCaps.set_pressed_no_signal(false)
	_shift_down = false
	_caps_down = false
	_alt_down = button_pressed
	_update_visible()

func _on_confirm_pressed():
	Input.action_press("EnterInput")

# Update switching the visible case keys
func _update_visible():
	# Evaluate the new mode
	var new_mode: int
	if _alt_down:
		new_mode = KeyboardMode.ALTERNATE
	elif _shift_down or _caps_down:
		new_mode = KeyboardMode.UPPER_CASE
	else:
		new_mode = KeyboardMode.LOWER_CASE

	# Skip if no change
	if new_mode == _mode:
		return

	# Update the visible mode
	_mode = new_mode
	$Background/LowerCase.visible = _mode == KeyboardMode.LOWER_CASE
	$Background/UpperCase.visible = _mode == KeyboardMode.UPPER_CASE
	$Background/Alternate.visible = _mode == KeyboardMode.ALTERNATE
func selectHelper():
	selectArray = player.selectArray
	selectionCount = player.selectionCount

func _on_assumption_pressed():
	selectHelper()
	if selectionCount == 1:
		selectArray[0].setJustification("assume", "Assume")


func _on_negation_introduction_pressed():
	selectHelper()
	if selectionCount == 1:
		selectArray[0].setJustification("notI", "¬I")


func _on_negation_elimination_pressed():
	selectHelper()
	if selectionCount == 1:
		selectArray[0].setJustification("notE", "¬E")


func _on_conjunction_introduction_pressed():
	selectHelper()
	if selectionCount == 1:
		selectArray[0].setJustification("andI", "∧I")


func _on_conjunction_elimination_pressed():
	selectHelper()
	if selectionCount == 1:
		selectArray[0].setJustification("andE", "∧E")


func _on_disjunction_introduction_pressed():
	selectHelper()
	if selectionCount == 1:
		selectArray[0].setJustification("orI", "∨I")


func _on_disjunction_elimination_pressed():
	selectHelper()
	if selectionCount == 1:
		selectArray[0].setJustification("orE", "∨E")


func _on_conditional_introduction_pressed():
	selectHelper()
	if selectionCount == 1:
		selectArray[0].setJustification("ifI", "→I")


func _on_conditional_elimination_pressed():
	selectHelper()
	if selectionCount == 1:
		selectArray[0].setJustification("ifE", "→E")


func _on_biconditional_introduction_pressed():
	selectHelper()
	if selectionCount == 1:
		selectArray[0].setJustification("iffI", "↔I")


func _on_biconditional_elimination_pressed():
	selectHelper()
	if selectionCount == 1:
		selectArray[0].setJustification("iffE", "↔E")


func _on_universal_introduction_pressed():
	selectHelper()
	if selectionCount == 1:
		selectArray[0].setJustification("forallI", "∀I")


func _on_universal_elimination_pressed():
	selectHelper()
	if selectionCount == 1:
		selectArray[0].setJustification("forallE", "∀E")


func _on_existential_introduction_pressed():
	selectHelper()
	if selectionCount == 1:
		selectArray[0].setJustification("existsI", "∃I")


func _on_existential_elimination_pressed():
	selectHelper()
	if selectionCount == 1:
		selectArray[0].setJustification("existsE", "∃E")

