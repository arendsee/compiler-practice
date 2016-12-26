#include "table.h"

Table* table_new(Entry* entry){
    Table* t = (Table*)malloc(sizeof(Table));
    t->entry = entry;
    t->next = NULL;
    return t;
}

Table* table_add(Table* table, Entry* entry){
    if(!table){
        table = table_new(entry);
    } else {
        if(table->entry){
            Table* newtab = table_new(table->entry);
            table->entry = entry;
            newtab->next = table->next;
            table->next = newtab;
        } else {
            table->entry = entry;
        }
    }
    return table;
}

Table* table_join(Table* a, Table* b){
    if(b && b->entry){
        Table* c = a;
        for(; c->next; c = c->next){ }
        c->next = b;
    }
    return a;
}

Table* table_get(Table* table, char* name, TType type){
    Table* out = table_new(NULL);
    for(Table* t = table; t; t = t->next){
        Entry* e = t->entry;
        if(strcmp(e->name, name) == 0 && e->type == type){
            out = table_add(out, e);
        }
    }
    return out;
} 

Table* table_recursive_get(Table* table, char* name, TType type){
    Table* out = table_new(NULL);
    for(Table* t = table; t->entry; t = t->next){
        if(strcmp(t->entry->name, name) == 0 && t->entry->type == type){
            out = table_add(out, t->entry);
        }
        if(t->entry->type == T_COMPOSITION){
            out = table_join(out, table_recursive_get(table, name, type)); 
        }
    }
    return out;
}

Table* table_path_get(Table* table, Path* path, TType type){
    Table* out = table_new(NULL);
    for(Table* t = table; t->entry; t = t->next){
        if(path_is_base(path)){
            if(strcmp(t->entry->name, path->name) == 0 && t->entry->type == type){
                out = table_add(out, t->entry);
            }
            if(t->entry->type == T_COMPOSITION){
                out = table_join(out, table_recursive_get(t->entry->value.composition, path->name, type)); 
            }
        } else {
            if(t->entry->name == path->name && t->entry->type == T_COMPOSITION){
                out = table_join(out, table_path_get(t->entry->value.composition, path->next, type));
            }
        }
    }
    return out;
}

Table* table_get_type(Table* table, TType type){
    Table* out = table_new(NULL);
    for(Table* t = table; t; t = t->next){
        Entry* e = t->entry;
        if(e->type == type)
            out = table_add(out, e);
    }
    return out;
}

Table* table_recursive_get_type(Table* table, TType type){
    Table* out = table_new(NULL);
    for(Table* t = table; t; t = t->next){
        fprintf(stderr, " - %s:%d - ", t->entry->name, t->entry->type); fflush(stderr);
        if(t->entry->type == type){
            out = table_add(out, t->entry);
        }
        if(t->entry->type == T_COMPOSITION){
            Table* down = table_recursive_get_type(table->entry->value.composition, type);
            out = table_join(out, down);
        }
    }
    if(!out->entry) out = NULL;

    return out;
}


Table* table_first(Table* table){
    return table;
}

Table* table_next(Table* table){
    return table->next;
}
