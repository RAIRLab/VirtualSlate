#ifndef PROOFGRAPH_H
#define PROOFGRPAH_H


#include <iostream>
#include <set>

//#include "godot_cpp/classes/ref_counted.hpp"
#include "godot_cpp/variant/vector3.hpp"
#include "godot_cpp/classes/object.hpp"
#include "godot_cpp/classes/node3d.hpp"
#include "godot_cpp/templates/hash_map.hpp"
#include "godot_cpp/templates/hash_set.hpp"
#include "godot_cpp/variant/string.hpp"
#include "godot_cpp/classes/mesh_instance3d.hpp"
#include "godot_cpp/classes/mesh.hpp"
#include "godot_cpp/classes/box_mesh.hpp"
#include "godot_cpp/classes/text_mesh.hpp"
#include "godot_cpp/classes/standard_material3d.hpp"
#include "godot_cpp/variant/color.hpp"
#include "godot_cpp/classes/cylinder_mesh.hpp"
#include "godot_cpp/classes/box_shape3d.hpp"
#include "godot_cpp/classes/collision_shape3d.hpp"
#include "godot_cpp/classes/static_body3d.hpp"

namespace godot{

class LogNode : public Node3D{
    GDCLASS(LogNode, Node3D)
    public:

        // Position field inherited from Node3D i.e. global_position
        int nodeID;
        String data;
        HashSet<LogNode*> logParents;
        HashSet<LogNode*> logChildren;

        // Godot does not play nicely with parameterized constructors
        // Constructor requires default constructor then setID method
        LogNode();

        void setID(int nodeID);
        int getID();
        String getData();
        void setData(String newData);
        bool isChild(LogNode* potentialChild);

    
    protected:
        static void _bind_methods();
};

class ProofGraph : public Node{
    GDCLASS(ProofGraph, Node)

    private:
        int nodeCount;
        int nodeIDCount;
        HashMap<int, LogNode*> nodeMap;
    public:
        
        // Constructor, creates empty proof graph
        ProofGraph(); 
        ~ProofGraph();

        //void addNode(Vector3 location, int data);
        void addNode(Vector3 position);
        void addEdge(LogNode* start, LogNode* end);
        void removeEdge(LogNode* start, LogNode* end);
        void removeNode(LogNode* badNode);
        int getNodeCount();
        String getNodeData(int targetNodeID);
        void updateEdges(LogNode* updateNode);

    protected:
        static void _bind_methods();
};

}

#endif