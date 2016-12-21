#ifndef __TABLE_H__
#define __TABLE_H__

#include <stdbool.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

typedef enum { T_INT, T_SCOPE } Type;

typedef struct Scope{
    struct Scope* parent;
    struct Table* table;
} Scope;

typedef struct Table{
    struct Table* next;
    char* name;
    Type type;
    union {
        int integer;
        Scope* scope;
    } value;
} Table;

typedef struct Path{
    char* scope;
    struct Path* next;
} Path;

Path* new_Path(char*);
Table* new_Table(char* name, Type type);
Scope* new_Scope();

void add_table(Scope* scope, Table* table);

Scope* lookup_scope(Path*, Scope*);

Table* lookup(char*, Scope*);

#endif
