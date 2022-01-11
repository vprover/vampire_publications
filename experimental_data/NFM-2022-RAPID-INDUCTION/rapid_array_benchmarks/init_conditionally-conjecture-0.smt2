; main()
; {
;    i = 0 @l7
;    clength = 0 @l8
;    while (i < length) @l9
;    {
;       if (a[i] == b[i]) @l11
;       {
;          c[clength] = i @l13
;          clength = (clength) + (1) @l14
;       }
;       else
;       {
;          skip @l18
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
(declare-fun b (Int) Int)
(declare-program-var c (Time Int) Int)
(declare-const-var length Int)
(declare-program-var i (Time) Int)
(declare-program-var clength (Time) Int)
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
            (= (clength (l9 zero)) 0)
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
                  ;Semantics of IfElse at location l11
                  (and
                     ;Semantics of left branch
                     (=>
                        (= (a (i (l9 Itl9))) (b (i (l9 Itl9))))
                        (and
                           ;Update array variable c at location l13
                           (and
                              (= (c (l14 Itl9) (clength (l9 Itl9))) (i (l9 Itl9)))
                              (forall ((pos Int))
                                 (=>
                                    (not
                                       (= pos (clength (l9 Itl9)))
                                    )
                                    (= (c (l14 Itl9) pos) (c (l9 Itl9) pos))
                                 )
                              )
                           )
                           (forall ((pos Int))
                              (= (c (l20 Itl9) pos) (c (l14 Itl9) pos))
                           )
                           (= (clength (l20 Itl9)) (+ (clength (l9 Itl9)) 1))
                        )
                     )
                     ;Semantics of right branch
                     (=>
                        (not
                           (= (a (i (l9 Itl9))) (b (i (l9 Itl9))))
                        )
                        (and
                           (forall ((pos Int))
                              (= (c (l20 Itl9) pos) (c (l9 Itl9) pos))
                           )
                           (= (clength (l20 Itl9)) (clength (l9 Itl9)))
                        )
                     )
                  )
                  ;Define value of variable i at beginning of next iteration
                  (= (i (l9 (s Itl9))) (+ (i (l9 Itl9)) 1))
                  ;Define value of array variable c at beginning of next iteration
                  (forall ((pos Int))
                     (= (c (l9 (s Itl9)) pos) (c (l20 Itl9) pos))
                  )
                  ;Define value of variable clength at beginning of next iteration
                  (= (clength (l9 (s Itl9))) (clength (l20 Itl9)))
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
         (= (clength main_end) (clength (l9 nl9)))
         (forall ((pos Int))
            (= (c main_end pos) (c (l9 nl9) pos))
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

; Conjecture: init_conditionally-conjecture-0
(assert-not
   (forall ((pos Int))
      (=>
         (and
            (<= 0 pos)
            (< pos (clength main_end))
            (<= 0 length)
         )
         (= (a (c main_end pos)) (b (c main_end pos)))
      )
   )
)

(check-sat)

