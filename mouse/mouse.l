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

int main(void){
    toklog = fopen("tok.log", "w");
    return yyparse();
    fclose(toklog);
}
