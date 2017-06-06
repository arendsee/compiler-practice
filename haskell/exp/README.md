# Exp language and the Hindley-Milner Algorithm

The Hindley-Milner algorithm is a implicit type inference algorithm. It is
the basis of the type systems of the ML family of languages. Haskell
modifies the algorithm.

Here I will write my own simple implementation of a Hindley-Milner
algorithm. Based on the Exp language. With the grammar:

```
e := e | e1 e2 | \x . e | let x = e1 in e2
```

This is lambda calculus with a let extension.

For example

```
let zero = \s . \z . s z in
(
  let succ = \f . \s . \z . s (f s z) in
  (
    succ zero
  )
)
```
