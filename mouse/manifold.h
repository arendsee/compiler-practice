#ifndef __MANIFOLD_H__
#define __MANIFOLD_H__

typedef struct Manifold{
    char* function;
    char* effect;
    int uid;
} Manifold;

Manifold* manifold_new(char* function);

#endif
