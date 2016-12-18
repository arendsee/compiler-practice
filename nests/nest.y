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
  | input NAME '=' exp { print_node($4); free_node($4); printf("-------\n"); }
;

exp
  : NUM             {
                      $$ = new_node();
                      $$->value = $1;
                    }
  | '(' exp ')'     {
                      $$ = new_node(); 
                      $$->d = $2;
                      $$->d->u = $$;
                    }
  | exp NUM         {
                      $$->r = new_node();
                      $$->r->l = $$;
                      $$->r->value = $2;
                      $$ = $$->r;
                    }
  | exp '(' exp ')' {
                      $1->r = new_node();
                      $1->r->l = $1;
                      $1->r->d = $3;
                      $1->r->d->u = $1->r;
                      $$ = $1->r;
                    }
;

%%

void yyerror(char const *s){
    fprintf(stderr, "Awww fuck! Got an errror: %s\n", s);
}

int main(void){
    return yyparse();
}
