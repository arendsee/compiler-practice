#!/usr/bin/env python3

# This example is adapted directly from the documentation for lrparsing:
# http://lrparsing.sourceforge.net/doc/html
#
# lrparsing (and presumably this snippet) was written by Russel Stuart
#
# I'll be messing with it to figure out how it all works

import lrparsing
from lrparsing import Keyword, List, Prio, Ref, THIS, Token, Tokens

class ExprParser(lrparsing.Grammar):

    class T(lrparsing.TokenRegistry):
        ident = Token(re="[A-Za-z_][A-Za-z_0-9]*")

    l_type = Ref("l_type")
    l_atom = Ref("l_atom")
    l_list = Ref("l_list")

    l_atom  = T.ident \
            | '(' + l_atom + ')'
    l_list  = '[' + l_type + ']' \
            | '(' + l_list + ')'
    l_tuple = '(' + l_type + ','  + List(l_type, ',' ) + ')'
    l_func  = '(' + l_type + '->' + List(l_type, '->') + ')'
    l_type = l_atom | l_tuple | l_list | l_func

    START = l_type 

parse_tree = ExprParser.parse("[((x,y,z),(A -> B),c)]")
print(ExprParser.repr_parse_tree(parse_tree))
