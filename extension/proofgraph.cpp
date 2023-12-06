#include <iostream>
#include <stack>
#include <string>
#include <list>

#include "proofgraph.h"

#include "godot_cpp/classes/mesh.hpp"
#include "godot_cpp/classes/box_mesh.hpp"
#include "godot_cpp/classes/text_mesh.hpp"
#include "godot_cpp/classes/standard_material3d.hpp"
#include "godot_cpp/variant/color.hpp"
#include "godot_cpp/classes/cylinder_mesh.hpp"
#include "godot_cpp/classes/box_shape3d.hpp"
#include "godot_cpp/classes/collision_shape3d.hpp"
#include "godot_cpp/classes/static_body3d.hpp"

using namespace godot;

LogNode::LogNode(){
    nodeID = 0;
    data = "";
    justification = "";
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
    StandardMaterial3D* skin = memnew(StandardMaterial3D);
    newText->set_material_overlay(skin);

    newText->global_scale(Vector3(1.2,1.2,.5));
    newText->set_position(Vector3(0,.04,0));

    MeshInstance3D* oldBox = (MeshInstance3D*) get_node_or_null("box");
    if (newData.length() > 9){
        oldBox->set_scale(Vector3(1+(newData.length()-10)*.135,.5,.2));
    }
    else {
        oldBox->set_scale(Vector3(1.0,.5,.2));
    }
}

bool LogNode::isChild(LogNode* potentialChild){
    if (logChildren.find(potentialChild) != logChildren.end()) {
        return true;
    }
    else {
        return false;
    }
}

// Old version, not used
String LogNode::getParentRep(){
    String value = "(";
    for(LogNode* i : logParents){
        value = value + String::num_uint64(i->getID());
        value = value + ",";
    }
    if (value.length() > 1){
        value = value.left(value.length() - 1);
        value = value + ")";
    }
    else {
        value = "";
    }
    return value;
}

//Old version, not used
void LogNode::setParentRep(){
    Node* oldText = get_node_or_null("Parents");
    if(oldText != NULL){
        remove_child(oldText);
        oldText->queue_free();
    }
    MeshInstance3D* newText = memnew(MeshInstance3D);
    newText->set_name("Parents");
    add_child(newText);
    TextMesh* letters = memnew(TextMesh);
    newText->set_mesh(letters);
    letters->TextMesh::set_text(this->getParentRep());
    newText->global_scale(Vector3(.8,.8,.5));
    newText->set_position(Vector3(0,-.15,0));
}

// Set used to avoid duplicates
// Finds all ancestor node IDs
// Cycle check should keep it from running infinitely
void LogNode::assumeFind(LogNode* currentNode, HashSet<int>* tempAssume){
    for (LogNode* parent : currentNode->logParents){
        if (parent->justification == "assume"){
            tempAssume->insert(parent->getID());
        }
        assumeFind(parent, tempAssume);
    }
}

// Converts the set to a string for mesh representation
String LogNode::assumeString(HashSet<int>* assume){
    String value = "(";
    for(int i : *(assume)){
        value = value + String::num_uint64(i);
        value = value + ",";
    }
    if (value.length() > 1){
        value = value.left(value.length() - 1);
        value = value + ")";
    }
    else {
        value = "";
    }
    return value;
}

void LogNode::setAssumeRep(){
    HashSet<int> tempAssume; 

    assumeFind(this, &tempAssume);
    String words = assumeString(&tempAssume);
    
    Node* oldText = get_node_or_null("Parents");
    if(oldText != NULL){
        remove_child(oldText);
        oldText->queue_free();
    }
    MeshInstance3D* newText = memnew(MeshInstance3D);
    newText->set_name("Parents");
    add_child(newText);
    TextMesh* letters = memnew(TextMesh);
    newText->set_mesh(letters);
    letters->TextMesh::set_text(words);
    newText->global_scale(Vector3(.8,.8,.5));
    newText->set_position(Vector3(0,-.15,0));
}

void LogNode::assumeCascade(){
    for (LogNode* child : this->logChildren){
        child->setAssumeRep();
        child->assumeCascade();
    }
}

void LogNode::setJustification(String code, String symbol){
    this->justification = code;

    Node* oldText = get_node_or_null("Justification");
    if(oldText != NULL){
        remove_child(oldText);
        oldText->queue_free();
    }
    // Creation of a new text mesh
    MeshInstance3D* newText = memnew(MeshInstance3D);
    newText->set_name("Justification");
    add_child(newText);
    TextMesh* letters = memnew(TextMesh);
    newText->set_mesh(letters);
    letters->TextMesh::set_text(symbol);
    newText->global_scale(Vector3(1.2,1.2,.5));
    newText->set_position(Vector3(0,.385,0));

    MeshInstance3D* oldBox = (MeshInstance3D*) get_node_or_null("justBox");
    oldBox->set_scale(Vector3((symbol.length()*.115)+.1,.225,.2));

    this->assumeCascade();
}

bool LogNode::findParentless(LogNode* targetNode, HashSet<int> found){
    // If a node has no parents it is not part of a cycle
    if(targetNode->logParents.is_empty()){
        return 0;
    }
    // If the node is revisited, we are in a cycle
    if (found.find(targetNode->getID()) != found.end()){
        return 1;
    }
    found.insert(targetNode->getID());
    bool cycleFlag = 0;
    // Recursive DFS through parents to check for cycles
    for (LogNode* parent : targetNode->logParents){
        cycleFlag = findParentless(parent, found);
        if (cycleFlag == 1){
            return cycleFlag;
        }
    }
    return cycleFlag;
}

bool LogNode::dfsCheck(){
    bool cycleFlag = 0;
    HashSet<int> found;
    cycleFlag = findParentless(this, found);
    return cycleFlag;
}


