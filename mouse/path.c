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

char* path_str(Path* path){
    if(!path || !path->name){
        return NULL;
    }
    int n = 0;
    int length = 0;
    for(Path* p = path; p; p = p->next){
        n++;
        length += strlen(p->name);
    }
    length += n - 1;
    char* s = (char*)calloc(length + 1, sizeof(char));
    int pos = 0;
    for(Path* p = path; p; p = p->next){
        strcpy(s+pos, p->name);
        pos += strlen(p->name);
        if(p->next){
            s[pos] = '/';
            pos++;
        }
    }
    return s;
}

Path* path_from_str(char* path_str){
    char* s = path_str;
    Path* p = path_new();
    for(int i = 0; ; i++){
        if(s[i] == '\0'){
            p = path_put(p, strdup(s));
            break;
        }
        else if(s[i] == '/'){
            s[i] = '\0';
            p = path_put(p, strdup(s));
            s = s + i + 1;
            i = 0;
        }
    }
    return p;
}
