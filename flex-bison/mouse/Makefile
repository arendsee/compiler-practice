TARGET=mouse
CC=gcc
XXFLAGS=-Wall

SRC_BISON=${TARGET}.y
SRC_LEXER=${TARGET}.l



C_LEXER=lex.yy.c
H_LEXER=lex.yy.h
C_PARSER=${TARGET}.tab.c
H_PARSER=${TARGET}.tab.h

FILES=${C_PARSER} ${C_LEXER} path.c table.c effect.c manifold.c entry.c mil.c selection.c id.c

all:
	bison -d --report=all -Wall ${SRC_BISON}
	flex ${SRC_LEXER}
	${CC} -Wall ${XXFLAGS} -o ${TARGET}.out ${FILES}

clean:
	rm -f ${TARGET}.out ${C_PARSER} ${H_PARSER} ${C_LEXER} ${H_LEXER}
	rm -f tok.log mouse.output
	rm -f vgcore*
