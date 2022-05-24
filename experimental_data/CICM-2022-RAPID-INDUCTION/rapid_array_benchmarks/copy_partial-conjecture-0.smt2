; main()
; {
;    alength = 0 @l4
;    while (alength < k) @l9
;    {
;       a[alength] = b[alength] @l11
;       alength = (alength) + (1) @l12
;    }
; }
; 

(set-logic UFDTLIA)

(declare-nat Nat zero s p Sub)
(declare-sort Time 0)
(declare-sort Trace 0)
(declare-program-var a (Time Int) Int)
(declare-program-var alength (Time) Int)
(declare-fun b (Int) Int)
(declare-const-var blength Int)
(declare-const-var k Int)
(declare-time-point l4 Time)
(declare-time-point l9 (Nat) Time)
(declare-final-loop-count nl9 Nat)
(declare-time-point l11 (Nat) Time)
(declare-time-point l12 (Nat) Time)
(declare-time-point main_end Time)
(declare-const t1 Trace)
(declare-lemma-predicate Dense-increasing-alength-l9 () Bool)

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
         (= (alength (l9 zero)) 0)
         ;The loop-condition holds always before the last iteration
         (forall ((Itl9 Nat))
            (=>
               (Sub Itl9 nl9)
               (< (alength (l9 Itl9)) k)
            )
         )
         ;Semantics of the body
         (forall ((Itl9 Nat))
            (=>
               (Sub Itl9 nl9)
               (and
                  ;Update array variable a at location l11
                  (and
                     (= (a (l12 Itl9) (alength (l9 Itl9))) (b (alength (l9 Itl9))))
                     (forall ((pos Int))
                        (=>
                           (not
                              (= pos (alength (l9 Itl9)))
                           )
                           (= (a (l12 Itl9) pos) (a (l9 Itl9) pos))
                        )
                     )
                  )
                  ;Define value of variable alength at beginning of next iteration
                  (= (alength (l9 (s Itl9))) (+ (alength (l9 Itl9)) 1))
                  ;Define value of array variable a at beginning of next iteration
                  (forall ((pos Int))
                     (= (a (l9 (s Itl9)) pos) (a (l12 Itl9) pos))
                  )
               )
            )
         )
         ;The loop-condition doesn't hold in the last iteration
         (not
            (< (alength (l9 nl9)) k)
         )
      )
      ;Define referenced terms denoting variable values at main_end
      (forall ((pos Int))
         (= (a main_end pos) (a (l9 nl9) pos))
      )
   )
)

; Definition: Dense-increasing for alength-l9
(assert
   (=
      Dense-increasing-alength-l9
      (forall ((Itl9 Nat))
         (=>
            (Sub Itl9 nl9)
            (or
               (= (alength (l9 (s Itl9))) (alength (l9 Itl9)))
               (= (alength (l9 (s Itl9))) (+ (alength (l9 Itl9)) 1))
            )
         )
      )
   )
)

; Axiom: already-proven-lemma alength-k-equality-axiom
(assert
   (=>
      (and
         Dense-increasing-alength-l9
         (<= (alength (l9 zero)) k)
      )
      (= (alength (l9 nl9)) k)
   )
)

; Axiom: user-axiom-0
(assert
   (<= 0 blength)
)

; Conjecture: copy_partial-conjecture-0
(assert-not
   (=>
      (<= k blength)
      (forall ((j Int))
         (=>
            (and
               (<= 0 j)
               (< j k)
            )
            (= (a main_end j) (b j))
         )
      )
   )
)

(check-sat)

