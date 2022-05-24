; main()
; {
;    i = 0 @l8
;    alength = 0 @l9
;    while (i < blength) @l10
;    {
;       if (!(b[i] == 0)) @l12
;       {
;          a[alength] = b[i] @l14
;          alength = (alength) + (1) @l15
;       }
;       else
;       {
;          skip @l19
;       }
;       i = (i) + (1) @l21
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
(declare-program-var alength (Time) Int)
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
            (= (alength (l10 zero)) 0)
         )
         ;The loop-condition holds always before the last iteration
         (forall ((Itl10 Nat))
            (=>
               (Sub Itl10 nl10)
               (< (i (l10 Itl10)) blength)
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
                        (not
                           (= (b (i (l10 Itl10))) 0)
                        )
                        (and
                           ;Update array variable a at location l14
                           (and
                              (= (a (l15 Itl10) (alength (l10 Itl10))) (b (i (l10 Itl10))))
                              (forall ((pos Int))
                                 (=>
                                    (not
                                       (= pos (alength (l10 Itl10)))
                                    )
                                    (= (a (l15 Itl10) pos) (a (l10 Itl10) pos))
                                 )
                              )
                           )
                           (forall ((pos Int))
                              (= (a (l21 Itl10) pos) (a (l15 Itl10) pos))
                           )
                           (= (alength (l21 Itl10)) (+ (alength (l10 Itl10)) 1))
                        )
                     )
                     ;Semantics of right branch
                     (=>
                        (not
                           (not
                              (= (b (i (l10 Itl10))) 0)
                           )
                        )
                        (and
                           (forall ((pos Int))
                              (= (a (l21 Itl10) pos) (a (l10 Itl10) pos))
                           )
                           (= (alength (l21 Itl10)) (alength (l10 Itl10)))
                        )
                     )
                  )
                  ;Define value of variable i at beginning of next iteration
                  (= (i (l10 (s Itl10))) (+ (i (l10 Itl10)) 1))
                  ;Define value of array variable a at beginning of next iteration
                  (forall ((pos Int))
                     (= (a (l10 (s Itl10)) pos) (a (l21 Itl10) pos))
                  )
                  ;Define value of variable alength at beginning of next iteration
                  (= (alength (l10 (s Itl10))) (alength (l21 Itl10)))
               )
            )
         )
         ;The loop-condition doesn't hold in the last iteration
         (not
            (< (i (l10 nl10)) blength)
         )
      )
      ;Define referenced terms denoting variable values at main_end
      (and
         (= (alength main_end) (alength (l10 nl10)))
         (forall ((pos Int))
            (= (a main_end pos) (a (l10 nl10) pos))
         )
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

; Axiom: already-proven-lemma i-blength-equality-axiom
(assert
   (=>
      (and
         Dense-increasing-i-l10
         (<= (i (l10 zero)) blength)
      )
      (= (i (l10 nl10)) blength)
   )
)

; Axiom: user-axiom-0
(assert
   (<= 0 blength)
)

; Conjecture: copy_nonzero-conjecture-1
(assert-not
   (forall ((k Int))
      (exists ((l Int))
         (=>
            (and
               (<= 0 k)
               (<= 0 blength)
               (< k (alength main_end))
            )
            (= (a main_end k) (b l))
         )
      )
   )
)

(check-sat)

