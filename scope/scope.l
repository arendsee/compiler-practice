%{
    #include "scope.tab.h"
%}

%option header-file="lex.yy.h"
%option noyywrap

int       [1-9][0-9]*
ident     [a-zA-Z]+[ \t\n]*=
namespace [a-zA-Z]+\.
var       [a-zA-Z]+
ws        [ \t\n\r]
comment   #.*\n

%%

{ws} { }

{comment} { }

{int} { sscanf(yytext, "%ld", &yylval.INTEGER); return INTEGER; }

{namespace} {
    char* s = strdup(yytext);
    unput('.');
    s[strlen(s)-1] = '\0';
    yylval.NAMESPACE = s;
    return NAMESPACE;
}

{ident}   {
    char* s = strdup(yytext);
    int i = strlen(s);
    unput('=');
    while(i--){
        char c = yytext[i-1];
        if(c == '=' || isspace(c)){
            s[i] = '\0';
        }
    }
    yylval.IDENTIFIER = s;
    return IDENTIFIER;
}

say   { return SAY; }

scope { return SCOPE; }

{var} { yylval.VARIABLE = strdup(yytext); return VARIABLE; }

.    { return yytext[0]; }
