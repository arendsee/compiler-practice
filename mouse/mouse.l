%{
#include <ctype.h>
#include <stdio.h>

#include "mouse.tab.h"

FILE* toklog;
#define LOG(x) fprintf(toklog, x); fflush(toklog);
#define LOGV(x,a) fprintf(toklog, x, a); fflush(toklog);
%}

%option header-file="lex.yy.h"
%option noyywrap

var       [a-zA-Z]+
ws        [ \t\n\r]
comment   #.*\n

%%

{ws} { LOGV("%s", yytext); }

{comment} { }

composition { LOG("COMPOSITION ");  return COMPOSITION; }
effect      { LOG("EFFECT "); return EFFECT; }
{var}       { LOGV("VARIABLE:%s ", yytext); yylval.VARIABLE = strdup(yytext); return VARIABLE; }

.    { LOGV("%c ", yytext[0]); return yytext[0]; }

%%

void print_mil(Table* t){
    if(t && t->entry){
        for( ; t; t = t->next){
            switch(t->entry->type){
                case T_COMPOSITION:
                    printf("COMPOSITION\n");
                    print_mil(t->entry->value.composition);
                    break;
                case T_EFFECT:
                    printf("EFFECT\n");
                    break;
                case T_MANIFOLD:
                    printf("MANIFOLD\n");
                    break;
                case T_UNDEFINED:
                    fprintf(stderr, "UNDEFINED - this shouldn't happen\n");
                    break;
                default:
                    fprintf(stderr, "This really should not happen\n");
                    break;
            }
        }
    }
}

int main(void){
    toklog = fopen("tok.log", "w");
    int status = yyparse();
    fclose(toklog);
    print_mil(table);
    return status;
}
