TARGET=adder
CC=gcc

SRC_BISON=${TARGET}.y
SRC_LEXER=${TARGET}.l

C_LEXER=lex.yy.c
H_LEXER=lex.yy.h
C_PARSER=${TARGET}.tab.c
H_PARSER=${TARGET}.tab.h

all: ${TARGET}

${C_PARSER} ${H_PARSER}: ${SRC_BISON}
	bison -d ${SRC_BISON}

${C_LEXER}: ${SRC_LEXER} ${H_PARSER}
	flex ${SRC_LEXER}

${TARGET}: ${C_LEXER} ${C_PARSER} ${H_PARSER}
	${CC} -o ${TARGET}.out ${C_PARSER} ${C_LEXER}

clean:
	rm -f ${TARGET}.out ${C_PARSER} ${H_PARSER} ${C_LEXER} ${H_LEXER}
