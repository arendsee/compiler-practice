%{
#include "wii.tab.h"
/* zzz lexer section 1 */
%}

%option header-file="lex.yy.h"
%option noyywrap

num [1-9][0-9]*

%%

{num}   { sscanf(yytext, "%ld", &yylval); return NUM; }
.|\n    { }

%%

/* zzz lexer section 3 */
