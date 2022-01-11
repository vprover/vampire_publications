; main()
; {
;    i = 0 @l11
;    j = 0 @l12
;    while (i < alength) @l13
;    {
;       i = (i) + (1) @l15
;       j = 1 @l16
;    }
; }
; 

(set-logic UFDTLIA)

(declare-nat Nat zero s p Sub)
(declare-sort Time 0)
(declare-sort Trace 0)
(declare-fun a (Int) Int)
(declare-const-var alength Int)
(declare-program-var i (Time) Int)
(declare-program-var j (Time) Int)
(declare-time-point l11 Time)
(declare-time-point l12 Time)
(declare-time-point l13 (Nat) Time)
(declare-final-loop-count nl13 Nat)
(declare-time-point l15 (Nat) Time)
(declare-time-point l16 (Nat) Time)
(declare-time-point main_end Time)
(declare-const t1 Trace)
(declare-lemma-predicate Dense-increasing-i-l13 () Bool)

; Axiom: target symbol definitions for symbol elimination
(assert
   true
)

; Axiom: Semantics of function main
(assert
   (and
      ;Loop at location l13
      (and
         ;Define variable values at beginning of loop
         (and
            (= (j (l13 zero)) 0)
            (= (i (l13 zero)) 0)
         )
         ;The loop-condition holds always before the last iteration
         (forall ((Itl13 Nat))
            (=>
               (Sub Itl13 nl13)
               (< (i (l13 Itl13)) alength)
            )
         )
         ;Semantics of the body
         (forall ((Itl13 Nat))
            (=>
               (Sub Itl13 nl13)
               (and
                  ;Define value of variable j at beginning of next iteration
                  (= (j (l13 (s Itl13))) 1)
                  ;Define value of variable i at beginning of next iteration
                  (= (i (l13 (s Itl13))) (+ (i (l13 Itl13)) 1))
               )
            )
         )
         ;The loop-condition doesn't hold in the last iteration
         (not
            (< (i (l13 nl13)) alength)
         )
      )
      ;Define referenced terms denoting variable values at main_end
      (= (j main_end) (j (l13 nl13)))
   )
)

; Definition: Dense-increasing for i-l13
(assert
   (=
      Dense-increasing-i-l13
      (forall ((Itl13 Nat))
         (=>
            (Sub Itl13 nl13)
            (or
               (= (i (l13 (s Itl13))) (i (l13 Itl13)))
               (= (i (l13 (s Itl13))) (+ (i (l13 Itl13)) 1))
            )
         )
      )
   )
)

; Axiom: already-proven-lemma i-alength-equality-axiom
(assert
   (=>
      (and
         Dense-increasing-i-l13
         (<= (i (l13 zero)) alength)
      )
      (= (i (l13 nl13)) alength)
   )
)

; Axiom: user-axiom-0
(assert
   (<= 0 alength)
)

; Conjecture: set_to_one-conjecture-0
(assert-not
   (=>
      (< 0 alength)
      (= (j main_end) 1)
   )
)

(check-sat)