void LogNode::_bind_methods(){
    ClassDB::bind_method(D_METHOD("setID", "ID"), &LogNode::setID);
    ClassDB::bind_method(D_METHOD("getID"), &LogNode::getID);
    ClassDB::bind_method(D_METHOD("getData"), &LogNode::getData);
    ClassDB::bind_method(D_METHOD("setData", "data"), &LogNode::setData);
    ClassDB::bind_method(D_METHOD("isChild", "potentialChild"), &LogNode::isChild);
    ClassDB::bind_method(D_METHOD("getParentRep"), &LogNode::getParentRep);
    ClassDB::bind_method(D_METHOD("setJustification", "consise", "verbose"), &LogNode::setJustification);
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

    //Creating the main box mesh
    MeshInstance3D* box = memnew(MeshInstance3D);
    box->set_name("box");
    BoxMesh* shape = memnew(BoxMesh);
    StandardMaterial3D* skin = memnew(StandardMaterial3D);
    newNode->add_child(box);
    box->set_mesh(shape);
    box->set_material_override(skin);
    box->set_scale(Vector3(1.0,.5,.2));
    skin->set_transparency(BaseMaterial3D::TRANSPARENCY_ALPHA);
    skin->set_albedo(Color(0.5, 0.75, 0.75, 0.25));

    //Text mesh for ID
    MeshInstance3D* idText = memnew(MeshInstance3D);
    idText->set_name("ID");
    newNode->add_child(idText);
    TextMesh* numbers = memnew(TextMesh);
    idText->set_mesh(numbers);
    numbers->TextMesh::set_text("ID: " + String::num_int64(newNode->getID()));
    idText->set_position(Vector3(-.325, .19, 0));
    idText->set_scale(Vector3(.8,.8,.5));

    //Physics collider for ray casts

    CollisionShape3D* physBody = memnew(CollisionShape3D);
    BoxShape3D* physBox = memnew(BoxShape3D);
    StaticBody3D* nodeCollider = memnew(StaticBody3D);
    nodeCollider->set_name("nodeCollider");
    newNode->add_child(nodeCollider);
    nodeCollider->add_child(physBody);
    physBody->set_shape(physBox);
    physBody->set_scale(Vector3(1.0,.5,.2));

    //Create box mesh for justification
    MeshInstance3D* justBox = memnew(MeshInstance3D);
    justBox->set_name("justBox");
    BoxMesh* justShape = memnew(BoxMesh);
    StandardMaterial3D* justSkin = memnew(StandardMaterial3D);
    newNode->add_child(justBox);
    justBox->set_mesh(justShape);
    justBox->set_material_override(justSkin);
    justBox->set_scale(Vector3(.3,.225,.2));
    justSkin->set_transparency(BaseMaterial3D::TRANSPARENCY_ALPHA);
    justSkin->set_albedo(Color(0.5, 0.75, 0.75, 0.25));
    justBox->set_position(Vector3(0,.375,.0));
}

void ProofGraph::edgeSetter(LogNode* start, LogNode* end, MeshInstance3D* workingEdge){
    Vector3 topBoxOffset = Vector3(0,.475,0);
    Vector3 bottomBoxOffset = Vector3(0,.25,0);
    Vector3 sPos = start->get_global_position();
    Vector3 ePos = end->get_global_position();
    Vector3 startOffset = Vector3(0,0,0);
    Vector3 endOffset = Vector3(0,0,0);
    if (sPos.y > ePos.y){
        startOffset = sPos - bottomBoxOffset;
        endOffset = ePos + topBoxOffset;
    }
    else{
        startOffset = sPos + topBoxOffset;
        endOffset = ePos - bottomBoxOffset;
    }

    Vector3 location = (startOffset+endOffset)/2;
    double lineLength = (startOffset-endOffset).length();

    workingEdge->set_scale(Vector3(0.03,0.03,lineLength));
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

        if (start->dfsCheck()){
            nodeMap[start->getID()]->logChildren.erase(nodeMap[end->getID()]);
            nodeMap[end->getID()]->logParents.erase(nodeMap[start->getID()]); 
        }

        else{
            //Meshes
            MeshInstance3D* lineMesh = memnew(MeshInstance3D);
            BoxMesh* shape = memnew(BoxMesh);
            lineMesh->set_mesh(shape);
            lineMesh->set_name(String::num_int64(start->getID())+ String::num_int64(end->getID()));

            start->add_child(lineMesh);

            edgeSetter(start, end, lineMesh);
            end->setAssumeRep();
            end->assumeCascade();
        }
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
        end->setAssumeRep();
        end->assumeCascade();
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

    badNode->assumeCascade();

    // Logic remove pointers of children to badNode, updates parent rep
    for (LogNode* i : badNode->logChildren){
        i->logParents.erase(badNode);
        i->setAssumeRep();
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

void ProofGraph::_bind_methods(){
    ClassDB::bind_method(D_METHOD("addNode", "newNode"), &ProofGraph::addNode);
    ClassDB::bind_method(D_METHOD("addEdge", "start", "end"), &ProofGraph::addEdge);
    ClassDB::bind_method(D_METHOD("removeEdge", "start", "end"), &ProofGraph::removeEdge);
    ClassDB::bind_method(D_METHOD("removeNode", "node_pointer"), &ProofGraph::removeNode);
    ClassDB::bind_method(D_METHOD("getNodeCount"), &ProofGraph::getNodeCount);
    ClassDB::bind_method(D_METHOD("getData", "nodeID"), &ProofGraph::getNodeData);
    ClassDB::bind_method(D_METHOD("updateEdges"), &ProofGraph::updateEdges);
}
