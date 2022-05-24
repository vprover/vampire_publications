; main()
; {
;    i = 0 @l7
;    m = 0 @l8
;    while (i < alength) @l9
;    {
;       if (a[i] < a[m]) @l11
;       {
;          b[i] = a[i] @l13
;          m = i @l14
;       }
;       else
;       {
;          b[i] = a[m] @l18
;       }
;       i = (i) + (1) @l20
;    }
; }
; 

(set-logic UFDTLIA)

(declare-nat Nat zero s p Sub)
(declare-sort Time 0)
(declare-sort Trace 0)
(declare-fun a (Int) Int)
(declare-const-var alength Int)
(declare-program-var b (Time Int) Int)
(declare-program-var i (Time) Int)
(declare-program-var m (Time) Int)
(declare-time-point l7 Time)
(declare-time-point l8 Time)
(declare-time-point l9 (Nat) Time)
(declare-final-loop-count nl9 Nat)
(declare-time-point l11 (Nat) Time)
(declare-time-point l13 (Nat) Time)
(declare-time-point l14 (Nat) Time)
(declare-time-point l18 (Nat) Time)
(declare-time-point l20 (Nat) Time)
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
            (= (m (l9 zero)) 0)
         )
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
                  ;Semantics of IfElse at location l11
                  (and
                     ;Semantics of left branch
                     (=>
                        (< (a (i (l9 Itl9))) (a (m (l9 Itl9))))
                        (and
                           ;Update array variable b at location l13
                           (and
                              (= (b (l14 Itl9) (i (l9 Itl9))) (a (i (l9 Itl9))))
                              (forall ((pos Int))
                                 (=>
                                    (not
                                       (= pos (i (l9 Itl9)))
                                    )
                                    (= (b (l14 Itl9) pos) (b (l9 Itl9) pos))
                                 )
                              )
                           )
                           (forall ((pos Int))
                              (= (b (l20 Itl9) pos) (b (l14 Itl9) pos))
                           )
                           (= (m (l20 Itl9)) (i (l9 Itl9)))
                        )
                     )
                     ;Semantics of right branch
                     (=>
                        (not
                           (< (a (i (l9 Itl9))) (a (m (l9 Itl9))))
                        )
                        (and
                           ;Update array variable b at location l18
                           (and
                              (= (b (l20 Itl9) (i (l9 Itl9))) (a (m (l9 Itl9))))
                              (forall ((pos Int))
                                 (=>
                                    (not
                                       (= pos (i (l9 Itl9)))
                                    )
                                    (= (b (l20 Itl9) pos) (b (l9 Itl9) pos))
                                 )
                              )
                           )
                           (= (m (l20 Itl9)) (m (l9 Itl9)))
                        )
                     )
                  )
                  ;Define value of variable i at beginning of next iteration
                  (= (i (l9 (s Itl9))) (+ (i (l9 Itl9)) 1))
                  ;Define value of array variable b at beginning of next iteration
                  (forall ((pos Int))
                     (= (b (l9 (s Itl9)) pos) (b (l20 Itl9) pos))
                  )
                  ;Define value of variable m at beginning of next iteration
                  (= (m (l9 (s Itl9))) (m (l20 Itl9)))
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
         (= (b main_end pos) (b (l9 nl9) pos))
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

; Conjecture: find_min_up_to-conjecture-0
(assert-not
   (forall ((j Int)(k Int))
      (=>
         (and
            (<= 0 alength)
            (<= 0 j)
            (<= 0 k)
            (<= j k)
            (< k alength)
         )
         (<= (b main_end k) (a j))
      )
   )
)

(check-sat)

