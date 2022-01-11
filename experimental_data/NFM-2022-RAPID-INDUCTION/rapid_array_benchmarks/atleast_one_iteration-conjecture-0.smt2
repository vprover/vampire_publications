; main()
; {
;    i = 0 @l6
;    j = 0 @l7
;    while (i < alength) @l8
;    {
;       i = (i) + (1) @l10
;       j = 1 @l11
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
(declare-time-point l6 Time)
(declare-time-point l7 Time)
(declare-time-point l8 (Nat) Time)
(declare-final-loop-count nl8 Nat)
(declare-time-point l10 (Nat) Time)
(declare-time-point l11 (Nat) Time)
(declare-time-point main_end Time)
(declare-const t1 Trace)
(declare-lemma-predicate Dense-increasing-i-l8 () Bool)

; Axiom: target symbol definitions for symbol elimination
(assert
   true
)

; Axiom: Semantics of function main
(assert
   (and
      ;Loop at location l8
      (and
         ;Define variable values at beginning of loop
         (and
            (= (j (l8 zero)) 0)
            (= (i (l8 zero)) 0)
         )
         ;The loop-condition holds always before the last iteration
         (forall ((Itl8 Nat))
            (=>
               (Sub Itl8 nl8)
               (< (i (l8 Itl8)) alength)
            )
         )
         ;Semantics of the body
         (forall ((Itl8 Nat))
            (=>
               (Sub Itl8 nl8)
               (and
                  ;Define value of variable j at beginning of next iteration
                  (= (j (l8 (s Itl8))) 1)
                  ;Define value of variable i at beginning of next iteration
                  (= (i (l8 (s Itl8))) (+ (i (l8 Itl8)) 1))
               )
            )
         )
         ;The loop-condition doesn't hold in the last iteration
         (not
            (< (i (l8 nl8)) alength)
         )
      )
      ;Define referenced terms denoting variable values at main_end
      (= (j main_end) (j (l8 nl8)))
   )
)

; Definition: Dense-increasing for i-l8
(assert
   (=
      Dense-increasing-i-l8
      (forall ((Itl8 Nat))
         (=>
            (Sub Itl8 nl8)
            (or
               (= (i (l8 (s Itl8))) (i (l8 Itl8)))
               (= (i (l8 (s Itl8))) (+ (i (l8 Itl8)) 1))
            )
         )
      )
   )
)

; Axiom: already-proven-lemma i-alength-equality-axiom
(assert
   (=>
      (and
         Dense-increasing-i-l8
         (<= (i (l8 zero)) alength)
      )
      (= (i (l8 nl8)) alength)
   )
)

; Axiom: user-axiom-0
(assert
   (<= 0 alength)
)

; Conjecture: atleast_one_iteration-conjecture-0
(assert-not
   (=>
      (= 0 alength)
      (= (j main_end) 0)
   )
)

(check-sat)

