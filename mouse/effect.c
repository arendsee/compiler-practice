#include "effect.h"

Effect* effect_new(Path* path, char* function){
    Effect* e = (Effect*)malloc(sizeof(Effect));
    e->path = path;
    e->function = function;
    return e;
}
