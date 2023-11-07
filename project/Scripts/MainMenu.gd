extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_standard_pressed():
	var standard = load("res://Scenes/PlayerCharacter.tscn").instantiate()
	get_tree().get_root().add_child(standard)
	self.queue_free()


func _on_virtual_reality_pressed():
	pass # Replace with function body.


func _on_exit_pressed():
	get_tree().quit()
