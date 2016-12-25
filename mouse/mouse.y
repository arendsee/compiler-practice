%{
    #include <stdio.h>
    #include "lex.yy.h"

    int yylex(void);
    void yyerror(const char *);
%}

%code requires{
#include "table.h"
Table* table;
}

%define api.value.type union 

%token <char*> VARIABLE
%token <Path*> PATH

%type <Entry*> exp
%type <Table*> composition

%token EFFECT COMPOSITION

%left '.'

%%

input
    : exp { table = table_add(table, $1); }
    | input exp { table = table_add(table, $2); }

exp
    : COMPOSITION VARIABLE '=' composition {
        $$ = entry_new($2, T_COMPOSITION, $4);
    }
    | EFFECT PATH '=' VARIABLE {
        Effect* effect = effect_new($2, $4);
        $$ = entry_new(NULL, T_EFFECT, effect); 
    }

composition
    : VARIABLE {
        Manifold* m = manifold_new($1);
        Entry* e = entry_new($1, T_MANIFOLD, m);
        $$ = table_add(NULL, e);
    }
    | composition '.' composition { $$ = table_join($1, $3); }

%%

void yyerror(char const *s){
    fprintf(stderr, "Awww fuck! Got an errror: %s\n", s);
}
