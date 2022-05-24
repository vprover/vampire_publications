; main()
; {
;    blength = 0 @l13
;    clength = 0 @l15
;    i = 0 @l16
;    while (i < alength) @l17
;    {
;       if (a[i] >= 0) @l19
;       {
;          b[blength] = a[i] @l21
;          blength = (blength) + (1) @l22
;       }
;       else
;       {
;          c[clength] = a[i] @l26
;          clength = (clength) + (1) @l27
;       }
;       i = (i) + (1) @l29
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
(declare-program-var blength (Time) Int)
(declare-program-var c (Time Int) Int)
(declare-program-var clength (Time) Int)
(declare-program-var i (Time) Int)
(declare-time-point l13 Time)
(declare-time-point l15 Time)
(declare-time-point l16 Time)
(declare-time-point l17 (Nat) Time)
(declare-final-loop-count nl17 Nat)
(declare-time-point l19 (Nat) Time)
(declare-time-point l21 (Nat) Time)
(declare-time-point l22 (Nat) Time)
(declare-time-point l26 (Nat) Time)
(declare-time-point l27 (Nat) Time)
(declare-time-point l29 (Nat) Time)
(declare-time-point main_end Time)
(declare-const t1 Trace)
(declare-lemma-predicate Dense-increasing-i-l17 () Bool)

; Axiom: target symbol definitions for symbol elimination
(assert
   true
)

; Axiom: Semantics of function main
(assert
   (and
      ;Loop at location l17
      (and
         ;Define variable values at beginning of loop
         (and
            (= (i (l17 zero)) 0)
            (= (blength (l17 zero)) 0)
            (= (clength (l17 zero)) 0)
         )
         ;The loop-condition holds always before the last iteration
         (forall ((Itl17 Nat))
            (=>
               (Sub Itl17 nl17)
               (< (i (l17 Itl17)) alength)
            )
         )
         ;Semantics of the body
         (forall ((Itl17 Nat))
            (=>
               (Sub Itl17 nl17)
               (and
                  ;Semantics of IfElse at location l19
                  (and
                     ;Semantics of left branch
                     (=>
                        (>= (a (i (l17 Itl17))) 0)
                        (and
                           ;Update array variable b at location l21
                           (and
                              (= (b (l22 Itl17) (blength (l17 Itl17))) (a (i (l17 Itl17))))
                              (forall ((pos Int))
                                 (=>
                                    (not
                                       (= pos (blength (l17 Itl17)))
                                    )
                                    (= (b (l22 Itl17) pos) (b (l17 Itl17) pos))
                                 )
                              )
                           )
                           (forall ((pos Int))
                              (= (c (l29 Itl17) pos) (c (l17 Itl17) pos))
                           )
                           (forall ((pos Int))
                              (= (b (l29 Itl17) pos) (b (l22 Itl17) pos))
                           )
                           (= (clength (l29 Itl17)) (clength (l17 Itl17)))
                           (= (blength (l29 Itl17)) (+ (blength (l17 Itl17)) 1))
                        )
                     )
                     ;Semantics of right branch
                     (=>
                        (not
                           (>= (a (i (l17 Itl17))) 0)
                        )
                        (and
                           ;Update array variable c at location l26
                           (and
                              (= (c (l27 Itl17) (clength (l17 Itl17))) (a (i (l17 Itl17))))
                              (forall ((pos Int))
                                 (=>
                                    (not
                                       (= pos (clength (l17 Itl17)))
                                    )
                                    (= (c (l27 Itl17) pos) (c (l17 Itl17) pos))
                                 )
                              )
                           )
                           (forall ((pos Int))
                              (= (c (l29 Itl17) pos) (c (l27 Itl17) pos))
                           )
                           (forall ((pos Int))
                              (= (b (l29 Itl17) pos) (b (l17 Itl17) pos))
                           )
                           (= (clength (l29 Itl17)) (+ (clength (l17 Itl17)) 1))
                           (= (blength (l29 Itl17)) (blength (l17 Itl17)))
                        )
                     )
                  )
                  ;Define value of variable i at beginning of next iteration
                  (= (i (l17 (s Itl17))) (+ (i (l17 Itl17)) 1))
                  ;Define value of array variable b at beginning of next iteration
                  (forall ((pos Int))
                     (= (b (l17 (s Itl17)) pos) (b (l29 Itl17) pos))
                  )
                  ;Define value of variable blength at beginning of next iteration
                  (= (blength (l17 (s Itl17))) (blength (l29 Itl17)))
                  ;Define value of array variable c at beginning of next iteration
                  (forall ((pos Int))
                     (= (c (l17 (s Itl17)) pos) (c (l29 Itl17) pos))
                  )
                  ;Define value of variable clength at beginning of next iteration
                  (= (clength (l17 (s Itl17))) (clength (l29 Itl17)))
               )
            )
         )
         ;The loop-condition doesn't hold in the last iteration
         (not
            (< (i (l17 nl17)) alength)
         )
      )
      ;Define referenced terms denoting variable values at main_end
      (and
         (= (clength main_end) (clength (l17 nl17)))
         (= (blength main_end) (blength (l17 nl17)))
         (forall ((pos Int))
            (= (c main_end pos) (c (l17 nl17) pos))
         )
         (forall ((pos Int))
            (= (b main_end pos) (b (l17 nl17) pos))
         )
      )
   )
)

; Definition: Dense-increasing for i-l17
(assert
   (=
      Dense-increasing-i-l17
      (forall ((Itl17 Nat))
         (=>
            (Sub Itl17 nl17)
            (or
               (= (i (l17 (s Itl17))) (i (l17 Itl17)))
               (= (i (l17 (s Itl17))) (+ (i (l17 Itl17)) 1))
            )
         )
      )
   )
)

; Axiom: already-proven-lemma i-alength-equality-axiom
(assert
   (=>
      (and
         Dense-increasing-i-l17
         (<= (i (l17 zero)) alength)
      )
      (= (i (l17 nl17)) alength)
   )
)

; Axiom: user-axiom-0
(assert
   (<= 0 alength)
)

; Conjecture: partition-harder-conjecture-2
(assert-not
   (forall ((pos Int))
      (=>
         (and
            (<= 0 pos)
            (< pos alength)
            (<= 0 (a pos))
         )
         (exists ((pos2 Int))
            (and
               (<= 0 pos2)
               (< pos2 (blength main_end))
               (= (b main_end pos2) (a pos))
            )
         )
      )
   )
)

(check-sat)

