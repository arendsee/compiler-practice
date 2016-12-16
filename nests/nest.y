%{
    #include <stdio.h>
    #include "lex.yy.h"
    int yylex(void);
    void yyerror(const char *);
    char* BUFFER;
%}

%define api.value.type {char*}

%token NAME
%token NUM

%%

input
  : %empty
  | input NAME '=' exp { printf("%s = %s\n", $2, BUFFER); }
;

exp
  : NUM     { strcpy(BUFFER, $1);  }
  | '('     { strcpy(BUFFER, "["); }
  | exp NUM { strcpy(BUFFER + strlen(BUFFER), $2); }
  | exp ')' { strcpy(BUFFER + strlen(BUFFER), "]"); }
  | exp '(' { strcpy(BUFFER + strlen(BUFFER), "["); }

%%

void yyerror(char const *s){
    fprintf(stderr, "Awww fuck! Got an errror: %s\n", s);
}

int main(void){
    BUFFER = (char*)calloc(1024, sizeof(char));
    return yyparse();
    free(BUFFER);
}
