#include "entry.h"

Entry* entry_new(Id* id, TType type, void* value){
    Entry* e = (Entry*)malloc(sizeof(Entry));
    e->type = type;
    e->id = id;
    e->next = NULL;

    switch(type){
        case T_PATH:
            e->value.table = value;
            break;
        case C_COMPOSON:
            e->value.table = value;
            break;
        case C_NEST:
            e->value.table = value;
            break;
        case C_MANIFOLD:
            e->value.manifold = value;
            break;
        case T_EFFECT:
            e->value.effect = value;
            break;
        case T_UNDEFINED:
            fprintf(stderr, "UNDEFINED TYPE\n");
            exit(EXIT_FAILURE);
            break;
        default:
            fprintf(stderr, "ILLEGAL TYPE\n");
            exit(EXIT_FAILURE);
            break;
    }
    return e;
}

Entry* entry_copy(const Entry* e){
   Entry* new_entry = (Entry*)malloc(sizeof(Entry));
   memcpy(new_entry, e, sizeof(Entry)); 
   return new_entry;
}

Entry* entry_isolate(const Entry* e){
    Entry* new_entry = entry_copy(e);
    new_entry->next = NULL;
    return new_entry;
}
