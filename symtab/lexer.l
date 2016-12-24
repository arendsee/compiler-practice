%{
#include <ctype.h>
#include <stdio.h>

#include "scope.tab.h"

FILE* toklog;
#define LOG(x) fprintf(toklog, x); fflush(toklog);
#define LOGV(x,a) fprintf(toklog, x, a); fflush(toklog);
%}

%option header-file="lex.yy.h"
%option noyywrap

int       0|[1-9][0-9]*
ident     [a-zA-Z]+[ \t\n]*=
namespace [a-zA-Z]+\.
var       [a-zA-Z]+
ws        [ \t\n\r]
comment   #.*\n

%%

{ws} { LOGV("%s", yytext); }

{comment} { }

{int} { sscanf(yytext, "%d", &yylval.INTEGER); LOGV("INT:%d ", yylval.INTEGER); return INTEGER; }

{namespace} {
    char* s = strdup(yytext);
    unput('.');
    s[strlen(s)-1] = '\0';
    yylval.NAMESPACE = s;
    LOGV("NAMESPACE:%s ", yylval.NAMESPACE);
    return NAMESPACE;
}

{ident}   {
    char* s = strdup(yytext);
    int i = strlen(s) - 1;
    unput('=');
    while(i--){
        char c = yytext[i];
        if(c == '=' || isspace(c)){
            s[i] = '\0';
        }
    }
    yylval.IDENTIFIER = s;
    LOGV("IDENTIFIER:%s ", yylval.IDENTIFIER);
    return IDENTIFIER;
}

say   { LOG("SAY "); return SAY; }

scope { LOG("SCOPE "); return SCOPE; }

{var} { yylval.VARIABLE = strdup(yytext); LOGV("VARIABLE:%s ", yylval.VARIABLE); return VARIABLE; }

.    { LOGV("%c ", yytext[0]); return yytext[0]; }

%%

int main(void){
    toklog = fopen("tok.log", "w");
    return yyparse();
    fclose(toklog);
}
