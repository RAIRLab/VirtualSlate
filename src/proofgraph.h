#ifndef PROOFGRAPH_H
#define PROOFGRPAH_H


#include <iostream>
#include <set>

#include "godot_cpp/classes/ref_counted.hpp"
#include "godot_cpp/variant/vector3.hpp"
#include "godot_cpp/classes/object.hpp"
#include "godot_cpp/templates/hash_map.hpp"
#include "godot_cpp/templates/hash_set.hpp"


namespace godot{

class LogNode : public Object{
    GDCLASS(LogNode, Object)
    public:

        int nodeID;
        // Placeholder for 3D location info as I'm not sure how Godot handles it
        Vector3 location;
        // Placeholder for formula data
        int data;
        // Potentially split into seperate parent/child sets?
        HashSet<LogNode*> neighbors;

        LogNode();

        LogNode(int nodeID, Vector3 location, int data);
    
    protected:
        static void _bind_methods();
};

class ProofGraph : public Object{
    GDCLASS(ProofGraph, Object)

    private:
        int nodeCount;
        HashMap<int, LogNode*> nodeMap;
    public:
        
        // Constructor, creates empty proof graph
        ProofGraph(); 

        void addNode(Vector3 location, int data);

        void addEdge(int start, int end);

        void removeNode(int deleteID);

        int getNodeCount();

        int getNodeData(int targetNodeID);

    protected:
        static void _bind_methods();

};

}

#endif