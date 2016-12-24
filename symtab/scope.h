#ifndef __SCOPE_H__
#define __SCOPE_H__

typedef struct Scope{
    struct Scope* parent;
    struct Table* table;
} Scope;

Scope* new_Scope();

Scope* lookup_scope(Path*, Scope*);

Table* lookup(char*, Scope*);

#endif
