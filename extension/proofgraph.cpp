#include "proofgraph.h"

using namespace godot;

LogNode::LogNode(){
    nodeID = 0;
    location = Vector3(0,0,0);
    data = "";
    HashSet<LogNode*> logParents;
    HashSet<LogNode*> logChildren;
}

/*
LogNode::LogNode(int nodeID, Vector3 location, int data){
    this->nodeID = nodeID;
    this->location = location;
    this->data = data;
    HashSet<LogNode*> neighbors;
}
*/

void LogNode::setNode(int nodeID, Vector3 location){
    this->nodeID = nodeID;
    this->location = location;
    this->data = data;
}

int LogNode::getID(){
    return nodeID;
    }

String LogNode::getData(){
    return data;
}

Vector3 LogNode::getPosition(){
    return location;
}

void LogNode::setData(String newData){
    this->data = newData;
}

void LogNode::_bind_methods(){
    ClassDB::bind_method(D_METHOD("setNode", "ID", "location"), &LogNode::setNode);
    ClassDB::bind_method(D_METHOD("getID"), &LogNode::getID);
    ClassDB::bind_method(D_METHOD("getData"), &LogNode::getData);
    ClassDB::bind_method(D_METHOD("getPosition"), &LogNode::getPosition);
    ClassDB::bind_method(D_METHOD("addData", "data"), &LogNode::setData);
}


ProofGraph::ProofGraph(){
    nodeCount = 0;
    HashMap<int, LogNode*> nodeMap;
}

ProofGraph::~ProofGraph(){
    for(auto& i : nodeMap){
        delete i.value;
    }
}
/*
void ProofGraph::addNode(Vector3 location, int data){
    LogNode temp = LogNode(nodeCount, location, data);
    nodeMap[nodeCount] = new LogNode(nodeCount, location, data);
    nodeCount++;
}
*/

void ProofGraph::addNode(LogNode* newNode){
    nodeMap[newNode->nodeID] = newNode;
    nodeCount++;
}

// Needs better check for node validity
void ProofGraph::addEdge(int start, int end){
    nodeMap[start]->logParents.insert(nodeMap[end]);
    nodeMap[end]->logChildren.insert(nodeMap[start]);
}

void ProofGraph::removeEdge(int start, int end){
    nodeMap[start]->logChildren.erase(nodeMap[end]);
    nodeMap[end]->logParents.erase(nodeMap[start]);
}

// Needs checks for node validity
void ProofGraph::removeNode(int deleteID){
    LogNode* temp = nodeMap[deleteID];
    for(auto& i : temp->logParents){
        i->logParents.erase(temp);
    }
    nodeMap.erase(deleteID);
    nodeCount--;
}

int ProofGraph::getNodeCount(){
    return nodeCount;
}

String ProofGraph::getNodeData(int targetNodeID){
    return nodeMap[targetNodeID]->data;
}



void ProofGraph::_bind_methods(){
    ClassDB::bind_method(D_METHOD("addNode", "newNode"), &ProofGraph::addNode);
    ClassDB::bind_method(D_METHOD("addEdge", "start", "end"), &ProofGraph::addEdge);
    ClassDB::bind_method(D_METHOD("removeEdge", "start", "end"), &ProofGraph::removeEdge);
    ClassDB::bind_method(D_METHOD("removeNode", "node_ID"), &ProofGraph::removeNode);
    ClassDB::bind_method(D_METHOD("getNodeCount"), &ProofGraph::getNodeCount);
    ClassDB::bind_method(D_METHOD("getData", "nodeID"), &ProofGraph::getNodeData);

}
