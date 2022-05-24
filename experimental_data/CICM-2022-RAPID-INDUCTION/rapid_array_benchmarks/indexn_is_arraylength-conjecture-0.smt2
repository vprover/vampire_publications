; main()
; {
;    i = 0 @l12
;    while (i < alength) @l14
;    {
;       i = (i) + (1) @l16
;    }
; }
; 

(set-logic UFDTLIA)

(declare-nat Nat zero s p Sub)
(declare-sort Time 0)
(declare-sort Trace 0)
(declare-const-var alength Int)
(declare-program-var i (Time) Int)
(declare-time-point l12 Time)
(declare-time-point l14 (Nat) Time)
(declare-final-loop-count nl14 Nat)
(declare-time-point l16 (Nat) Time)
(declare-time-point main_end Time)
(declare-const t1 Trace)
(declare-lemma-predicate Dense-increasing-i-l14 () Bool)

; Axiom: target symbol definitions for symbol elimination
(assert
   true
)

; Axiom: Semantics of function main
(assert
   (and
      ;Loop at location l14
      (and
         ;Define variable values at beginning of loop
         (= (i (l14 zero)) 0)
         ;The loop-condition holds always before the last iteration
         (forall ((Itl14 Nat))
            (=>
               (Sub Itl14 nl14)
               (< (i (l14 Itl14)) alength)
            )
         )
         ;Semantics of the body
         (forall ((Itl14 Nat))
            (=>
               (Sub Itl14 nl14)
               ;Define value of variable i at beginning of next iteration
               (= (i (l14 (s Itl14))) (+ (i (l14 Itl14)) 1))
            )
         )
         ;The loop-condition doesn't hold in the last iteration
         (not
            (< (i (l14 nl14)) alength)
         )
      )
      ;Define referenced terms denoting variable values at main_end
      (= (i main_end) (i (l14 nl14)))
   )
)

; Definition: Dense-increasing for i-l14
(assert
   (=
      Dense-increasing-i-l14
      (forall ((Itl14 Nat))
         (=>
            (Sub Itl14 nl14)
            (or
               (= (i (l14 (s Itl14))) (i (l14 Itl14)))
               (= (i (l14 (s Itl14))) (+ (i (l14 Itl14)) 1))
            )
         )
      )
   )
)

; Axiom: already-proven-lemma i-alength-equality-axiom
(assert
   (=>
      (and
         Dense-increasing-i-l14
         (<= (i (l14 zero)) alength)
      )
      (= (i (l14 nl14)) alength)
   )
)

; Axiom: user-axiom-0
(assert
   (<= 0 alength)
)

; Conjecture: indexn_is_arraylength-conjecture-0
(assert-not
   (not
      (< (i main_end) alength)
   )
)

(check-sat)

