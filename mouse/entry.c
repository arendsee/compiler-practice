#include "entry.h"

Entry* entry_new(char* name, TType type, void* value){
    Entry* e = (Entry*)malloc(sizeof(Entry));
    e->type = type;
    e->name = name;
    switch(type){
        case T_COMPOSITION:
            e->value.composition = value;
            break;
        case T_MANIFOLD:
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
