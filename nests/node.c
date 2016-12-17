#include "node.h"

Node* new_node(){
    return (Node*)calloc(1, sizeof(Node));
}

Node* get_root(Node* n){
    if(n) {
        while(n->parent) n = n->parent;
    }
    return n;
}

void print_tree_r(Node* n, int depth){
    if(n){
        printf("%*s %d\n", depth, "-", n->value);  
        print_tree_r(n->rhs, depth);
        print_tree_r(n->lhs, depth + 1);
    }
}

void print_tree(Node* n){
    n = get_root(n);
    print_tree_r(n, 0);
}

void free_node(Node* n){
    if(n){
        if(n->rhs)
            free_node(n->rhs);
        if(n->lhs)
            free_node(n->lhs);
        free(n);
    }
}
