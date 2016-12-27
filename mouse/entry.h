#ifndef __ENTRY_H__
#define __ENTRY_H__

#include <stdio.h>

#include "effect.h"
#include "manifold.h"
#include "id.h"


typedef enum { T_UNDEFINED=0, T_COMPOSITION, T_MANIFOLD, T_EFFECT } TType;

typedef struct Entry{
    Id* id;
    TType type;
    struct Entry* next;
    union {
        struct Table* composition;
        Manifold* manifold;
        Effect* effect;
    } value;
} Entry;

Entry* entry_new(Id* id, TType type, void* value);

/* get an exact copy of an entry */
Entry* entry_copy(const Entry* e);

/* copy an entry and unlink it */
Entry* entry_isolate(const Entry* e);

#endif
