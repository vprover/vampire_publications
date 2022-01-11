; main()
; {
;    i = 0 @l12
;    while (i < alength) @l14
;    {
;       b[i] = (a[i]) + (1) @l16
;       i = (i) + (1) @l17
;    }
; }
; 

(set-logic UFDTLIA)

(declare-nat Nat zero s p Sub)
(declare-sort Time 0)
(declare-sort Trace 0)
(declare-fun a (Int) Int)
(declare-program-var b (Time Int) Int)
(declare-const-var alength Int)
(declare-program-var i (Time) Int)
(declare-time-point l12 Time)
(declare-time-point l14 (Nat) Time)
(declare-final-loop-count nl14 Nat)
(declare-time-point l16 (Nat) Time)
(declare-time-point l17 (Nat) Time)
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
               (and
                  ;Update array variable b at location l16
                  (and
                     (= (b (l17 Itl14) (i (l14 Itl14))) (+ (a (i (l14 Itl14))) 1))
                     (forall ((pos Int))
                        (=>
                           (not
                              (= pos (i (l14 Itl14)))
                           )
                           (= (b (l17 Itl14) pos) (b (l14 Itl14) pos))
                        )
                     )
                  )
                  ;Define value of variable i at beginning of next iteration
                  (= (i (l14 (s Itl14))) (+ (i (l14 Itl14)) 1))
                  ;Define value of array variable b at beginning of next iteration
                  (forall ((pos Int))
                     (= (b (l14 (s Itl14)) pos) (b (l17 Itl14) pos))
                  )
               )
            )
         )
         ;The loop-condition doesn't hold in the last iteration
         (not
            (< (i (l14 nl14)) alength)
         )
      )
      ;Define referenced terms denoting variable values at main_end
      (forall ((pos Int))
         (= (b main_end pos) (b (l14 nl14) pos))
      )
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

; Conjecture: increment_by_one-conjecture-1
(assert-not
   (forall ((pos Int))
      (=>
         (and
            (<= 0 alength)
            (<= 0 pos)
            (< pos alength)
         )
         (= (b main_end pos) (+ (a pos) 1))
      )
   )
)

(check-sat)

