%{
    #include <stdio.h>
    #include "lex.yy.h"
    
    int yylex(void);
    void yyerror(const char *);
%}

%define api.value.type union 

%token <char*> VARIABLE

%token EFFECT COMPOSITION

%left '.'

%%

input
    : exp
    | input exp

exp
    : COMPOSITION VARIABLE '=' composition
    | EFFECT VARIABLE '=' VARIABLE

composition
    : VARIABLE
    | composition '.' composition
    

%%

void yyerror(char const *s){
    fprintf(stderr, "Awww fuck! Got an errror: %s\n", s);
}
