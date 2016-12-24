#include "entry.h"

Entry* entry_new(char* name, TType type, void* value){
    Entry* e = (Entry*)calloc(1, sizeof(Entry));
    return e;
}
