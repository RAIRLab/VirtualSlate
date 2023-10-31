#include "proofgraph.h"

using namespace godot;

LogNode::LogNode(){
    nodeID = 0;
    data = "";
    HashSet<LogNode*> logParents;
    HashSet<LogNode*> logChildren;
}

void LogNode::setID(int nodeID){
    this->nodeID = nodeID;
}

int LogNode::getID(){
    return nodeID;
    }

String LogNode::getData(){
    return data;
}

void LogNode::setData(String newData){
    this->data = newData;
    // Removal of old text mesh if it exists
    Node* oldText = get_node_or_null("Data");
    if(oldText != NULL){
        remove_child(oldText);
        oldText->queue_free();
    }
    // Creation of a new text mesh
    MeshInstance3D* newText = memnew(MeshInstance3D);
    newText->set_name("Data");
    add_child(newText);
    TextMesh* letters = memnew(TextMesh);
    newText->set_mesh(letters);
    letters->TextMesh::set_text(newData);
    newText->global_scale(Vector3(13,13,5));

}

bool LogNode::isChild(LogNode* potentialChild){
    if (logChildren.find(potentialChild) != logChildren.end()) {
        return true;
    }
    else {
        return false;
    }
}

void LogNode::_bind_methods(){
    ClassDB::bind_method(D_METHOD("setID", "ID"), &LogNode::setID);
    ClassDB::bind_method(D_METHOD("getID"), &LogNode::getID);
    ClassDB::bind_method(D_METHOD("getData"), &LogNode::getData);
    ClassDB::bind_method(D_METHOD("setData", "data"), &LogNode::setData);
    ClassDB::bind_method(D_METHOD("isChild", "potentialChild"), &LogNode::isChild);
}

ProofGraph::ProofGraph(){
    nodeCount = 0;
    nodeIDCount = 0;
    HashMap<int, LogNode*> nodeMap;
}

ProofGraph::~ProofGraph(){
    for(auto& i : nodeMap){
        nodeMap.erase(i.key);
    }
}

void ProofGraph::addNode(Vector3 position){
    // Godot specific method of allocating memory to objects
    LogNode* newNode = memnew(LogNode);
    newNode->setID(nodeIDCount);
    nodeMap[newNode->nodeID] = newNode;
    // Naming object for use in Godot scene tree pathing
    newNode->set_name(String::num_int64(nodeIDCount));
    add_child(newNode);
    newNode->set_global_position(position);
    nodeCount++;
    nodeIDCount++;

    //Creating the box mesh
    MeshInstance3D* box = memnew(MeshInstance3D);
    box->set_name("box");
    BoxMesh* shape = memnew(BoxMesh);
    StandardMaterial3D* skin = memnew(StandardMaterial3D);
    newNode->add_child(box);
    box->set_mesh(shape);
    box->set_material_override(skin);
    box->global_scale(Vector3(10,5,2));
    skin->set_transparency(BaseMaterial3D::TRANSPARENCY_ALPHA);
    skin->set_albedo(Color(0.5, 0.75, 0.75, 0.25));

    //Text mesh for ID
    MeshInstance3D* idText = memnew(MeshInstance3D);
    idText->set_name("ID");
    newNode->add_child(idText);
    TextMesh* numbers = memnew(TextMesh);
    idText->set_mesh(numbers);
    numbers->TextMesh::set_text("ID: " + String::num_int64(newNode->getID()));
    idText->set_position(Vector3(-3, 1.45, 0));
    idText->global_scale(Vector3(8,8,5));

    //Physics collider for ray casts

    CollisionShape3D* physBody = memnew(CollisionShape3D);
    BoxShape3D* physBox = memnew(BoxShape3D);
    StaticBody3D* nodeCollider = memnew(StaticBody3D);
    nodeCollider->set_name("nodeCollider");
    newNode->add_child(nodeCollider);
    nodeCollider->add_child(physBody);
    physBody->set_shape(physBox);
    physBody->set_scale(Vector3(10,5,2));
}

void ProofGraph::edgeSetter(LogNode* start, LogNode* end, MeshInstance3D* workingEdge){
    Vector3 boxOffset = Vector3(0,2.5,0);
    Vector3 sPos = start->get_global_position();
    Vector3 ePos = end->get_global_position();
    Vector3 startOffset = Vector3(0,0,0);
    Vector3 endOffset = Vector3(0,0,0);
    if (sPos.y > ePos.y){
       startOffset = sPos - boxOffset;
    endOffset = ePos + boxOffset;
    }
    else{
        startOffset = sPos + boxOffset;
        endOffset = ePos -boxOffset;
    }

    Vector3 location = (sPos+ePos)/2;
    double lineLength = (startOffset-endOffset).length();

    workingEdge->set_scale(Vector3(0.3,0.3,lineLength));
    // Sets both global position and facing direction
    workingEdge->look_at_from_position(location, endOffset, Vector3(0,1,0), true);
}


