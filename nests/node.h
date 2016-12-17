#ifndef __NODE_H__
#define __NODE_H__

#include <stdlib.h>
#include <stdio.h>

int yylex(void);
void yyerror(const char *);

typedef struct Node{
    struct Node* prev;
    struct Node* down;
    struct Node* next;
    int value; 
} Node;

Node* new_node();
void free_node(Node* n);
void print_node(Node* n);
Node* rewind_node(Node* n);

#endif
