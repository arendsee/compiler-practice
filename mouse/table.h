#ifndef __TABLE_H__
#define __TABLE_H__

#include <stdlib.h>
#include <string.h>

#include "path.h"
#include "effect.h"
#include "manifold.h"

typedef enum { T_UNDEFINED=0, T_COMPOSITION, T_MANIFOLD, T_EFFECT } TType;

typedef struct Table{
    struct Entry* entry;
    struct Table* next;
} Table;

typedef struct Entry{
    char* name;
    TType type;
    union {
        Table* composition;
        Manifold* manifold;
        Effect* effect;
    } value;
} Entry;

Table* result_new(Entry* entry);

Entry* entry_new(char* name, TType type, void* value);

Table* table_new();

void table_add(Table* table, Entry* entry);

Table* table_join(Table* a, Table* b);

Table* table_get(Table* table, char* name, TType type); 

Table* table_recursive_get(Table* table, char* name, TType type); 

Table* table_path_get(Table* table, Path* name, TType type); 

Table* table_get_type(Table* table, TType type);

Table* table_first(Table* table);

Table* table_next(Table* table);

#endif
