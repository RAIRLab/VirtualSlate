#include "proofgraph.h"

using namespace godot;

LogNode::LogNode(){
    nodeID = 0;
    location = Vector3(0,0,0);
    data = 0;
    HashSet<LogNode*> neighbors; 
}

LogNode::LogNode(int nodeID, Vector3 location, int data){
    this->nodeID = nodeID;
    this->location = location;
    this->data = data;
    HashSet<LogNode*> neighbors;
}

void LogNode::_bind_methods(){
}

ProofGraph::ProofGraph(){
    nodeCount = 0;
    HashMap<int, LogNode*> nodeMap;
}

ProofGraph::~ProofGraph(){
    for(auto& i : nodeMap){
        nodeMap.erase(i.key);
    }
}

void ProofGraph::addNode(Vector3 location, int data){
    LogNode temp = LogNode::LogNode(nodeCount, location, data);
    nodeMap[nodeCount] = &(LogNode(nodeCount, location, data));
    nodeCount++;
}

// Needs better check for node validity
void ProofGraph::addEdge(int start, int end){
    nodeMap[start]->neighbors.insert(nodeMap[end]);
}

// Needs checks for node validity
void ProofGraph::removeNode(int deleteID){
    LogNode* temp = nodeMap[deleteID];
    for(auto& i : temp->neighbors){
        i->neighbors.erase(temp);
    }
    nodeMap.erase(deleteID);
}

int ProofGraph::getNodeCount(){
    return nodeCount;
}

int ProofGraph::getNodeData(int targetNodeID){
    return nodeMap[targetNodeID]->data;
}

void ProofGraph::_bind_methods(){
    ClassDB::bind_method(D_METHOD("addNode", "location", "data"), &ProofGraph::addNode);
    ClassDB::bind_method(D_METHOD("addEdge", "start", "end"), &ProofGraph::addEdge);
    ClassDB::bind_method(D_METHOD("removeNode", "node_ID"), &ProofGraph::removeNode);
    ClassDB::bind_method(D_METHOD("getNodeCount"), &ProofGraph::getNodeCount);
    ClassDB::bind_method(D_METHOD("getData", "nodeID"), &ProofGraph::getNodeData);

}
