#include "mil.h"

void print_table(Table* t){
    if(t && t->entry){
        for( ; t; t = t->next){
            switch(t->entry->type){
                case T_COMPOSITION:
                    printf("COMPOSITION\n");
                    print_table(t->entry->value.composition);
                    break;
                case T_EFFECT:
                    {
                    Effect* e = t->entry->value.effect;
                    printf("EFFECT %s %s\n", path_str(e->path), e->function);
                    }
                    break;
                case T_MANIFOLD:
                    printf("MANIFOLD %s %d\n", t->entry->name,  t->entry->value.manifold->uid);
                    break;
                case T_UNDEFINED:
                    fprintf(stderr, "UNDEFINED - this shouldn't happen\n");
                    break;
                default:
                    fprintf(stderr, "This really should not happen\n");
                    break;
            }
        }
    }
}

void print_mil(Table* t){
    if(t && t->entry){
        Table* manifolds = table_recursive_get_type(t, T_MANIFOLD);
        if(manifolds){
            for(Table* t = manifolds; t; t = t->next){
                printf("EMIT %s\n", t->entry->name);
            }
        } else {
            fprintf(stderr, "No manifolds found\n");
        }
    } else {
        fprintf(stderr, "The symbol table is empty - nothing to do\n");
    }
}
