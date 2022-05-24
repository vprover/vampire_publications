; main()
; {
;    i = 0 @l5
;    j = 0 @l6
;    while (j < alength) @l7
;    {
;       if (3 == 5) @l9
;       {
;          i = 2 @l10
;       }
;       else
;       {
;          skip @l12
;       }
;       j = (j) + (1) @l14
;    }
; }
; 

(set-logic UFDTLIA)

(declare-nat Nat zero s p Sub)
(declare-sort Time 0)
(declare-sort Trace 0)
(declare-const-var alength Int)
(declare-program-var i (Time) Int)
(declare-program-var j (Time) Int)
(declare-time-point l5 Time)
(declare-time-point l6 Time)
(declare-time-point l7 (Nat) Time)
(declare-final-loop-count nl7 Nat)
(declare-time-point l9 (Nat) Time)
(declare-time-point l10 (Nat) Time)
(declare-time-point l12 (Nat) Time)
(declare-time-point l14 (Nat) Time)
(declare-time-point main_end Time)
(declare-const t1 Trace)
(declare-lemma-predicate Dense-increasing-j-l7 () Bool)

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
         (and
            (= (j (l7 zero)) 0)
            (= (i (l7 zero)) 0)
         )
         ;The loop-condition holds always before the last iteration
         (forall ((Itl7 Nat))
            (=>
               (Sub Itl7 nl7)
               (< (j (l7 Itl7)) alength)
            )
         )
         ;Semantics of the body
         (forall ((Itl7 Nat))
            (=>
               (Sub Itl7 nl7)
               (and
                  ;Semantics of IfElse at location l9
                  (and
                     ;Semantics of left branch
                     (=>
                        (= 3 5)
                        (= (i (l14 Itl7)) 2)
                     )
                     ;Semantics of right branch
                     (=>
                        (not
                           (= 3 5)
                        )
                        (= (i (l14 Itl7)) (i (l7 Itl7)))
                     )
                  )
                  ;Define value of variable j at beginning of next iteration
                  (= (j (l7 (s Itl7))) (+ (j (l7 Itl7)) 1))
                  ;Define value of variable i at beginning of next iteration
                  (= (i (l7 (s Itl7))) (i (l14 Itl7)))
               )
            )
         )
         ;The loop-condition doesn't hold in the last iteration
         (not
            (< (j (l7 nl7)) alength)
         )
      )
      ;Define referenced terms denoting variable values at main_end
      (= (i main_end) (i (l7 nl7)))
   )
)

; Definition: Dense-increasing for j-l7
(assert
   (=
      Dense-increasing-j-l7
      (forall ((Itl7 Nat))
         (=>
            (Sub Itl7 nl7)
            (or
               (= (j (l7 (s Itl7))) (j (l7 Itl7)))
               (= (j (l7 (s Itl7))) (+ (j (l7 Itl7)) 1))
            )
         )
      )
   )
)

; Axiom: already-proven-lemma j-alength-equality-axiom
(assert
   (=>
      (and
         Dense-increasing-j-l7
         (<= (j (l7 zero)) alength)
      )
      (= (j (l7 nl7)) alength)
   )
)

; Axiom: user-axiom-0
(assert
   (= alength 10)
)

; Conjecture: eq-conjecture-0
(assert-not
   (= (i main_end) 0)
)

(check-sat)

