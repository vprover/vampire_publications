; main()
; {
;    blength = 0 @l15
;    i = 0 @l17
;    while (i < alength) @l18
;    {
;       if (a1[i] == a2[i]) @l20
;       {
;          b[blength] = i @l22
;          blength = (blength) + (1) @l23
;       }
;       else
;       {
;          skip @l27
;       }
;       i = (i) + (1) @l29
;    }
; }
; 

(set-logic UFDTLIA)

(declare-nat Nat zero s p Sub)
(declare-sort Time 0)
(declare-sort Trace 0)
(declare-fun a1 (Int) Int)
(declare-fun a2 (Int) Int)
(declare-const-var alength Int)
(declare-program-var b (Time Int) Int)
(declare-program-var blength (Time) Int)
(declare-program-var i (Time) Int)
(declare-time-point l15 Time)
(declare-time-point l17 Time)
(declare-time-point l18 (Nat) Time)
(declare-final-loop-count nl18 Nat)
(declare-time-point l20 (Nat) Time)
(declare-time-point l22 (Nat) Time)
(declare-time-point l23 (Nat) Time)
(declare-time-point l27 (Nat) Time)
(declare-time-point l29 (Nat) Time)
(declare-time-point main_end Time)
(declare-const t1 Trace)
(declare-lemma-predicate Dense-increasing-i-l18 () Bool)

; Axiom: target symbol definitions for symbol elimination
(assert
   true
)

; Axiom: Semantics of function main
(assert
   (and
      ;Loop at location l18
      (and
         ;Define variable values at beginning of loop
         (and
            (= (i (l18 zero)) 0)
            (= (blength (l18 zero)) 0)
         )
         ;The loop-condition holds always before the last iteration
         (forall ((Itl18 Nat))
            (=>
               (Sub Itl18 nl18)
               (< (i (l18 Itl18)) alength)
            )
         )
         ;Semantics of the body
         (forall ((Itl18 Nat))
            (=>
               (Sub Itl18 nl18)
               (and
                  ;Semantics of IfElse at location l20
                  (and
                     ;Semantics of left branch
                     (=>
                        (= (a1 (i (l18 Itl18))) (a2 (i (l18 Itl18))))
                        (and
                           ;Update array variable b at location l22
                           (and
                              (= (b (l23 Itl18) (blength (l18 Itl18))) (i (l18 Itl18)))
                              (forall ((pos Int))
                                 (=>
                                    (not
                                       (= pos (blength (l18 Itl18)))
                                    )
                                    (= (b (l23 Itl18) pos) (b (l18 Itl18) pos))
                                 )
                              )
                           )
                           (forall ((pos Int))
                              (= (b (l29 Itl18) pos) (b (l23 Itl18) pos))
                           )
                           (= (blength (l29 Itl18)) (+ (blength (l18 Itl18)) 1))
                        )
                     )
                     ;Semantics of right branch
                     (=>
                        (not
                           (= (a1 (i (l18 Itl18))) (a2 (i (l18 Itl18))))
                        )
                        (and
                           (forall ((pos Int))
                              (= (b (l29 Itl18) pos) (b (l18 Itl18) pos))
                           )
                           (= (blength (l29 Itl18)) (blength (l18 Itl18)))
                        )
                     )
                  )
                  ;Define value of variable i at beginning of next iteration
                  (= (i (l18 (s Itl18))) (+ (i (l18 Itl18)) 1))
                  ;Define value of array variable b at beginning of next iteration
                  (forall ((pos Int))
                     (= (b (l18 (s Itl18)) pos) (b (l29 Itl18) pos))
                  )
                  ;Define value of variable blength at beginning of next iteration
                  (= (blength (l18 (s Itl18))) (blength (l29 Itl18)))
               )
            )
         )
         ;The loop-condition doesn't hold in the last iteration
         (not
            (< (i (l18 nl18)) alength)
         )
      )
      ;Define referenced terms denoting variable values at main_end
      (and
         (= (blength main_end) (blength (l18 nl18)))
         (forall ((pos Int))
            (= (b main_end pos) (b (l18 nl18) pos))
         )
      )
   )
)

; Definition: Dense-increasing for i-l18
(assert
   (=
      Dense-increasing-i-l18
      (forall ((Itl18 Nat))
         (=>
            (Sub Itl18 nl18)
            (or
               (= (i (l18 (s Itl18))) (i (l18 Itl18)))
               (= (i (l18 (s Itl18))) (+ (i (l18 Itl18)) 1))
            )
         )
      )
   )
)

; Axiom: already-proven-lemma i-alength-equality-axiom
(assert
   (=>
      (and
         Dense-increasing-i-l18
         (<= (i (l18 zero)) alength)
      )
      (= (i (l18 nl18)) alength)
   )
)

; Axiom: user-axiom-0
(assert
   (<= 0 alength)
)

; Conjecture: collect_indices_equal_values-conjecture-2
(assert-not
   (forall ((pos Int))
      (=>
         (and
            (<= 0 pos)
            (< pos alength)
            (= (a1 pos) (a2 pos))
         )
         (exists ((pos2 Int))
            (= (b main_end pos2) pos)
         )
      )
   )
)

(check-sat)

