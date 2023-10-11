extends LogNode


# Called when the node enters the scene tree for the first time.
func _ready():
	var n = LogNode.new()
	print(n.get_data())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
