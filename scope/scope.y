%{
    #include <stdio.h>
    #include "lex.yy.h"
    int yylex(void);
    void yyerror(const char *);
%}

%define api.value.type union

%token <int>   INTEGER
%token <char*> VARIABLE
%token <char*> IDENTIFIER

%type <int> expression
%type <int> variable

%left '+'
%right '.'
%nonassoc '='

%%

statement
  : IDENTIFIER '=' INT
  | SAY expresion 
  | SCOPE IDENTIFIER '{' statement '}'
  | statement statement

expression
  : variable  '+' variable  { $$ = $1 + $3; }
  | expresion '+' variable  { $$ = $1 + $3; }

variable
  : VARIABLE               { $$ = $1; }
  | NAMESPACE '.' variable { $$ = $3; }
  | variable  '.' variable { $$ = $3; }

%%

void yyerror(char const *s){
    fprintf(stderr, "Awww fuck! Got an errror: %s\n", s);
}

int main(void){
    return yyparse();
}
