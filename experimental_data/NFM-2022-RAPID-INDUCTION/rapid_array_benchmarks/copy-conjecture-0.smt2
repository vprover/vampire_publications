; main()
; {
;    i = 0 @l7
;    while (i < blength) @l9
;    {
;       a[i] = b[i] @l11
;       i = (i) + (1) @l12
;    }
; }
; 

(set-logic UFDTLIA)

(declare-nat Nat zero s p Sub)
(declare-sort Time 0)
(declare-sort Trace 0)
(declare-fun b (Int) Int)
(declare-const-var blength Int)
(declare-program-var a (Time Int) Int)
(declare-program-var i (Time) Int)
(declare-time-point l7 Time)
(declare-time-point l9 (Nat) Time)
(declare-final-loop-count nl9 Nat)
(declare-time-point l11 (Nat) Time)
(declare-time-point l12 (Nat) Time)
(declare-time-point main_end Time)
(declare-const t1 Trace)
(declare-lemma-predicate Dense-increasing-i-l9 () Bool)

; Axiom: target symbol definitions for symbol elimination
(assert
   true
)

; Axiom: Semantics of function main
(assert
   (and
      ;Loop at location l9
      (and
         ;Define variable values at beginning of loop
         (= (i (l9 zero)) 0)
         ;The loop-condition holds always before the last iteration
         (forall ((Itl9 Nat))
            (=>
               (Sub Itl9 nl9)
               (< (i (l9 Itl9)) blength)
            )
         )
         ;Semantics of the body
         (forall ((Itl9 Nat))
            (=>
               (Sub Itl9 nl9)
               (and
                  ;Update array variable a at location l11
                  (and
                     (= (a (l12 Itl9) (i (l9 Itl9))) (b (i (l9 Itl9))))
                     (forall ((pos Int))
                        (=>
                           (not
                              (= pos (i (l9 Itl9)))
                           )
                           (= (a (l12 Itl9) pos) (a (l9 Itl9) pos))
                        )
                     )
                  )
                  ;Define value of variable i at beginning of next iteration
                  (= (i (l9 (s Itl9))) (+ (i (l9 Itl9)) 1))
                  ;Define value of array variable a at beginning of next iteration
                  (forall ((pos Int))
                     (= (a (l9 (s Itl9)) pos) (a (l12 Itl9) pos))
                  )
               )
            )
         )
         ;The loop-condition doesn't hold in the last iteration
         (not
            (< (i (l9 nl9)) blength)
         )
      )
      ;Define referenced terms denoting variable values at main_end
      (forall ((pos Int))
         (= (a main_end pos) (a (l9 nl9) pos))
      )
   )
)

; Definition: Dense-increasing for i-l9
(assert
   (=
      Dense-increasing-i-l9
      (forall ((Itl9 Nat))
         (=>
            (Sub Itl9 nl9)
            (or
               (= (i (l9 (s Itl9))) (i (l9 Itl9)))
               (= (i (l9 (s Itl9))) (+ (i (l9 Itl9)) 1))
            )
         )
      )
   )
)

; Axiom: already-proven-lemma i-blength-equality-axiom
(assert
   (=>
      (and
         Dense-increasing-i-l9
         (<= (i (l9 zero)) blength)
      )
      (= (i (l9 nl9)) blength)
   )
)

; Axiom: user-axiom-0
(assert
   (<= 0 blength)
)

; Conjecture: copy-conjecture-0
(assert-not
   (forall ((j Int))
      (=>
         (and
            (<= 0 blength)
            (<= 0 j)
            (< j blength)
         )
         (= (a main_end j) (b j))
      )
   )
)

(check-sat)

