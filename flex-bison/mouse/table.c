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

Table* _table_composon_io(const Entry* entry, bool is_input){
    if(!entry){
        return NULL;
    }
    if(!(TCMP(entry, C_COMPOSON) || TCMP(entry, C_NEST))){
        fprintf(stderr,
            "ERROR: input must be a composon in "
            "table_composon_{in/out}puts, returning NULL.\n"); 
        return NULL;
    }
    Table* result = NULL;
    for(Entry* e = entry->value.table->head; e; e = e->next){
        switch(e->type){
            case C_MANIFOLD:
                result = table_add(result, e);
                break;
            case C_NEST:
                {
                    // output comes from the first (outermost) composon of the
                    // nested expression, while input goes to the last
                    // (innermost).
                    Entry* ne = is_input ? e->value.table->tail : e->value.table->head;
                    result = table_join(result, _table_composon_io(ne, is_input));
                }
                break;
            default:
                fprintf(stderr, "Illegal type in composition\n");
        }
    }
    return result;
}

Table* table_composon_outputs(const Entry* entry){
    return _table_composon_io(entry, false);
}

Table* table_composon_inputs(const Entry* entry){
    return _table_composon_io(entry, true);
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

bool is_recursive(TType type){
    return type == T_PATH ||
           type == C_COMPOSON ||
           type == C_NEST;
}

Table* table_recursive_get(const Table* table, Id* id, TType type){
    Table* out = NULL;
    for(Entry* e = table->head; e; e = e->next){
        if(STCMP(e, id, type)){
            out = table_add(out, e);
        }
        if(is_recursive(e->type)){
            out = table_join(out, table_recursive_get(e->value.table, id, type)); 
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
            if(is_recursive(e->type)){
                out = table_join(out, table_recursive_get(e->value.table, path->id, type));
            }
        } else {
            if(SCMP(e, path->id) && is_recursive(e->type)){
                out = table_join(out, table_path_get(e->value.table, path->next, type));
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
        if(is_recursive(e->type)){
            Table* down = table_recursive_get_type(e->value.table, type);
            out = table_join(out, down);
        }
    }
    return out;
}

#undef STCMP
#undef TCMP
#undef SCMP
