#!/usr/bin/env python3

from arpeggio import *
from arpeggio import RegExMatch as _

def typeIdent(): return _('[A-Za-z0-9_]+')
def typeTuple(): return '(', typeExpr, OneOrMore(',', typeExpr), ')'
def typeArray(): return '[', typeExpr, ']'
def typeFunc():  return '(', typeExpr, OneOrMore('->', typeExpr), ')'
def typeExpr():  return [typeIdent, typeTuple, typeArray, typeFunc]
def typeType():  return typeExpr, EOF


class typeTypeVisitor(PTNodeVisitor):

    def visit_typeIdent(self, node, children):
        return(node.value)

    def visit_typeTuple(self, node, children):
        return("tuple(%s)" % ','.join(children))

    def visit_typeArray(self, node, children):
        return("array(%s)" % children[0])

    def visit_typeFunc(self, node, children):
        return("function(%s)" % ','.join(children))

    def visit_typeExpr(self, node, children):
        return(children[0])

    def visit_typeType(self, node, children):
        return(children[0])

def main():
    parser = ParserPython(typeType)

    parse_tree = parser.parse("([(a,b,c)],(x->z))")

    result = visit_parse_tree(parse_tree, typeTypeVisitor())

    print(result)

if __name__ == "__main__":
    main()
