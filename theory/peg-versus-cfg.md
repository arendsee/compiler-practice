# PEG versus CFG

Parsing Expression Grammar (PEG) and Context-Free Grammar (CFG) are two formal
approaches to specifying grammars.

PEGs cannot be ambiguous. All choices are ordered and the first to succeed is
used. See the wikipedia article.

`pacrat` parser, guarantees linear time (rather than exponential worst-case) at
the cost of high memory usage (memoizes results).
