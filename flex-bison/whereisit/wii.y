%{
    #include <stdio.h>
    #include "lex.yy.h"
    int yylex(void);
    void yyerror(const char *);
    /* zzz parser section 1 */
%}

%code requires {
    /* zzz parer code requires block */
}

%token NUM

%%

input
  : %empty
  | input exp { printf("%ld\n", $2); }
;

exp
  : NUM         { $$ = $1; }
  | exp '+' NUM { $$ = $1 + $3; }
;

%%

/* zzz parser section 3 */
void yyerror(char const *s){ }

int main(void){
    return yyparse();
}
