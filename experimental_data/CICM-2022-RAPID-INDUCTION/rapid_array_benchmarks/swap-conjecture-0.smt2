; main()
; {
;    i = 0 @l8
;    while (i < length) @l9
;    {
;       current = a[i] @l11
;       a[i] = b[i] @l12
;       b[i] = current @l13
;       i = (i) + (1) @l14
;    }
; }
; 

(set-logic UFDTLIA)

(declare-nat Nat zero s p Sub)
(declare-sort Time 0)
(declare-sort Trace 0)
(declare-program-var a (Time Int) Int)
(declare-program-var b (Time Int) Int)
(declare-const-var length Int)
(declare-program-var i (Time) Int)
(declare-program-var current (Time) Int)
(declare-time-point l8 Time)
(declare-time-point l9 (Nat) Time)
(declare-final-loop-count nl9 Nat)
(declare-time-point l11 (Nat) Time)
(declare-time-point l12 (Nat) Time)
(declare-time-point l13 (Nat) Time)
(declare-time-point l14 (Nat) Time)
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
         (and
            (= (i (l9 zero)) 0)
            (forall ((pos Int))
               (= (b (l9 zero) pos) (b l8 pos))
            )
            (forall ((pos Int))
               (= (a (l9 zero) pos) (a l8 pos))
            )
         )
         ;The loop-condition holds always before the last iteration
         (forall ((Itl9 Nat))
            (=>
               (Sub Itl9 nl9)
               (< (i (l9 Itl9)) length)
            )
         )
         ;Semantics of the body
         (forall ((Itl9 Nat))
            (=>
               (Sub Itl9 nl9)
               (and
                  ;Update array variable a at location l12
                  (and
                     (= (a (l13 Itl9) (i (l9 Itl9))) (b (l9 Itl9) (i (l9 Itl9))))
                     (forall ((pos Int))
                        (=>
                           (not
                              (= pos (i (l9 Itl9)))
                           )
                           (= (a (l13 Itl9) pos) (a (l9 Itl9) pos))
                        )
                     )
                  )
                  ;Update array variable b at location l13
                  (and
                     (= (b (l14 Itl9) (i (l9 Itl9))) (a (l9 Itl9) (i (l9 Itl9))))
                     (forall ((pos Int))
                        (=>
                           (not
                              (= pos (i (l9 Itl9)))
                           )
                           (= (b (l14 Itl9) pos) (b (l9 Itl9) pos))
                        )
                     )
                  )
                  ;Define value of variable i at beginning of next iteration
                  (= (i (l9 (s Itl9))) (+ (i (l9 Itl9)) 1))
                  ;Define value of array variable b at beginning of next iteration
                  (forall ((pos Int))
                     (= (b (l9 (s Itl9)) pos) (b (l14 Itl9) pos))
                  )
                  ;Define value of array variable a at beginning of next iteration
                  (forall ((pos Int))
                     (= (a (l9 (s Itl9)) pos) (a (l13 Itl9) pos))
                  )
                  ;Define value of variable current at beginning of next iteration
                  (= (current (l9 (s Itl9))) (a (l9 Itl9) (i (l9 Itl9))))
               )
            )
         )
         ;The loop-condition doesn't hold in the last iteration
         (not
            (< (i (l9 nl9)) length)
         )
      )
      ;Define referenced terms denoting variable values at main_end
      (and
         (forall ((pos Int))
            (= (b main_end pos) (b (l9 nl9) pos))
         )
         (forall ((pos Int))
            (= (a main_end pos) (a (l9 nl9) pos))
         )
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

; Axiom: already-proven-lemma i-length-equality-axiom
(assert
   (=>
      (and
         Dense-increasing-i-l9
         (<= (i (l9 zero)) length)
      )
      (= (i (l9 nl9)) length)
   )
)

; Axiom: user-axiom-0
(assert
   (<= 0 length)
)

; Conjecture: swap-conjecture-0
(assert-not
   (forall ((pos Int))
      (=>
         (and
            (<= 0 length)
            (<= 0 pos)
            (< pos length)
         )
         (= (a main_end pos) (b l8 pos))
      )
   )
)

(check-sat)

