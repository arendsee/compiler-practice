#include "table.h"

#define STCMP(e, i, t)           \
    (                            \
        (e)->id && (i) && (t) && \
        id_cmp((e)->id, (i)) &&  \
        (e)->type == (t)         \
    )

#define TCMP(e, t) ((e) && (e)->type == (t))

#define SCMP(e, i) ((e)->id && (i) && id_cmp((e)->id, (i)))

Table* table_new(const Entry* entry){
    Table* t = (Table*)malloc(sizeof(Table));
    Entry* e = entry_isolate(entry);
    t->head = e;
    t->tail = e;
    return t;
}

/* checkless attachment */
void _retail(Table* t, Entry* e){
    t->tail->next = e;
    t->tail = e;
}

/* no copy constructor, no reset */
Table* _table_new(Entry* e){
    Table* t = (Table*)malloc(sizeof(Table));
    t->head = e;
    t->tail = e;
    return t;
}

Table* table_add(Table* table, const Entry* entry){
    Entry* e = entry_isolate(entry);
    if(!table){
        table = _table_new(e);
    } else {
        if(table->tail){
            _retail(table, e);
        } else {
            fprintf(stderr, "WARNING: cannot add to tailless table\n");
        }
    }
    return table;
}

void _join(Table* a, Table* b){
    a->tail->next = b->head;
    a->tail = b->tail;
}

Table* table_join(Table* a, Table* b){
    if(b && b->head){
        if(a && a->head){
            _join(a, b);
        } else {
            a = b;
        }
    }
    return a;
}

Table* table_recursive_get(const Table* table, Id* id, TType type){
    Table* out = NULL;
    for(Entry* e = table->head; e; e = e->next){
        if(STCMP(e, id, type)){
            out = table_add(out, e);
        }
        if(TCMP(e, T_COMPOSITION)){
            out = table_join(out, table_recursive_get(e->value.composition, id, type)); 
        }
    }
    return out;
}

Table* table_path_get(const Table* table, Path* path, TType type){
    Table* out = NULL;
    for(Entry* e = table->head; e; e = e->next){
        if(path_is_base(path)){
            if(STCMP(e, path->id, type)){
                out = table_add(out, e);
            }
            if(TCMP(e, T_COMPOSITION)){
                out = table_join(out, table_recursive_get(e->value.composition, path->id, type));
            }
        } else {
            if(STCMP(e, path->id, T_COMPOSITION)){
                out = table_join(out, table_path_get(e->value.composition, path->next, type));
            }
        }
    }
    return out;
}

Table* table_selection_get(const Table* table, Selection* selection, TType type){
    Table* out = NULL;
    for(Selection* s = selection; s; s = s->next){
        Table* b = table_path_get(table, s->path, type);
        out = table_join(out, b);
    }
    return out;
}

Table* table_recursive_get_type(const Table* table, TType type){
    Table* out = NULL;
    for(Entry* e = table->head; e; e = e->next){
        if(TCMP(e, type)){
            out = table_add(out, e);
        }
        if(TCMP(e, T_COMPOSITION)){
            Table* down = table_recursive_get_type(e->value.composition, type);
            out = table_join(out, down);
        }
    }
    return out;
}

#undef STCMP
#undef TCMP
#undef SCMP
