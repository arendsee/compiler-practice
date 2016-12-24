#include "manifold.h"

Manifold* manifold_new(char* function){
    static int uid = -1;
    Manifold* m = (Manifold*)calloc(1, sizeof(Manifold));
    m->uid = ++uid;
    m->function = function;
    return m;
}
