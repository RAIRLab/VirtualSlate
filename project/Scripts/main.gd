extends Node

@export var pg: ProofGraph

func initializeProofGraph():
	pg = ProofGraph.new()
	pg.set_name("ProofGraph")
	self.add_child(pg)
	return pg
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pg = initializeProofGraph()
	pg.addNode(Vector3(-8,12,-25))
	pg.addNode(Vector3(8,6,-25))
	pg.addNode(Vector3(0,-3,-25))
	get_node("ProofGraph/0").setData("p")
	get_node("ProofGraph/1").setData("p→q")
	get_node("ProofGraph/2").setData("q")
	
	pg.addEdge(get_node("ProofGraph/0"), get_node("ProofGraph/2"))
	pg.addEdge(get_node("ProofGraph/1"), get_node("ProofGraph/2"))
	
	get_node("ProofGraph/0").setJustification("assume", "Assume")
	get_node("ProofGraph/1").setJustification("assume", "Assume")
	get_node("ProofGraph/2").setJustification("ifE", "→E")
	
	#Loading standard 3D player character
	var standard3D = load("res://Scenes/PlayerCharacter.tscn").instantiate()
	self.add_child(standard3D)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	pass
