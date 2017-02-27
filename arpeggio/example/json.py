#!/usr/bin/env python3

from __future__ import unicode_literals

import os
from arpeggio import *
from arpeggio import RegExMatch as _

def TRUE():     return "true"
def FALSE():    return "false"
def NULL():     return "null"
def jsonString():       return '"', _('[^"]*'),'"'
def jsonNumber():       return _('-?\d+((\.\d*)?((e|E)(\+|-)?\d+)?)?')
def jsonValue():        return [jsonString, jsonNumber, jsonObject, jsonArray, TRUE, FALSE, NULL]
def jsonArray():        return "[", Optional(jsonElements), "]"
def jsonElements():     return jsonValue, ZeroOrMore(",", jsonValue)
def memberDef():        return jsonString, ":", jsonValue
def jsonMembers():      return memberDef, ZeroOrMore(",", memberDef)
def jsonObject():       return "{", Optional(jsonMembers), "}"
def jsonFile():         return jsonObject, EOF


class JsonFileVisitor(PTNodeVisitor):

    def visit_memberDef(self, node, children):
        if len(children) == 2:
            print("%s = %s" % (children[0], children[1]))

def main(debug=False):
    parser = ParserPython(jsonFile, debug=debug)

    current_dir = os.path.dirname(__file__)
    testdata = open(os.path.join(current_dir, 'test.json')).read()

    parse_tree = parser.parse(testdata)

    result = visit_parse_tree(parse_tree, JsonFileVisitor(debug=debug))

if __name__ == "__main__":
    main()
