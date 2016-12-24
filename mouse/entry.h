#ifndef __ENTRY_H__
#define __ENTRY_H__

#include <stdio.h>

#include "effect.h"
#include "manifold.h"

typedef enum { T_UNDEFINED=0, T_COMPOSITION, T_MANIFOLD, T_EFFECT } TType;

typedef struct Entry{
    char* name;
    TType type;
    union {
        struct Table* composition;
        Manifold* manifold;
        Effect* effect;
    } value;
} Entry;

Entry* entry_new(char* name, TType type, void* value);

#endif
