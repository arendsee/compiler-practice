%{
    #include <stdio.h>
    #include "lex.yy.h"

    void yyerror(const char *);
%}

%code requires{
#include "mil.h"
Table* table;
}

%define api.value.type union 

%token <Id*> VARIABLE
%token <Selection*> SELECTION

%type <Entry*> exp
%type <Table*> composition

%token EFFECT COMPOSITION

%left '.'

%%

/* TODO
 * [ ] fix the segfault in path_recursive_get_type
 * [ ] add recursive copy for expanding groups
 * [ ] add nesting
 */

input
    : exp { table = table_new($1); }
    | input exp { table = table_add(table, $2); }

exp
    : COMPOSITION VARIABLE '=' composition {
        $$ = entry_new($2, T_COMPOSITION, $4);
    }
    | EFFECT SELECTION '=' VARIABLE {
        if($4->label){
            fprintf(stderr, "WARNING: labels are ignored on rhs of effect\n");
        }
        Effect* effect = effect_new($2, $4->name);
        $$ = entry_new(NULL, T_EFFECT, effect); 
    }

composition
    : VARIABLE {
        Manifold* m = manifold_new();
        Entry* e = entry_new($1, T_MANIFOLD, m);
        $$ = table_new(e);
    }
    | composition '.' composition { $$ = table_join($1, $3); }

%%

void yyerror(char const *s){
    fprintf(stderr, "Oh no Mr. Wizard! %s\n", s);
}
