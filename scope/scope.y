%{
    #include <stdio.h>
    #include "lex.yy.h"
    
    int yylex(void);
    void yyerror(const char *);
%}

%code requires{
#include "table.h"
Scope* current_scope;
}

%define api.value.type union

%token <int>   INTEGER
%token <char*> VARIABLE
%token <char*> IDENTIFIER
%token <char*> NAMESPACE
%token SCOPE SAY

%type <int> expression
%type <Path*> namespace

%left '+'
%nonassoc '='

%%

statement
  : phrase 
  | statement phrase
  | statement SCOPE VARIABLE '{' statement '}'

phrase
  : IDENTIFIER '=' INTEGER
  | SAY expression 

expression
  : VARIABLE {
        Table* t = lookup($1, current_scope);
        if(t){
            $$ = t->value.integer;
        } else {
            fprintf(stderr, "Could find '%s' in current scope\n", $1);
        }
    }
  | namespace '.' VARIABLE {
        Scope* scope = lookup_scope($1, current_scope);
        Table* t = lookup($3, scope);
        if(t){
            $$ = t->value.integer;
        } else {
            fprintf(stderr, "Could find '%s' in specified scope\n", $3);
        }
    }
  | expression '+' expression { $$ = $1 + $3; }

namespace
  : NAMESPACE { $$ = new_Path($1); }
  | namespace '.' NAMESPACE { $$ = $1; Path* p = new_Path($3); $$->next = p; }

%%

void yyerror(char const *s){
    fprintf(stderr, "Awww fuck! Got an errror: %s\n", s);
}
