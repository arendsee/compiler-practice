#ifndef __TABLE_H__
#define __TABLE_H__

typedef enum { T_COMPOSITION, T_MANIFOLD, T_EFFECT } TType;

typedef struct Entry{
    char* name;
    TType type;
    union {
        Table* composition;
        char* manifold;
        char* effect;
    } value;
} Entry;

typedef struct Result{
    Entry* entry;
    Result* next;
} Result;

Result* result_new(Entry* entry);

Entry* entry_new(char* name, TType type, void* value);

void table_add(Table* table, Entry* entry);

Entry* table_get(Table* table, char* name, TType type); 

#endif
