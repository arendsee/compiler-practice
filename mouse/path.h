#ifndef __PATH_H__
#define __PATH_H__

#include <stdbool.h>
#include <stdlib.h>
#include <string.h>

/* FIFO linked list */
typedef struct Path{
    struct Path* next;
    char* name; 
} Path;

Path* path_new();

Path* path_from_str(char*);

Path* path_put(Path* path, char* name);

char* path_pop(Path* path);

char* path_str(Path* path);

bool path_is_base(Path* path);

#endif
