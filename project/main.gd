extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	var n = ProofGraph.new()
	n.addNode(Vector3(1,2,3), 2)
	n.addNode(Vector3(1,2,3), 3)
	n.addNode(Vector3(1,2,3), 4)
	n.addNode(Vector3(1,2,3), 5)
	
	print(n.getNodeCount())
	print(n.getData(3))





# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
