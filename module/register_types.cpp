
#include "register_types.h"
#include "core/object/class_db.h"

#include "Proofgraph.hpp"

void initialize_proofgraph_module(ModuleInitializationLevel p_level) {
    if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE) {
            return;
    }
    ClassDB::register_class<ProofGraph>();
}

void uninitialize_proofgraph_module(ModuleInitializationLevel p_level) {
    if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE) {
            return;
    }
}