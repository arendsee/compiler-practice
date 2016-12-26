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

Path* path_from_str(char*);

bool path_is_base(Path* path);

#endif
