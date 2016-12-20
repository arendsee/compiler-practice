%{
    #include <stdio.h>
    #include "lex.yy.h"
    #include "table.h"
    int yylex(void);
    void yyerror(const char *);

    Scope* current_scope;
%}

%define api.value.type union

%token <int>   INTEGER
%token <char*> VARIABLE
%token <char*> IDENTIFIER
%token <char*> NAMESPACE
%token SCOPE SAY

%type <int> expression
%type <char*> variable
%type <Path*> namespace

%left '+'
%right '.'
%nonassoc '='

%%

statement
  : %empty { current_scope = new_Scope(NULL); }
  | statement IDENTIFIER '=' INTEGER
  | statement SAY expression 
  | statement SCOPE IDENTIFIER '{' statement '}'
  | statement statement

expression
  : VARIABLE {
        $$ = lookup($1, current_scope);
        if($$){
            $$ = $$->value->integer;
        } else {
            fprintf(stderr, "Could find '%s' in current scope\n", $1);
        }
    }
  | namespace '.' VARIABLE {
        Scope* scope = lookup_scope($1, current_scope);
        $$ = loopup($3, scope)
        if($$){
            $$ = $$->value->integer;
        } else {
            fprintf(stderr, "Could find '%s' in specified scope\n", $3);
        }
    }
  | expression '+' expression { $$ = $1 + $3; }

namespace
  : NAMESPACE { $$ = new_Path($1); }
  | namespace '.' namespace { $$ = new_Path($1); $$->next = $2; }

%%

void yyerror(char const *s){
    fprintf(stderr, "Awww fuck! Got an errror: %s\n", s);
}

int main(void){
    return yyparse();
}
