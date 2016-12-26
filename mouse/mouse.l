%{
#include <stdio.h>

#include "mouse.tab.h"

FILE* toklog;
#define LOG(x) fprintf(toklog, x); fflush(toklog);
#define LOGV(x,a) fprintf(toklog, x, a); fflush(toklog);
%}

%option header-file="lex.yy.h"
%option noyywrap

%x S_SELECTION

var       [a-zA-Z]+
path      {var}({ws}*\/{ws}*{var})*
selection {path}(,{path})*
ws        [ \t\n\r]
comment   #.*\n

%%

<INITIAL,S_SELECTION>{ws} { LOGV("%s", yytext); }

{comment} { }

composition {
    LOG("COMPOSITION ");
    return COMPOSITION;
}
effect {
    BEGIN(S_SELECTION);
    LOG("EFFECT ");
    return EFFECT;
}
{var} { 
    LOGV("VARIABLE:%s ", yytext);
    yylval.VARIABLE = strdup(yytext);
    return VARIABLE;
}
<S_SELECTION>{selection} {
    BEGIN(INITIAL);
    LOGV("SELECTION:%s ", yytext);
    yylval.SELECTION = selection_from_str(yytext);
    return SELECTION;
}

.    { LOGV("%c ", yytext[0]); return yytext[0]; }

%%

int main(void){
    toklog = fopen("tok.log", "w");
    int status = yyparse();
    fclose(toklog);
    print_mil(table);
    return status;
}
