; main()
; {
;    i = 0 @l12
;    while (i < alength) @l13
;    {
;       if (a[i] == 1) @l15
;       {
;          b[i] = 1 @l17
;       }
;       else
;       {
;          b[i] = 0 @l21
;       }
;       i = (i) + (1) @l23
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
(declare-time-point l12 Time)
(declare-time-point l13 (Nat) Time)
(declare-final-loop-count nl13 Nat)
(declare-time-point l15 (Nat) Time)
(declare-time-point l17 (Nat) Time)
(declare-time-point l21 (Nat) Time)
(declare-time-point l23 (Nat) Time)
(declare-time-point main_end Time)
(declare-const t1 Trace)
(declare-lemma-predicate Dense-increasing-i-l13 () Bool)

; Axiom: target symbol definitions for symbol elimination
(assert
   true
)

; Axiom: Semantics of function main
(assert
   (and
      ;Loop at location l13
      (and
         ;Define variable values at beginning of loop
         (= (i (l13 zero)) 0)
         ;The loop-condition holds always before the last iteration
         (forall ((Itl13 Nat))
            (=>
               (Sub Itl13 nl13)
               (< (i (l13 Itl13)) alength)
            )
         )
         ;Semantics of the body
         (forall ((Itl13 Nat))
            (=>
               (Sub Itl13 nl13)
               (and
                  ;Semantics of IfElse at location l15
                  (and
                     ;Semantics of left branch
                     (=>
                        (= (a (i (l13 Itl13))) 1)
                        ;Update array variable b at location l17
                        (and
                           (= (b (l23 Itl13) (i (l13 Itl13))) 1)
                           (forall ((pos Int))
                              (=>
                                 (not
                                    (= pos (i (l13 Itl13)))
                                 )
                                 (= (b (l23 Itl13) pos) (b (l13 Itl13) pos))
                              )
                           )
                        )
                     )
                     ;Semantics of right branch
                     (=>
                        (not
                           (= (a (i (l13 Itl13))) 1)
                        )
                        ;Update array variable b at location l21
                        (and
                           (= (b (l23 Itl13) (i (l13 Itl13))) 0)
                           (forall ((pos Int))
                              (=>
                                 (not
                                    (= pos (i (l13 Itl13)))
                                 )
                                 (= (b (l23 Itl13) pos) (b (l13 Itl13) pos))
                              )
                           )
                        )
                     )
                  )
                  ;Define value of variable i at beginning of next iteration
                  (= (i (l13 (s Itl13))) (+ (i (l13 Itl13)) 1))
                  ;Define value of array variable b at beginning of next iteration
                  (forall ((pos Int))
                     (= (b (l13 (s Itl13)) pos) (b (l23 Itl13) pos))
                  )
               )
            )
         )
         ;The loop-condition doesn't hold in the last iteration
         (not
            (< (i (l13 nl13)) alength)
         )
      )
      ;Define referenced terms denoting variable values at main_end
      (forall ((pos Int))
         (= (b main_end pos) (b (l13 nl13) pos))
      )
   )
)

; Definition: Dense-increasing for i-l13
(assert
   (=
      Dense-increasing-i-l13
      (forall ((Itl13 Nat))
         (=>
            (Sub Itl13 nl13)
            (or
               (= (i (l13 (s Itl13))) (i (l13 Itl13)))
               (= (i (l13 (s Itl13))) (+ (i (l13 Itl13)) 1))
            )
         )
      )
   )
)

; Axiom: already-proven-lemma i-alength-equality-axiom
(assert
   (=>
      (and
         Dense-increasing-i-l13
         (<= (i (l13 zero)) alength)
      )
      (= (i (l13 nl13)) alength)
   )
)

; Axiom: user-axiom-0
(assert
   (<= 0 alength)
)

; Conjecture: both_or_none-conjecture-0
(assert-not
   (forall ((j Int))
      (=>
         (and
            (<= 0 j)
            (< j alength)
            (<= 0 alength)
         )
         (or
            (and
               (= (a j) 1)
               (= (b main_end j) 1)
            )
            (and
               (not
                  (= (a j) 1)
               )
               (= (b main_end j) 0)
            )
         )
      )
   )
)

(check-sat)

