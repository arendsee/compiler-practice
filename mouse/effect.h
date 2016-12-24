#ifndef __EFFECT_H__
#define __EFFECT_H__

#include <stdlib.h>

#include "path.h"

typedef struct Effect{
    Path* path;
    char* function; 
} Effect;

Effect* effect_new(Path* path, char* function);

#endif
