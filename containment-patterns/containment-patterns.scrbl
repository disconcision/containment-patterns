#lang scribble/doc

@; adapted from dave herman's memoize docs

@(require (for-label containment-patterns)
          (for-label memoize) @; remove when done
          )
@begin[(require scribble/manual)
       (require scribble/eval)
       (require scribble/base)]

@(define the-eval
   (let ([the-eval (make-base-eval)])
     (the-eval '(require racket/match "main.rkt"))
     the-eval))

@title[#:tag "top"]{Containment Patterns: Capture contexts in s-expressions}

@author[@author+email["Andrew Blinn" "racket@andrewblinn.com"]]


@; by Andrew Blinn (@tt{dherman at ccs dot neu dot edu})

DOCUMENT UNDER CONSTRUCTION

Containment-patterns implements several match-expanders which can be used anywhere
@racket[racket/match] pattern-matching is available. ⋱ , ⋱+ , and ⋱1 descend
into s-expressions to capture arbitarily deep matches and their multi-holed contexts.

Insert a `⋱` in Dr. Racket by typing `\ddo` (diagonal dots) and then pressing `alt`+`\`

@table-of-contents[]

@defmodule[containment-patterns]{}

@section[#:tag "intro"]{Tangerine Nightmare}

Seamlessly extract a 🍊 from a deeply-nested situation 🔥.

@defexamples[#:eval the-eval
             (define situation
  `((🔥 🔥
       (🔥 (4 🍆)))
    (🔥 (🔥
        (1 🍊)) 🔥 🔥)
    (2 🍐) (🔥)))
              (match situation
   [(⋱ `(1 ,target)) target])]

@subsection[#:tag "examples"]{More examples}

@section[#:tag "why"]{Why}

I implemented containment patterns to write concise updates on
nested structures for syntax-rewriting purposes in structured-editing
and algebraic-stepper prototypes. See @hyperlink["https://github.com/disconcision/fructure" "fructure"]
for an actual use case, or for something simpler,
@hyperlink["https://github.com/disconcision/racketlab/blob/master/choice-stepper.rkt"
           "this toy stepper"].

@subsection[#:tag "how"]{How}

An 'n-holed context' is a captured composable continuation which
can be called in a pattern template as a normal n-ary procedure. These continuations
are captured as the pattern-matcher left-to-right preorder-traverses the target
looking for matches. 



`⋱+` is similar, but it binds a list of all matches instead of just the first result

and `⋱1` insists that the match should be unique.

Caveat: If you're using any matchers which have side-effects, note that the inner pattern is evaluated twice for each successful match.

### ⋱ Usage Examples

See the tests in main.rkt for more examples and additional *secret bonus features* (which may not yet have found their final forms):

1. Check if an item is contained in a nested list:

```racket
(check-true
  (match `(0 (0 1) 2 3)
    [(⋱ 1) #t]))
```

2. Extracting data from a nested context:
```racket
(check-equal?
  (match `(0 (1 zap) 2 3)
    [(⋱ `(1 ,a)) a])
  `zap)
```                

3. Making an update in a nested context:

```racket
(check-equal?
  (match '(0 0 (0 (0 0 (▹ 1)) 0 0))
    [(⋱ context `(▹ ,a))
     (⋱ context `(▹ ,(add1 a))])
  '(0 0 (0 (0 0 (▹ 2)) 0 0))
```

4. Serial substitutions:
(note how `⋱+` is optional in the template; a context is just a function)

```racket
(match '(0 1 (0 1 (1 0)) 0 1)
  [(⋱+ c 1)
   (c 3 4 5 6)])
```

5. Moving a cursor `▹` through a traversal in a nested list of `0`s and `1`s:

```racket
(check-equal?
  (match '(0 1 (0 1 (1 (▹ 0))) 0 1)
    [(⋱+ c (and a (or `(▹ ,_) (? number?))))
     (⋱+ c (match a [`(,x ... (▹ ,y) ,z ,w ...)
                      `(,SPLICEx ,y (▹ ,z) ,SPLICEw)]))])
  '(0 1 (0 1 (1 0)) (▹ 0) 1))

; REPLACE SPLICE ABOVE WITH AT-SYMBOL WHEN IN SITU

@section[#:tag "patterns"]{Pattern Forms}


@defform*[((⋱ <pattern>)
           (⋱ <context-name> <pattern>))]{
Traverses a target s-expression left-to-right and depth-first
until a match to @racket[<pattern>] is found, then hands off control to <pattern>.
Optionally, the context surrounding the match is captured as a
unary procedure called <context-name> satisfying
(@scheme[equal?] (<context> the-match) orginal-sexpr).}

@defform[#:id ⋱1 (⋱1 <context-name> <pattern>)]{
Same as @racket[⋱] except it enforces that the match must be unique.}

@defform[#:id ⋱+ (⋱+ <context-name> <pattern>)]{
}




@; @section[#:tag "forms"]{Forms}

@; @racketgrammar[formals id () (id . formals)]

