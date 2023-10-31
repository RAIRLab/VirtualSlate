extends Node
func initializeProofGraph():
	var pg = ProofGraph.new()
	pg.set_name("ProofGraph")
	self.add_child(pg)
	return pg
	
@export var pg: ProofGraph

	
# Called when the node enters the scene tree for the first time.
func _ready():
	pg = initializeProofGraph()
	pg.addNode(Vector3(-8,12,0))
	pg.addNode(Vector3(8,6,0))
	pg.addNode(Vector3(0,-3,0))
	get_node("ProofGraph/0").setData("pvq")
	get_node("ProofGraph/1").setData("qvp")
	get_node("ProofGraph/2").setData("p")
	
	print(pg.getData(0))
	print(pg.getData(1))
	print(pg.getData(2))
	
	pg.addEdge(get_node("ProofGraph/0"), get_node("ProofGraph/2"))
	pg.addEdge(get_node("ProofGraph/1"), get_node("ProofGraph/2"))
	
	
	
	


	
	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	pass
