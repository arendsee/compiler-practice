#ifndef __EFFECT_H__
#define __EFFECT_H__

typedef struct Effect{
    Path* path;
    char* function; 
} Effect;

Effect* effect_new(Path* path, char* function);

#endif
