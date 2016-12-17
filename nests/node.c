#include "node.h"

Node* new_node(){
    return (Node*)calloc(1, sizeof(Node));
}

Node* rewind_node(Node* n){
    if(n) {
        while(n->prev) n = n->prev;
    }
    return n;
}

void print_node_r(Node* n, int depth){
    if(n){
        if(n->down){
            print_node_r(n->down, depth + 1);
        } else {
            printf("%*s %d\n", depth, "-", n->value);  
        }
        print_node_r(n->next, depth);
    }
}

void print_node(Node* n){
    n = rewind_node(n);
    print_node_r(n, 0);
}

void free_node(Node* n){
    if(n){
        if(n->next)
            n->next->prev = NULL;
            free_node(n->next);
        if(n->prev)
            n->prev->next = NULL;
            free_node(n->prev);
        free(n);
    }
}
