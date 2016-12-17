%{
#include <stdio.h>
#include "lex.yy.h"
%}

%code requires {
#include "node.h"
}

%define api.value.type union

%token <char*> NAME
%token <int> NUM

%type <Node*> exp;

%%

input
  : %empty
  | input NAME '=' exp { print_node($4); free($4); printf("-------\n"); }
;

/* this is a STUB, it ignores groups, thus flattening the tree */
exp
  : NUM     { $$ = new_node(); $$->value = $1; }
  | '('     { $$ = NULL; }
  | exp NUM { if($1){
                $$->next = new_node();
                $$->next->prev = $$;
                $$ = $$->next;
              } else {
                $$ = new_node();
              }
              $$->value = $2;
            }
  | exp ')' { $$ = $1; }
  | exp '(' { $$ = $1; }
;

%%

void yyerror(char const *s){
    fprintf(stderr, "Awww fuck! Got an errror: %s\n", s);
}

int main(void){
    return yyparse();
}
