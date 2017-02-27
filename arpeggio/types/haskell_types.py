#!/usr/bin/env python3

from __future__ import unicode_literals

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
        if self.debug:
            print(" - Entering typeIdent")
            print(node.value)
        return(node.value)

    def visit_typeTuple(self, node, children):
        if self.debug:
            print(" - Entering typeTuple")
            print(node.value)
        return("tuple(%s)" % ','.join(children))

    def visit_typeArray(self, node, children):
        if self.debug:
            print(" - Entering typeArray")
            print(node.value)
        return("array(%s)" % children[0])

    def visit_typeFunc(self, node, children):
        if self.debug:
            print(" - Entering typeFunc")
            print(node.value)
        return("function(%s)" % ','.join(children))

    def visit_typeExpr(self, node, children):
        if self.debug:
            print(" - Entering typeExpr")
            print(node.value)
        return(children[0])

    def visit_typeType(self, node, children):
        if self.debug:
            print(" - Entering typeType")
            print(node.value)
        return(children[0])

def main(debug=False):
    parser = ParserPython(typeType, debug=debug)

    parse_tree = parser.parse("([(a,b,c)],(x->z))")

    result = visit_parse_tree(parse_tree, typeTypeVisitor(debug=False))

    print(result)

if __name__ == "__main__":
    main()
