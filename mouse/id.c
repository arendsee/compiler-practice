#include "id.h"

Id* id_new(){
    static int uid = 0;
    Id* i = (Id*)calloc(1, sizeof(Id));
    i->uid = uid++;
    return i;
}

Id* id_from_str(char* s){
    Id* ident = id_new();
    ident->name = s;
    s = strdup(s);
    for(int i = 0; ; i++){
        if(s[i] == '\0'){
            break;
        }
        else if(s[i] == ':'){
            s[i] = '\0';
            ident->label = s + i + 1;
            break;
        }
    }
    return ident;
}

bool id_cmp(Id* a, Id* b){
    return
        strcmp(a->name, b->name) == 0 &&
        (
            (a == NULL && b == NULL) ||
            strcmp(a->label, b->label) == 0
        );
}
