#ifndef __PATH_H__
#define __PATH_H__

#include <stdbool.h>
#include <stdlib.h>

/* FIFO linked list */
typedef struct Path{
    struct Path* next;
    char* name; 
} Path;

Path* path_new();

void path_put(Path* path, char* name);

char* path_pop(Path* path);

bool path_is_base(Path* path);

#endif
