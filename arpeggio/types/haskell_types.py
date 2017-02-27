#!/usr/bin/env python3

from __future__ import unicode_literals

import os
from arpeggio import *
from arpeggio import RegExMatch as _

def typeIdent(): return _('[A-Za-z0-9_]+')
def typeTuple(): return '(', typeExpr, ZeroOrMore(',', typeExpr), ')'
def typeArray(): return '[', typeExpr, ']'
def typeFunc():  return '(', typeExpr, OneOrMore('->', typeExpr), ')'
def typeExpr():  return [typeIdent, typeTuple, typeArray, typeFunc]
def typeType():  return typeExpr, EOF


class typeTypeVisitor(PTNodeVisitor):

    def visit_typeIdent(self, node, children):
        if self.debug:
            print(" - Entering typeIdent")

    def visit_typeTuple(self, node, children):
        if self.debug:
            print(" - Entering typeTuple")

    def visit_typeArray(self, node, children):
        if self.debug:
            print(" - Entering typeArray")

    def visit_typeFunc(self, node, children):
        if self.debug:
            print(" - Entering typeFunc")

    def visit_typeExpr(self, node, children):
        if self.debug:
            print(" - Entering typeExpr")

    def visit_typeType(self, node, children):
        if self.debug:
            print(" - Entering typeType")

def main(debug=False):
    parser = ParserPython(typeType, debug=debug)

    parse_tree = parser.parse("(a,b,c)")

    result = visit_parse_tree(parse_tree, typeTypeVisitor(debug=True))

if __name__ == "__main__":
    main()
