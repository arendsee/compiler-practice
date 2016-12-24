#ifndef __TABLE_H__
#define __TABLE_H__

#include <stdbool.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

typedef enum { T_INT, T_SCOPE } Type;

typedef struct Table{
    struct Table* next;
    char* name;
    Type type;
    union {
        int integer;
        Scope* scope;
    } value;
} Table;

Table* new_Table(char* name, Type type);

void add_table(Scope* scope, Table* table);

#endif
