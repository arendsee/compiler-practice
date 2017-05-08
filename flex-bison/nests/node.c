#include "node.h"

Node* new_node(){
    return (Node*)calloc(1, sizeof(Node));
}

Node* rewind_node(Node* n){
    if(n) {
        while(n->l || n->u) {
            if(n->l)
                n = n->l;
            if(n->u)
                n = n->u;
        }
    }
    return n;
}

void print_node_r(Node* n, int depth){
    if(n){
        if(n->d){
            Node* d = n->d;
            for( ; d->l; d = d->l) {}
            printf("%*s\\\n", depth, "");  
            print_node_r(d, depth + 1);
        } else {
            printf("%*s%d\n", depth, "", n->value);  
        }
        print_node_r(n->r, depth);
    }
}

void print_node(Node* n){
    n = rewind_node(n);
    print_node_r(n, 0);
}

void free_node(Node* n){
    if(n){
        if(n->r)
            n->r->l = NULL;
            free_node(n->r);
        if(n->l)
            n->l->r = NULL;
            free_node(n->l);
        free(n);
    }
}
