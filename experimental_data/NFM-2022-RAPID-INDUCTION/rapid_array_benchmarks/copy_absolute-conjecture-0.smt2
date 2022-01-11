; main()
; {
;    i = 0 @l8
;    while (i < blength) @l9
;    {
;       if (b[i] >= 0) @l11
;       {
;          a[i] = b[i] @l13
;       }
;       else
;       {
;          a[i] = (0) - (b[i]) @l17
;       }
;       i = (i) + (1) @l19
;    }
; }
; 

(set-logic UFDTLIA)

(declare-nat Nat zero s p Sub)
(declare-sort Time 0)
(declare-sort Trace 0)
(declare-program-var a (Time Int) Int)
(declare-fun b (Int) Int)
(declare-const-var blength Int)
(declare-program-var i (Time) Int)
(declare-time-point l8 Time)
(declare-time-point l9 (Nat) Time)
(declare-final-loop-count nl9 Nat)
(declare-time-point l11 (Nat) Time)
(declare-time-point l13 (Nat) Time)
(declare-time-point l17 (Nat) Time)
(declare-time-point l19 (Nat) Time)
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
                  ;Semantics of IfElse at location l11
                  (and
                     ;Semantics of left branch
                     (=>
                        (>= (b (i (l9 Itl9))) 0)
                        ;Update array variable a at location l13
                        (and
                           (= (a (l19 Itl9) (i (l9 Itl9))) (b (i (l9 Itl9))))
                           (forall ((pos Int))
                              (=>
                                 (not
                                    (= pos (i (l9 Itl9)))
                                 )
                                 (= (a (l19 Itl9) pos) (a (l9 Itl9) pos))
                              )
                           )
                        )
                     )
                     ;Semantics of right branch
                     (=>
                        (not
                           (>= (b (i (l9 Itl9))) 0)
                        )
                        ;Update array variable a at location l17
                        (and
                           (= (a (l19 Itl9) (i (l9 Itl9))) (- 0 (b (i (l9 Itl9)))))
                           (forall ((pos Int))
                              (=>
                                 (not
                                    (= pos (i (l9 Itl9)))
                                 )
                                 (= (a (l19 Itl9) pos) (a (l9 Itl9) pos))
                              )
                           )
                        )
                     )
                  )
                  ;Define value of variable i at beginning of next iteration
                  (= (i (l9 (s Itl9))) (+ (i (l9 Itl9)) 1))
                  ;Define value of array variable a at beginning of next iteration
                  (forall ((pos Int))
                     (= (a (l9 (s Itl9)) pos) (a (l19 Itl9) pos))
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

; Conjecture: copy_absolute-conjecture-0
(assert-not
   (forall ((k Int))
      (=>
         (and
            (<= 0 k)
            (< k blength)
            (<= 0 blength)
         )
         (or
            (= (a main_end k) (b k))
            (= (a main_end k) (- 0 (b k)))
         )
      )
   )
)

(check-sat)

