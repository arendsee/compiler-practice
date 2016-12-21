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

%type <Scope*> input
%type <Table*> phrase

%left '+'
%nonassoc '='

%%

input
  : phrase {
        $$ = new_Scope();
        current_scope = $$;
        add_table($$, $1);
    }
  | input phrase {
        $$ = $1;
        current_scope = $$;
        add_table($$, $2);
    }
  | input SCOPE VARIABLE '{' input '}' {
        $$ = $1; 
        current_scope = $$;
        Table* t = new_Table($3, T_SCOPE);
        t->value.scope = $5;
        add_table($$, t);
    }

phrase
  : IDENTIFIER '=' INTEGER { $$ = new_Table($1, T_INT); $$->value.integer = $3; }
  | SAY expression { $$ = NULL; printf("> %d\n", $2); }

expression
  : VARIABLE {
        Table* t = lookup($1, current_scope);
        if(t){
            $$ = t->value.integer;
        } else {
            fprintf(stderr, "Could find '%s' in current scope\n", $1);
            exit(EXIT_FAILURE);
        }
    }
  | namespace '.' VARIABLE {
        Scope* scope = lookup_scope($1, current_scope);
        Table* t = lookup($3, scope);
        if(t){
            $$ = t->value.integer;
        } else {
            fprintf(stderr, "Could find '%s' in specified scope\n", $3);
            exit(EXIT_FAILURE);
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
