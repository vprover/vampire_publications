; main()
; {
;    i = 1 @l6
;    while (i <= alength) @l8
;    {
;       if (a[((2) * (i)) - (2)] > ((2) * (i)) - (2)) @l9
;       {
;          a[((2) * (i)) - (2)] = ((2) * (i)) - (2) @l10
;       }
;       else
;       {
;          skip @l12
;       }
;       if (a[((2) * (i)) - (1)] > ((2) * (i)) - (1)) @l14
;       {
;          a[((2) * (i)) - (1)] = ((2) * (i)) - (1) @l15
;       }
;       else
;       {
;          skip @l17
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
(declare-const-var alength Int)
(declare-program-var i (Time) Int)
(declare-time-point l6 Time)
(declare-time-point l8 (Nat) Time)
(declare-final-loop-count nl8 Nat)
(declare-time-point l9 (Nat) Time)
(declare-time-point l10 (Nat) Time)
(declare-time-point l12 (Nat) Time)
(declare-time-point l14 (Nat) Time)
(declare-time-point l15 (Nat) Time)
(declare-time-point l17 (Nat) Time)
(declare-time-point l19 (Nat) Time)
(declare-time-point main_end Time)
(declare-const t1 Trace)
(declare-lemma-predicate Dense-increasing-i-l8 () Bool)

; Axiom: target symbol definitions for symbol elimination
(assert
   true
)

; Axiom: Semantics of function main
(assert
   (and
      ;Loop at location l8
      (and
         ;Define variable values at beginning of loop
         (= (i (l8 zero)) 1)
         ;The loop-condition holds always before the last iteration
         (forall ((Itl8 Nat))
            (=>
               (Sub Itl8 nl8)
               (<= (i (l8 Itl8)) alength)
            )
         )
         ;Semantics of the body
         (forall ((Itl8 Nat))
            (=>
               (Sub Itl8 nl8)
               (and
                  ;Semantics of IfElse at location l9
                  (and
                     ;Semantics of left branch
                     (=>
                        (> (a (l8 Itl8) (- (* 2 (i (l8 Itl8))) 2)) (- (* 2 (i (l8 Itl8))) 2))
                        ;Update array variable a at location l10
                        (and
                           (= (a (l14 Itl8) (- (* 2 (i (l8 Itl8))) 2)) (- (* 2 (i (l8 Itl8))) 2))
                           (forall ((pos Int))
                              (=>
                                 (not
                                    (= pos (- (* 2 (i (l8 Itl8))) 2))
                                 )
                                 (= (a (l14 Itl8) pos) (a (l8 Itl8) pos))
                              )
                           )
                        )
                     )
                     ;Semantics of right branch
                     (=>
                        (not
                           (> (a (l8 Itl8) (- (* 2 (i (l8 Itl8))) 2)) (- (* 2 (i (l8 Itl8))) 2))
                        )
                        (forall ((pos Int))
                           (= (a (l14 Itl8) pos) (a (l8 Itl8) pos))
                        )
                     )
                  )
                  ;Semantics of IfElse at location l14
                  (and
                     ;Semantics of left branch
                     (=>
                        (> (a (l14 Itl8) (- (* 2 (i (l8 Itl8))) 1)) (- (* 2 (i (l8 Itl8))) 1))
                        ;Update array variable a at location l15
                        (and
                           (= (a (l19 Itl8) (- (* 2 (i (l8 Itl8))) 1)) (- (* 2 (i (l8 Itl8))) 1))
                           (forall ((pos Int))
                              (=>
                                 (not
                                    (= pos (- (* 2 (i (l8 Itl8))) 1))
                                 )
                                 (= (a (l19 Itl8) pos) (a (l14 Itl8) pos))
                              )
                           )
                        )
                     )
                     ;Semantics of right branch
                     (=>
                        (not
                           (> (a (l14 Itl8) (- (* 2 (i (l8 Itl8))) 1)) (- (* 2 (i (l8 Itl8))) 1))
                        )
                        (forall ((pos Int))
                           (= (a (l19 Itl8) pos) (a (l14 Itl8) pos))
                        )
                     )
                  )
                  ;Define value of variable i at beginning of next iteration
                  (= (i (l8 (s Itl8))) (+ (i (l8 Itl8)) 1))
                  ;Define value of array variable a at beginning of next iteration
                  (forall ((pos Int))
                     (= (a (l8 (s Itl8)) pos) (a (l19 Itl8) pos))
                  )
               )
            )
         )
         ;The loop-condition doesn't hold in the last iteration
         (not
            (<= (i (l8 nl8)) alength)
         )
      )
      ;Define referenced terms denoting variable values at main_end
      (forall ((pos Int))
         (= (a main_end pos) (a (l8 nl8) pos))
      )
   )
)

; Definition: Dense-increasing for i-l8
(assert
   (=
      Dense-increasing-i-l8
      (forall ((Itl8 Nat))
         (=>
            (Sub Itl8 nl8)
            (or
               (= (i (l8 (s Itl8))) (i (l8 Itl8)))
               (= (i (l8 (s Itl8))) (+ (i (l8 Itl8)) 1))
            )
         )
      )
   )
)

; Axiom: already-proven-lemma i-alength-equality-axiom
(assert
   (=>
      (and
         Dense-increasing-i-l8
         (<= (i (l8 zero)) (+ alength 1))
      )
      (= (i (l8 nl8)) alength)
   )
)

; Conjecture: user-conjecture-0
(assert-not
   (forall ((pos Int))
      (=>
         (and
            (>= alength 0)
            (<= 0 pos)
            (< pos alength)
         )
         (<= (a main_end pos) pos)
      )
   )
)

(check-sat)

