#ifndef __TABLE_H__
#define __TABLE_H__

#include <stdbool.h>

typedef enum { T_VARIABLE, T_SCOPE } Type;

typedef struct Scope{
    struct Scope* parent;
    struct Table* table;
} Scope;

typedef struct Table{
    struct Table* next;
    char* name;
    Type type;
    union {
        char* variable;
        int integer;
        Scope* scope;
    } value;
} Table;

typedef struct Path{
    char* scope;
    Path* next;
} Path;

Path* new_Path(char*);
Scope* new_Scope(Scope* parent);
void add_item(Scope* scope, void* value, Type type);

Scope* lookup_scope(Scope*, Path*);

Table* lookup(Scope*);

#endif
