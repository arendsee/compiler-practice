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
    l_atom = T.ident
    l_tuple = '(' + List(l_type, ',') + ')'
    l_func = '(' + List(l_type, '->') + ')'
    l_list = '[' + l_type + ']'

    l_type = l_atom | l_tuple | l_func | l_list
    START = l_type 

parse_tree = ExprParser.parse("(a,b,c)")
print(ExprParser.repr_parse_tree(parse_tree))

#  import lrparsing
#  from lrparsing import Keyword, List, Prio, Ref, THIS, Token, Tokens
#
#  class ExprParser(lrparsing.Grammar):
#
#      class T(lrparsing.TokenRegistry):
#          integer = Token(re="[0-9]+")
#          ident = Token(re="[A-Za-z_][A-Za-z_0-9]*")
#
#      expr = Ref("expr")
#      atom = T.ident | T.integer | '(' + expr + ')'
#      expr = Prio(
#          atom,
#          THIS << '+' << THIS
#      )
#      START = expr
#
#  parse_tree = ExprParser.parse("b + 1 + 42 + (3 + foo)")
#  print(ExprParser.repr_parse_tree(parse_tree))
