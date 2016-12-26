%{
#include <stdio.h>

#include "mouse.tab.h"

FILE* toklog;
#define LOG(x) fprintf(toklog, x); fflush(toklog);
#define LOGV(x,a) fprintf(toklog, x, a); fflush(toklog);
%}

%option header-file="lex.yy.h"
%option noyywrap

%x S_PATH

var     [a-zA-Z]+
path    {var}({ws}*\/{ws}*{var})*
ws      [ \t\n\r]
comment #.*\n

%%

<INITIAL,S_PATH>{ws} { LOGV("%s", yytext); }

{comment} { }

composition {
    LOG("COMPOSITION ");
    return COMPOSITION;
}
effect {
    BEGIN(S_PATH);
    LOG("EFFECT ");
    return EFFECT;
}
{var} { 
    LOGV("VARIABLE:%s ", yytext);
    yylval.VARIABLE = strdup(yytext);
    return VARIABLE;
}
<S_PATH>{path} {
    BEGIN(INITIAL);
    LOGV("PATH:%s ", yytext);
    yylval.PATH = path_from_str(yytext);
    return PATH;
}

.    { LOGV("%c ", yytext[0]); return yytext[0]; }

%%

int main(void){
    toklog = fopen("tok.log", "w");
    int status = yyparse();
    fclose(toklog);
    printf(" --- TABLE ---\n");
    print_table(table);
    printf(" --- MIL ---\n");
    print_mil(table);
    return status;
}
