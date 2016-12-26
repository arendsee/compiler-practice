#include "table.h"

#define STCMP(s1, s2, t1, t2)      \
    (                              \
        (s1) && (s2) && (t1) &&    \
        strcmp((s1), (s2)) == 0 && \
        (t1) == (t2)               \
    )

#define TCMP(t1, t2) ((t1) && (t1) == (t2))

#define SCMP(s1, s2) ((s1) && (s2) && strcmp((s1), (s2)) == 0)

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
            // give new node the current value
            Table* newtab = table_new(table->entry);
            // give current node the new value
            table->entry = entry;
            // link new node as second (FIFO)
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
        if(a && a->entry){
            Table* c = a;
            for(; c->next; c = c->next){ }
            c->next = b;
        } else {
            a = b;
        }
    }
    return a;
}

Table* table_get(Table* table, char* name, TType type){
    Table* out = NULL;
    for(Table* t = table; t; t = t->next){
        if(STCMP(t->entry->name, name, t->entry->type, type)){
            out = table_add(out, t->entry);
        }
    }
    return out;
} 

Table* table_recursive_get(Table* table, char* name, TType type){
    Table* out = NULL;
    for(Table* t = table; t; t = t->next){
        if(STCMP(t->entry->name, name, t->entry->type, type)){
            out = table_add(out, t->entry);
        }
        if(TCMP(t->entry->type, T_COMPOSITION)){
            out = table_join(out, table_recursive_get(t->entry->value.composition, name, type)); 
        }
    }
    return out;
}

Table* table_path_get(Table* table, Path* path, TType type){
    Table* out = NULL;
    for(Table* t = table; t; t = t->next){
        if(path_is_base(path)){
            if(STCMP(t->entry->name, path->name, t->entry->type, type)){
                out = table_add(out, t->entry);
            }
            if(TCMP(t->entry->type, T_COMPOSITION)){
                out = table_join(out, table_recursive_get(t->entry->value.composition, path->name, type));
            }
        } else {
            if(STCMP(t->entry->name, path->name, t->entry->type, T_COMPOSITION)){
                out = table_join(out, table_path_get(t->entry->value.composition, path->next, type));
            }
        }
    }
    return out;
}

Table* table_selection_get(Table* table, Selection* selection, TType type){
    Table* out = NULL;
    for(Selection* s = selection; s; s = s->next){
        out = table_join(out, table_path_get(table, s->path, type));
    }
    return out;
}

Table* table_get_type(Table* table, TType type){
    Table* out = table_new(NULL);
    for(Table* t = table; t; t = t->next){
        Entry* e = t->entry;
        if(TCMP(e->type, type))
            out = table_add(out, e);
    }
    return out;
}

Table* table_recursive_get_type(Table* table, TType type){
    Table* out = NULL;
    for(Table* t = table; t; t = t->next){
        if(TCMP(t->entry->type, type)){
            out = table_add(out, t->entry);
        }
        if(TCMP(t->entry->type, T_COMPOSITION)){
            Table* down = table_recursive_get_type(t->entry->value.composition, type);
            out = table_join(out, down);
        }
    }
    return out;
}

Table* table_first(Table* table){
    return table;
}

Table* table_next(Table* table){
    return table->next;
}

#undef STCMP
#undef TCMP
#undef SCMP