void ProofGraph::addEdge(LogNode* start, LogNode* end){

    if (nodeMap[start->getID()]->logChildren.find(nodeMap[end->getID()]) != nodeMap[start->getID()]->logChildren.end() 
        || nodeMap[end->getID()]->logParents.find(nodeMap[start->getID()]) != nodeMap[end->getID()]->logParents.end()){
    }
    else {
    //Logic
    nodeMap[start->getID()]->logChildren.insert(nodeMap[end->getID()]);
    nodeMap[end->getID()]->logParents.insert(nodeMap[start->getID()]);

    //Meshes
    MeshInstance3D* lineMesh = memnew(MeshInstance3D);
    BoxMesh* shape = memnew(BoxMesh);
    lineMesh->set_mesh(shape);
    lineMesh->set_name(String::num_int64(start->getID())+ String::num_int64(end->getID()));

    start->add_child(lineMesh);

    edgeSetter(start, end, lineMesh);
    }
}

void ProofGraph::removeEdge(LogNode* start, LogNode* end){

    if (nodeMap[start->getID()]->logChildren.find(nodeMap[end->getID()]) != nodeMap[start->getID()]->logChildren.end() ){
        //Logic
        nodeMap[start->getID()]->logChildren.erase(nodeMap[end->getID()]);
        nodeMap[end->getID()]->logParents.erase(nodeMap[start->getID()]);

        //Meshes
        Node* badEdge = get_node_internal(String::num_int64(start->getID()) + "/" +String::num_int64(start->getID())+String::num_int64(end->getID()));
        start->remove_child(badEdge);
        badEdge->queue_free();
    }

}

// Needs checks for node validity
void ProofGraph::removeNode(LogNode* badNode){
    // Logic remove pointers of parents to badNode
    for(LogNode* i : badNode->logParents){
            i->logChildren.erase(badNode);
        // Meshes
        Node* badEdge = get_node_or_null(String::num_int64(i->getID()) + "/" + String::num_int64(i->getID()) + String::num_int64(badNode->getID()));
        Node* parentToBad =  get_node_or_null(String::num_int64(i->getID()));
        parentToBad->remove_child(badEdge);
        badEdge->queue_free();
    }

    // Logic remove pointers of children to badNode
    for (LogNode* i : badNode->logChildren){
        i->logParents.erase(badNode);
    }

    nodeMap.erase(badNode->getID());
    nodeCount--;

    // queue_free on the parent node was leaving the children nodes as orphans
    for(int i = 0; i < badNode->get_child_count(); i++){
        badNode->get_child(i)->queue_free();
    }
    remove_child(badNode);
    badNode->queue_free();
}

int ProofGraph::getNodeCount(){
    return nodeCount;
}

String ProofGraph::getNodeData(int targetNodeID){
    return nodeMap[targetNodeID]->data;
}

void ProofGraph::updateEdges(LogNode* updateNode){
    for(LogNode* i : updateNode->logParents){
        // Meshes
        Node* currentEdge = get_node_or_null(String::num_int64(i->getID()) + "/" + String::num_int64(i->getID()) + String::num_int64(updateNode->getID()));
        Node* parentToUpdate =  get_node_or_null(String::num_int64(i->getID()));
        MeshInstance3D* castedCurrentEdge = (MeshInstance3D*) currentEdge;
        LogNode* castedParentToUpdate = (LogNode*) parentToUpdate;

        edgeSetter(castedParentToUpdate, updateNode, castedCurrentEdge);
    }

    for (LogNode* i : updateNode->logChildren){
        Node* currentEdge = get_node_or_null(String::num_int64(updateNode->getID()) + "/" + String::num_int64(updateNode->getID()) + String::num_int64(i->getID()));
        Node* childToUpdate =  get_node_or_null(String::num_int64(i->getID()));
        MeshInstance3D* castedCurrentEdge = (MeshInstance3D*) currentEdge;
        LogNode* castedChildToUpdate = (LogNode*) childToUpdate;

        edgeSetter(updateNode, castedChildToUpdate, castedCurrentEdge);
    }
}

void ProofGraph::boxLookAtPlayer(){
    Node3D* playerNode = (Node3D*) get_parent()->get_node_or_null("PlayerCharacter/CharacterBody3D/Neck/Camera3D");
    for (KeyValue<int, LogNode*> i : nodeMap){
        i.value->look_at(playerNode->get_global_position(), Vector3(0,-1,0));
    }
}

void ProofGraph::_bind_methods(){
    ClassDB::bind_method(D_METHOD("addNode", "newNode"), &ProofGraph::addNode);
    ClassDB::bind_method(D_METHOD("addEdge", "start", "end"), &ProofGraph::addEdge);
    ClassDB::bind_method(D_METHOD("removeEdge", "start", "end"), &ProofGraph::removeEdge);
    ClassDB::bind_method(D_METHOD("removeNode", "node_pointer"), &ProofGraph::removeNode);
    ClassDB::bind_method(D_METHOD("getNodeCount"), &ProofGraph::getNodeCount);
    ClassDB::bind_method(D_METHOD("getData", "nodeID"), &ProofGraph::getNodeData);
    ClassDB::bind_method(D_METHOD("updateEdges"), &ProofGraph::updateEdges);
    ClassDB::bind_method(D_METHOD("boxLookAtPlayer"), &ProofGraph::boxLookAtPlayer);
}
