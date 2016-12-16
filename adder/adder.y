%{
    #include <stdio.h>
    #include "lex.yy.h"
    int yylex(void);
    void yyerror(const char *);
%}

%define api.value.type {int}

%token NUM

%left '+'

%%

input
  : %empty
  | input exp { printf("%ld\n", $2); }
;

exp
  : NUM         { $$ = $1; }
  | exp '+' exp { $$ = $1 + $3; }
;

%%

void yyerror(char const *s){
    fprintf(stderr, "Awww fuck! Got an errror: %s\n", s);
}

int main(void){
    return yyparse();
}
