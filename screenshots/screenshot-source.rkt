#lang racket
(require containment-patterns
         rackunit)

; seemlessly extract a 🍊 from
; a deeply-nested situation 🔥
(check-equal?
 (match `((🔥 🔥
             (🔥 (4 🍆)))
          (🔥 (🔥
              (1 🍊)) 🔥 🔥)
          (2 🍐) (🔥))
   [(⋱ `(1 ,a)) a])
 `🍊)


