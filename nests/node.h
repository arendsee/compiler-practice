#ifndef __NODE_H__
#define __NODE_H__

#include <stdlib.h>
#include <stdio.h>

int yylex(void);
void yyerror(const char *);

typedef struct Node{
    struct Node* parent;
    struct Node* rhs;
    struct Node* lhs;
    int value; 
} Node;

Node* new_node();
void free_node(Node* n);
void print_tree(Node* n);
Node* get_root(Node* n);

#endif
