#include "table.h"

Path* new_Path(char* scope){
    Path* p = (Path*)calloc(1, sizeof(Path));
    p->scope = scope;
    return(p);
}

Scope* new_Scope(Scope* parent){
    Scope* s = (Scope*)malloc(sizeof(Scope));
    s->parent = parent;
    s->table = NULL;
    return s;
}

void add_item(Scope* scope, char* name, void* value, Type type){
    Table* t = (Table*)malloc(sizeof(Table));
    t->name = name;
    switch(type){
        case T_VARIABLE:
            t->value.variable = value;
            break;
        case T_SCOPE:
            t->value.scope = value;
            break;
        default:
            fprintf(stderr, "Invalid type!\n");
    }
    if(scope->table){
        t->next = scope->table;
    }
    scope->table = t;
}

Scope* lookup_scope(Path* p, Scope* s){
    Scope* result = NULL;
    for(Table* t = s->table; t; t = t->next){
        if(strcmp(t->name, p->scope) == 0 && t->type == T_SCOPE){
            s = t->value.scope;
            p = p->next;
            if(p == NULL){
                result = s;
                break;
            } else {
                t = s->table;
            }
        }
    }
    return result;
}

Table* lookup(char* name, Scope* s){
    Table* result = NULL;
    for(Table* t = s->table; t; t = t->next){
        if(strcmp(t->name, name) == 0){
            result = t;
            break;
        }
        if(t->next == NULL && s->parent != NULL){
            s = s->parent; 
            t = s->table;
        }
    }
    return result;
}
