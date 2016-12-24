#ifndef __PATH_H__
#define __PATH_H__

typedef struct Path{
    char* scope;
    struct Path* next;
} Path;

Path* new_Path(char*);

#endif
