#include "mil.h"

/* Mouse has only one couplet type: EFFECT. Rat has a bunch. So the switch
 * statements will be more populous. This function does the following: 
 *  1. Find all couplets of the given type
 *  2. For each couplet:
 *  3.   Find all manifolds in its path
 *  4.   For each manifold print the approrpiate MIL instruction(s)
 */
void mil_couplet(Table* t_top, TType type){
    Table* t_couplet = table_recursive_get_type(t_top, type);
    if(t_couplet){
        for(Table* t = t_couplet; t; t = t->next){
            Table* t_man;
            switch(type){
                case T_EFFECT:
                    t_man = table_selection_get(t_top, t->entry->value.effect->selection, T_MANIFOLD);
                    break;
                default:
                    fprintf(stderr, "ILLEGAL TYPE\n");
                    exit(EXIT_FAILURE);
            }
            for(Table* tt = t_man; tt; tt = tt->next){
                Manifold* m = tt->entry->value.manifold;
                switch(type){
                    case T_EFFECT:
                        printf("EFCT m%d %s\n", m->uid, t->entry->value.effect->function);
                        break;
                    default:
                        fprintf(stderr, "ILLEGAL TYPE\n");
                        exit(EXIT_FAILURE);
                }
            }
        }
    }
}

/* Some sections of Rat and Mouse have atomic left hand sides, rather than
 * paths. In Mouse, only MANIFOLD is in this group. */
void mil_pathless(Table* t_top, TType type){
    Table* t_sec = table_recursive_get_type(t_top, type);
    if(t_sec){
        for(Table* t = t_sec; t; t = t->next){
            switch(type){
                case T_MANIFOLD:
                    {
                    Manifold* m = t->entry->value.manifold;
                    printf("EMIT m%d\n", m->uid);
                    printf("FUNC m%d %s\n", m->uid, m->function);
                    }
                    break;
                default:
                    fprintf(stderr, "ILLEGAL TYPE in mil_pathless\n");
                    exit(EXIT_FAILURE);
            }
        }
    }
}

void mil_effect(Table* t_top){
    mil_couplet(t_top, T_EFFECT);
}

void mil_emit(Table* t_top){
    mil_pathless(t_top, T_MANIFOLD);
}

void print_mil(Table* t_top){
    if(t_top && t_top->entry){
        mil_emit(t_top);
        mil_effect(t_top);
    } else {
        fprintf(stderr, "The symbol table is empty - nothing to do\n");
    }
}
