# containment-patterns
Containment pattern match-expander for racket/match


this library implements several match-expanders which
can be required seperately and used with racket/match

i made ⋱ as a sugar to concisely perform updates on
highly nested structures for syntax rewriting purposes
in structured editing and algebraic stepper prototypes

⋱ , ⋱+ , ⋱1  are match-expanders which implement
containment patterns. these descend into an s-expressions
to capture both matches and their multi-holed context
an n-holed context is captured as a normal n-ary procedure

the pattern (⋱ <context-name> <pattern>) binds a procedure
to <context-name> and a list of <matches> to <pattern>
satisfying (equal? (apply <context> <matches>) target)
