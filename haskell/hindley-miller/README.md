# Hindley-Milner Algorithm

The Hindley-Milner algorithm is a implicit type inference algorithm. It is
the basis of the type systems of the ML family of languages. Haskell
modifies the algorithm.

Here I will write my own simple implementation of a Hindley-Milner
algorithm.

Hindley-Milner types a simple lambda calculus.

```
e : x
  | e1 e2
  | lambda x . expr 
  | let x = e1 in e2
```

For example

```
let zero = lambda s . lambda z . s z in
  let succ = lambda f . lambda s . lambda z . s (f s z) in
    succ zero
```
