; main()
; {
;    i = 0 @l8
;    while (i < alength) @l9
;    {
;       c[(i) * (2)] = a[i] @l11
;       c[((i) * (2)) + (1)] = b[i] @l12
;       i = (i) + (1) @l13
;    }
; }
; 

(set-logic UFDTLIA)

(declare-nat Nat zero s p Sub)
(declare-sort Time 0)
(declare-sort Trace 0)
(declare-fun a (Int) Int)
(declare-fun b (Int) Int)
(declare-program-var c (Time Int) Int)
(declare-const-var alength Int)
(declare-program-var i (Time) Int)
(declare-time-point l8 Time)
(declare-time-point l9 (Nat) Time)
(declare-final-loop-count nl9 Nat)
(declare-time-point l11 (Nat) Time)
(declare-time-point l12 (Nat) Time)
(declare-time-point l13 (Nat) Time)
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
               (< (i (l9 Itl9)) alength)
            )
         )
         ;Semantics of the body
         (forall ((Itl9 Nat))
            (=>
               (Sub Itl9 nl9)
               (and
                  ;Update array variable c at location l11
                  (and
                     (= (c (l12 Itl9) (* (i (l9 Itl9)) 2)) (a (i (l9 Itl9))))
                     (forall ((pos Int))
                        (=>
                           (not
                              (= pos (* (i (l9 Itl9)) 2))
                           )
                           (= (c (l12 Itl9) pos) (c (l9 Itl9) pos))
                        )
                     )
                  )
                  ;Update array variable c at location l12
                  (and
                     (= (c (l13 Itl9) (+ (* (i (l9 Itl9)) 2) 1)) (b (i (l9 Itl9))))
                     (forall ((pos Int))
                        (=>
                           (not
                              (= pos (+ (* (i (l9 Itl9)) 2) 1))
                           )
                           (= (c (l13 Itl9) pos) (c (l12 Itl9) pos))
                        )
                     )
                  )
                  ;Define value of variable i at beginning of next iteration
                  (= (i (l9 (s Itl9))) (+ (i (l9 Itl9)) 1))
                  ;Define value of array variable c at beginning of next iteration
                  (forall ((pos Int))
                     (= (c (l9 (s Itl9)) pos) (c (l13 Itl9) pos))
                  )
               )
            )
         )
         ;The loop-condition doesn't hold in the last iteration
         (not
            (< (i (l9 nl9)) alength)
         )
      )
      ;Define referenced terms denoting variable values at main_end
      (forall ((pos Int))
         (= (c main_end pos) (c (l9 nl9) pos))
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

; Axiom: already-proven-lemma i-alength-equality-axiom
(assert
   (=>
      (and
         Dense-increasing-i-l9
         (<= (i (l9 zero)) alength)
      )
      (= (i (l9 nl9)) alength)
   )
)

; Axiom: user-axiom-0
(assert
   (<= 0 alength)
)

; Conjecture: merge_interleave-conjecture-2
(assert-not
   (forall ((pos Int))
      (exists ((j Int))
         (=>
            (and
               (<= 0 alength)
               (<= 0 pos)
               (< pos (* alength 2))
            )
            (or
               (= (c main_end pos) (a j))
               (= (c main_end pos) (b j))
            )
         )
      )
   )
)

(check-sat)

