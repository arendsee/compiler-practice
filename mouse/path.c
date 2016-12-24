#include "path.h"

Path* path_new(){
    Path* p = (Path*)calloc(1, sizeof(Path));
    return p;
}

/* Each new element is appended to the end. Since I don't store the last
 * element, I have to look it up in linear time. However, there will usually be
 * few elements in the path, so the simplicity of this approach wins. */
Path* path_put(Path* path, char* name){
    if(path->name){
        Path* new = path_new();    
        new->name = name;
        Path* c = path;
        for( ; c->next; c = c->next) {}
        c->next = new;
    } else {
        path->name = name;
    }
    return path;
}

char* path_pop(Path* path){
    char* name = NULL;
    if(path && path->name){
        name = path->name;
        path = path->next;
    }
    return name;
}

bool path_is_base(Path* path){
    return path->next == NULL;
}
