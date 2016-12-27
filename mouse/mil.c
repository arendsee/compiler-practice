#include "mil.h"

/* Mouse has only one couplet type: EFFECT. Rat has a bunch. So the switch
 * statements will be more populous. This function does the following: 
 *  1. Find all couplets of the given type
 *  2. For each couplet:
 *  3.   Find all manifolds in its path
 *  4.   For each manifold couple the given element
 */
void mil_couplet(Table* t_top, TType type){
    Table* t_couplet = table_recursive_get_type(t_top, type);
    if(t_couplet && t_couplet->head){
        for(Entry* e = t_couplet->head; e; e = e->next){
            Table* t_man = NULL;
            switch(type){
                case T_EFFECT:
                    t_man = table_selection_get(t_top, e->value.effect->selection, T_MANIFOLD);
                    break;
                default:
                    fprintf(stderr, "ILLEGAL TYPE\n");
                    exit(EXIT_FAILURE);
            }
            if(!t_man){
                continue;
            }
            for(Entry* ee = t_man->head; ee; ee = ee->next){
                Manifold* m = ee->value.manifold;
                switch(type){
                    case T_EFFECT:
                        m->effect = e->value.effect->function;
                        break;
                    default:
                        fprintf(stderr, "ILLEGAL TYPE\n");
                        exit(EXIT_FAILURE);
                }
            }
        }
    }
}

void print_manifold_mil(Manifold* m){
    printf("EMIT m%d\n", m->uid);
    printf("FUNC m%d %s\n", m->uid, m->function);
    printf("EFCT m%d %s\n", m->uid, m->effect);
}

void build_manifolds(Table* t_top){
    /* add other couplets, e.g. cache */
    mil_couplet(t_top, T_EFFECT);
}

void print_prolog(Table* t_top){ }

void print_manifolds(Table* t_top){
    Table* t_man = table_recursive_get_type(t_top, T_MANIFOLD);
    for(Entry* e = t_man->head; e; e = e->next){
        print_manifold_mil(e->value.manifold);
    }
}

void print_epilog(Table* t_top){ }

void print_mil(Table* t_top){
    if(t_top && t_top->head){
        print_prolog(t_top);
        build_manifolds(t_top);
        print_manifolds(t_top);
        print_epilog(t_top);
    } else {
        fprintf(stderr, "The symbol table is empty - nothing to do\n");
    }
}
