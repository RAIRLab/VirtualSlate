extends WorldEnvironment


# Called when the node enters the scene tree for the first time.
func _ready():
	#Messing around with proof graph in godot
	var p = ProofGraph.new()
	p.addNode(Vector3(1,1,1), 111)
	p.addNode(Vector3(1,2,3), 123)
	p.addNode(Vector3(2,2,2), 222)
	p.addEdge(1,2)
	p.addEdge(2,3)
	p.removeNode(2)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
