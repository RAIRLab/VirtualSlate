extends Node

#Test addNode
func test_addNode():
	var graph = ProofGraph.new()
	for i in range(0, 50, 1):
		var nodeInfo = {"location": [i, i+1, i+2], "node_id": i}
		graph.addNode(nodeInfo)
	
	var currGraph = graph.get_node_map()
	for i in range(50, 0, -1):
		var curr = currGraph[i]
		assert(curr.node_id == i)
		assert(curr.location[0] == i)
		assert(curr.location[1] == i+1)
		assert(curr.location[2] == i+2)
	assert(graph.get_size() == 50)

#Test addEdge
func test_addEdge():
	var graph = ProofGraph.new()
	for i in range(0, 50, 1):
		var nodeInfo = {"location": [i, i+1, i+2], "node_id": i}
		graph.addNode(nodeInfo)
	for i in range(0, 50, 1):
		if i == 12:
			continue
		graph.addEdge(12, i)
	var graphNodes = graph.get_node_map()
	var twelve = graphNodes[12]
	for curr in graphNodes:
		if curr.second == twelve:
			assert(curr.second.neighbors.size() == 49)
		else:
			assert(curr.second.neighbors.size() == 1)

#Test removeNode
func test_removeNode():
	var graph = ProofGraph.new()
	var answer = ProofGraph.new()
	for i in range(0, 50, 1):
		var nodeInfo = {"location": [i, i+1, i+2], "node_id": i}
		answer.addNode(nodeInfo) 
		graph.addNode(nodeInfo)
	for i in range(0, 50, 1):
		if i == 12:
			continue
		graph.addEdge(12, i)
	graph.removeNode(12)
	answer.removeNode(12)
	assert(graph.representation, answer.representation)

#Test removeNodeWithoutEdges
func test_removeNodeWithoutEdges():
	var graph = ProofGraph.new()
	var answer = ProofGraph.new()
	graph.removeNode(0)
	assert(graph.getNodeMap().size() == 0)
	var nodeInfo = {"location": [0, 0, 0], "node_id": 0}
	graph.addNode(nodeInfo)
	assert(graph.getNodeMap().size() == 0)
	graph = ProofGraph.new()
	
	for i in range(0, 50 ,1):
		answer.addNode(nodeInfo)
		graph.addNode(nodeInfo)
	
	for i in range(0, 50, 1):
		if i%2 != 0:
			graph.removeNode(i)
	
	var graphNodes = graph.getNodeMap()
	var answerNodes = answer.getNodeMap()
	
	for i in range(0, 50, 1):
		if i%2 == 0:
			assert(graphNodes.find(i) == graphNodes.end() == false)
			answer = answerNodes[i]
			var graphNode = graphNodes[i]
			assert(answer.location[0] == graphNode.location[0])
			assert(answer.location[1] == graphNode.location[1])
			assert(answer.location[2] == graphNode.location[2])
		
		else:
			assert(graphNodes.find(i) == graphNodes.end() == true)
		assert(graphNodes.size() == 25)

func run_tests():
	test_addNode()
	test_addEdge()
	test_removeNode()
	test_removeNodeWithoutEdges()

func ready():
	run_tests()
