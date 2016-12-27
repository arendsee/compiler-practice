#include "table.h"

#define STCMP(e, i, t)           \
    (                            \
        (e)->id && (i) && (t) && \
        id_cmp((e)->id, (i)) &&  \
        (e)->type == (t)         \
    )

#define TCMP(e, t) ((e) && (e)->type == (t))

#define SCMP(e, i) ((e)->id && (i) && id_cmp((e)->id, (i)))

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

Table* table_get(Table* table, Id* id, TType type){
    Table* out = NULL;
    for(Table* t = table; t; t = t->next){
        if(STCMP(t->entry, id, type)){
            out = table_add(out, t->entry);
        }
    }
    return out;
} 

Table* table_recursive_get(Table* table, Id* id, TType type){
    Table* out = NULL;
    for(Table* t = table; t; t = t->next){
        if(STCMP(t->entry, id, type)){
            out = table_add(out, t->entry);
        }
        if(TCMP(t->entry, T_COMPOSITION)){
            out = table_join(out, table_recursive_get(t->entry->value.composition, id, type)); 
        }
    }
    return out;
}

Table* table_path_get(Table* table, Path* path, TType type){
    Table* out = NULL;
    for(Table* t = table; t; t = t->next){
        if(path_is_base(path)){
            if(STCMP(t->entry, path->id, type)){
                out = table_add(out, t->entry);
            }
            if(TCMP(t->entry, T_COMPOSITION)){
                out = table_join(out, table_recursive_get(t->entry->value.composition, path->id, type));
            }
        } else {
            if(STCMP(t->entry, path->id, T_COMPOSITION)){
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
        if(TCMP(t->entry, type))
            out = table_add(out, t->entry);
    }
    return out;
}

Table* table_recursive_get_type(Table* table, TType type){
    Table* out = NULL;
    for(Table* t = table; t; t = t->next){
        if(TCMP(t->entry, type)){
            out = table_add(out, t->entry);
        }
        if(TCMP(t->entry, T_COMPOSITION)){
            Table* down = table_recursive_get_type(t->entry->value.composition, type);
            out = table_join(out, down);
        }
    }
    return out;
}

Table* table_reverse(Table* table){
    Table* prev = NULL;
    Table* next = NULL;
    while(table){
        next = table->next;
        table->next = prev;
        prev = table;
        if(next){
            table = next;
            if(TCMP(table->entry, T_COMPOSITION)){
                table->entry->value.composition = table_reverse(table->entry->value.composition);
            }
        } else {
            break;
        }
    }
    return table;
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
