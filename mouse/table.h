#ifndef __TABLE_H__
#define __TABLE_H__

#include <stdlib.h>
#include <string.h>

#include "entry.h"

typedef struct Table{
    Entry* entry;
    struct Table* next;
} Table;

Table* table_new(Entry* entry);

Table* table_add(Table* table, Entry* entry);

Table* table_join(Table* a, Table* b);

Table* table_get(Table* table, char* name, TType type); 

Table* table_path_get(Table* table, Path* name, TType type); 

Table* table_recursive_get(Table* table, char* name, TType type); 

Table* table_get_type(Table* table, TType type);

Table* table_recursive_get_type(Table* table, TType type);

Table* table_first(Table* table);

Table* table_next(Table* table);

#endif
