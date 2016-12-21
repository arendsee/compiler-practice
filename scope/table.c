#include "table.h"

Path* new_Path(char* scope){
    Path* p = (Path*)calloc(1, sizeof(Path));
    p->scope = scope;
    return(p);
}

Scope* new_Scope(){
    Scope* s = (Scope*)malloc(sizeof(Scope));
    s->parent = NULL;
    s->table = NULL;
    return s;
}

Table* new_Table(char* name, Type type){
    Table* t = (Table*)malloc(sizeof(Table));
    t->name = name;
    switch(type){
        case T_INT:
            t->type = T_INT;
            break;
        case T_SCOPE:
            t->type = T_SCOPE;
            break;
        default:
            fprintf(stderr, "Invalid type!\n");
            exit(EXIT_FAILURE);
    }
    return t;
}

void add_table(Scope* scope, Table* table){
    if(table){
        if(scope->table){
            table->next = scope->table;
        }
        scope->table = table;
    }
}

Scope* lookup_scope(Path* p, Scope* s){
    if(!s){
        fprintf(stderr, "WARNING: scope in table.c::lookup_scope is not defined\n");
        exit(EXIT_FAILURE);
    }
    if(!p){
        fprintf(stderr, "WARNING: path in table.c::lookup_scope is not defined\n");
        exit(EXIT_FAILURE);
    }
    if(!p || !s) return NULL;
    Scope* result = NULL;
    for(Table* t = s->table; t; t = t->next){
        if(strcmp(t->name, p->scope) == 0 && t->type == T_SCOPE){
            s = t->value.scope;
            p = p->next;
            if(p == NULL){
                result = s;
                break;
            } else {
                result = lookup_scope(p, s); 
            }
        }
    }
    return result;
}

Table* lookup(char* name, Scope* s){
    if(!s){
        fprintf(stderr, "WARNING: scope in table.c::lookup is not defined\n");
        exit(EXIT_FAILURE);
    }
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
