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

%type <Entry*> exp
%type <Table*> composition
%type <Path*> path

%token EFFECT COMPOSITION

%left '.'

%%

input
    : exp { table = table_new(); table_add(table, $1); }
    | input exp { table_add(table, $2); }

exp
    : COMPOSITION VARIABLE '=' composition {
        Entry* e = entry_new($2, T_COMPOSITION, $4);
        table_add(table, e);
    }
    | EFFECT path '=' VARIABLE {
        Effect* effect = effect_new($2, $4);
        Entry* e = entry_new(NULL, T_EFFECT, effect); 
        table_add(table, e);
    }

composition
    : VARIABLE {
        $$ = table_new();
        Manifold* m = manifold_new($1);
        Entry* e = entry_new($1, T_MANIFOLD, m);
        table_add($$, e);
    }
    | composition '.' composition { $$ = table_join($1, $3); }

path
    : VARIABLE { $$ = path_new(); $$ = path_put($$, $1); }
    | path '/' VARIABLE { $$ = path_put($1, $3); }

%%

void yyerror(char const *s){
    fprintf(stderr, "Awww fuck! Got an errror: %s\n", s);
}
