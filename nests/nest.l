%{
    #include "nest.tab.h"
%}

%option header-file="lex.yy.h"
%option noyywrap

num [1-9][0-9]*
name [a-zA-Z]+
ws  [ \n\t\r]

%%

{ws}    { }
{num}   { scanf("%d", &yylval.NUM); return NUM;  }
{name}  { yylval.NAME = strdup(yytext); return NAME; }
.       { return yytext[0]; }
