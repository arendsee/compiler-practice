#include "path.h"

Path* new_Path(char* scope){
    Path* p = (Path*)calloc(1, sizeof(Path));
    p->scope = scope;
    return(p);
}
