; main()
; {
;    i = 0 @l8
;    m = 0 @l9
;    while (i < alength) @l10
;    {
;       if (a[i] > a[m]) @l12
;       {
;          b[i] = a[i] @l14
;          m = i @l15
;       }
;       else
;       {
;          b[i] = a[m] @l19
;       }
;       i = (i) + (1) @l21
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
(declare-time-point l8 Time)
(declare-time-point l9 Time)
(declare-time-point l10 (Nat) Time)
(declare-final-loop-count nl10 Nat)
(declare-time-point l12 (Nat) Time)
(declare-time-point l14 (Nat) Time)
(declare-time-point l15 (Nat) Time)
(declare-time-point l19 (Nat) Time)
(declare-time-point l21 (Nat) Time)
(declare-time-point main_end Time)
(declare-const t1 Trace)
(declare-lemma-predicate Dense-increasing-i-l10 () Bool)

; Axiom: target symbol definitions for symbol elimination
(assert
   true
)

; Axiom: Semantics of function main
(assert
   (and
      ;Loop at location l10
      (and
         ;Define variable values at beginning of loop
         (and
            (= (i (l10 zero)) 0)
            (= (m (l10 zero)) 0)
         )
         ;The loop-condition holds always before the last iteration
         (forall ((Itl10 Nat))
            (=>
               (Sub Itl10 nl10)
               (< (i (l10 Itl10)) alength)
            )
         )
         ;Semantics of the body
         (forall ((Itl10 Nat))
            (=>
               (Sub Itl10 nl10)
               (and
                  ;Semantics of IfElse at location l12
                  (and
                     ;Semantics of left branch
                     (=>
                        (> (a (i (l10 Itl10))) (a (m (l10 Itl10))))
                        (and
                           ;Update array variable b at location l14
                           (and
                              (= (b (l15 Itl10) (i (l10 Itl10))) (a (i (l10 Itl10))))
                              (forall ((pos Int))
                                 (=>
                                    (not
                                       (= pos (i (l10 Itl10)))
                                    )
                                    (= (b (l15 Itl10) pos) (b (l10 Itl10) pos))
                                 )
                              )
                           )
                           (forall ((pos Int))
                              (= (b (l21 Itl10) pos) (b (l15 Itl10) pos))
                           )
                           (= (m (l21 Itl10)) (i (l10 Itl10)))
                        )
                     )
                     ;Semantics of right branch
                     (=>
                        (not
                           (> (a (i (l10 Itl10))) (a (m (l10 Itl10))))
                        )
                        (and
                           ;Update array variable b at location l19
                           (and
                              (= (b (l21 Itl10) (i (l10 Itl10))) (a (m (l10 Itl10))))
                              (forall ((pos Int))
                                 (=>
                                    (not
                                       (= pos (i (l10 Itl10)))
                                    )
                                    (= (b (l21 Itl10) pos) (b (l10 Itl10) pos))
                                 )
                              )
                           )
                           (= (m (l21 Itl10)) (m (l10 Itl10)))
                        )
                     )
                  )
                  ;Define value of variable i at beginning of next iteration
                  (= (i (l10 (s Itl10))) (+ (i (l10 Itl10)) 1))
                  ;Define value of array variable b at beginning of next iteration
                  (forall ((pos Int))
                     (= (b (l10 (s Itl10)) pos) (b (l21 Itl10) pos))
                  )
                  ;Define value of variable m at beginning of next iteration
                  (= (m (l10 (s Itl10))) (m (l21 Itl10)))
               )
            )
         )
         ;The loop-condition doesn't hold in the last iteration
         (not
            (< (i (l10 nl10)) alength)
         )
      )
      ;Define referenced terms denoting variable values at main_end
      (forall ((pos Int))
         (= (b main_end pos) (b (l10 nl10) pos))
      )
   )
)

; Definition: Dense-increasing for i-l10
(assert
   (=
      Dense-increasing-i-l10
      (forall ((Itl10 Nat))
         (=>
            (Sub Itl10 nl10)
            (or
               (= (i (l10 (s Itl10))) (i (l10 Itl10)))
               (= (i (l10 (s Itl10))) (+ (i (l10 Itl10)) 1))
            )
         )
      )
   )
)

; Axiom: already-proven-lemma i-alength-equality-axiom
(assert
   (=>
      (and
         Dense-increasing-i-l10
         (<= (i (l10 zero)) alength)
      )
      (= (i (l10 nl10)) alength)
   )
)

; Axiom: user-axiom-0
(assert
   (<= 0 alength)
)

; Conjecture: find_max_up_to-conjecture-0
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
         (<= (a j) (b main_end k))
      )
   )
)

(check-sat)

