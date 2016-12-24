#include "table.h"

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
