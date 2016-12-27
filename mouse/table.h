#ifndef __TABLE_H__
#define __TABLE_H__

#include <stdlib.h>
#include <string.h>

#include "entry.h"

typedef struct Table{
    Entry* head;
    Entry* tail;
} Table;

/* Copies entry and removes its link */
Table* table_new(const Entry* entry);

/* Copies entry and removes its link */
Table* table_add(Table* table, const Entry* entry);

/* b is destroyed upon join */
Table* table_join(Table* a, Table* b);

Table* table_selection_get(const Table* table, Selection* name, TType type); 

Table* table_recursive_get(const Table* table, Id* id, TType type); 

Table* table_recursive_get_type(const Table* table, TType type);

#endif
