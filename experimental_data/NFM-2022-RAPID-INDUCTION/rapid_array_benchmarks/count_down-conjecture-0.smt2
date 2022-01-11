; main()
; {
;    x = (x) * (x) @l5
;    while (x > 2) @l7
;    {
;       x = (x) - (1) @l9
;    }
; }
; 

(set-logic UFDTLIA)

(declare-nat Nat zero s p Sub)
(declare-sort Time 0)
(declare-sort Trace 0)
(declare-program-var x (Time) Int)
(declare-time-point l5 Time)
(declare-time-point l7 (Nat) Time)
(declare-final-loop-count nl7 Nat)
(declare-time-point l9 (Nat) Time)
(declare-time-point main_end Time)
(declare-const t1 Trace)
(declare-lemma-predicate Dense-decreasing-x-l7 () Bool)

; Axiom: target symbol definitions for symbol elimination
(assert
   true
)

; Axiom: Semantics of function main
(assert
   (and
      ;Loop at location l7
      (and
         ;Define variable values at beginning of loop
         (= (x (l7 zero)) (* (x l5) (x l5)))
         ;The loop-condition holds always before the last iteration
         (forall ((Itl7 Nat))
            (=>
               (Sub Itl7 nl7)
               (> (x (l7 Itl7)) 2)
            )
         )
         ;Semantics of the body
         (forall ((Itl7 Nat))
            (=>
               (Sub Itl7 nl7)
               ;Define value of variable x at beginning of next iteration
               (= (x (l7 (s Itl7))) (- (x (l7 Itl7)) 1))
            )
         )
         ;The loop-condition doesn't hold in the last iteration
         (not
            (> (x (l7 nl7)) 2)
         )
      )
      ;Define referenced terms denoting variable values at main_end
      (= (x main_end) (x (l7 nl7)))
   )
)

; Definition: Dense-decreasing for x-l7
(assert
   (=
      Dense-decreasing-x-l7
      (forall ((Itl7 Nat))
         (=>
            (Sub Itl7 nl7)
            (or
               (= (x (l7 (s Itl7))) (x (l7 Itl7)))
               (= (x (l7 (s Itl7))) (- (x (l7 Itl7)) 1))
            )
         )
      )
   )
)

; Axiom: already-proven-lemma x-2-equality-axiom
(assert
   (=>
      (and
         Dense-decreasing-x-l7
         (>= (x (l7 zero)) 2)
      )
      (= (x (l7 nl7)) 2)
   )
)

; Axiom: user-axiom-0
(assert
   (> (x l5) 2)
)

; Conjecture: count_down-conjecture-0
(assert-not
   (= (x main_end) 2)
)

(check-sat)

