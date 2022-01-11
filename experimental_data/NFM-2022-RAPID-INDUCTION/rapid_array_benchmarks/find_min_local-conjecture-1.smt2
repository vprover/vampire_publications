; main()
; {
;    b[0] = a[0] @l9
;    blength = 1 @l10
;    i = 1 @l12
;    m = 0 @l13
;    while (i < alength) @l14
;    {
;       if (a[i] < a[m]) @l16
;       {
;          b[blength] = a[i] @l18
;          blength = (blength) + (1) @l19
;          m = i @l20
;       }
;       else
;       {
;          skip @l24
;       }
;       i = (i) + (1) @l26
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
(declare-program-var i (Time) Int)
(declare-program-var m (Time) Int)
(declare-time-point l9 Time)
(declare-time-point l10 Time)
(declare-time-point l12 Time)
(declare-time-point l13 Time)
(declare-time-point l14 (Nat) Time)
(declare-final-loop-count nl14 Nat)
(declare-time-point l16 (Nat) Time)
(declare-time-point l18 (Nat) Time)
(declare-time-point l19 (Nat) Time)
(declare-time-point l20 (Nat) Time)
(declare-time-point l24 (Nat) Time)
(declare-time-point l26 (Nat) Time)
(declare-time-point main_end Time)
(declare-const t1 Trace)
(declare-lemma-predicate Dense-increasing-i-l14 () Bool)

; Axiom: target symbol definitions for symbol elimination
(assert
   true
)

; Axiom: Semantics of function main
(assert
   (and
      ;Update array variable b at location l9
      (and
         (= (b l10 0) (a 0))
         (forall ((pos Int))
            (=>
               (not
                  (= pos 0)
               )
               (= (b l10 pos) (b l9 pos))
            )
         )
      )
      ;Loop at location l14
      (and
         ;Define variable values at beginning of loop
         (and
            (= (i (l14 zero)) 1)
            (forall ((pos Int))
               (= (b (l14 zero) pos) (b l10 pos))
            )
            (= (blength (l14 zero)) 1)
            (= (m (l14 zero)) 0)
         )
         ;The loop-condition holds always before the last iteration
         (forall ((Itl14 Nat))
            (=>
               (Sub Itl14 nl14)
               (< (i (l14 Itl14)) alength)
            )
         )
         ;Semantics of the body
         (forall ((Itl14 Nat))
            (=>
               (Sub Itl14 nl14)
               (and
                  ;Semantics of IfElse at location l16
                  (and
                     ;Semantics of left branch
                     (=>
                        (< (a (i (l14 Itl14))) (a (m (l14 Itl14))))
                        (and
                           ;Update array variable b at location l18
                           (and
                              (= (b (l19 Itl14) (blength (l14 Itl14))) (a (i (l14 Itl14))))
                              (forall ((pos Int))
                                 (=>
                                    (not
                                       (= pos (blength (l14 Itl14)))
                                    )
                                    (= (b (l19 Itl14) pos) (b (l14 Itl14) pos))
                                 )
                              )
                           )
                           (forall ((pos Int))
                              (= (b (l26 Itl14) pos) (b (l19 Itl14) pos))
                           )
                           (= (blength (l26 Itl14)) (+ (blength (l14 Itl14)) 1))
                           (= (m (l26 Itl14)) (i (l14 Itl14)))
                        )
                     )
                     ;Semantics of right branch
                     (=>
                        (not
                           (< (a (i (l14 Itl14))) (a (m (l14 Itl14))))
                        )
                        (and
                           (forall ((pos Int))
                              (= (b (l26 Itl14) pos) (b (l14 Itl14) pos))
                           )
                           (= (blength (l26 Itl14)) (blength (l14 Itl14)))
                           (= (m (l26 Itl14)) (m (l14 Itl14)))
                        )
                     )
                  )
                  ;Define value of variable i at beginning of next iteration
                  (= (i (l14 (s Itl14))) (+ (i (l14 Itl14)) 1))
                  ;Define value of array variable b at beginning of next iteration
                  (forall ((pos Int))
                     (= (b (l14 (s Itl14)) pos) (b (l26 Itl14) pos))
                  )
                  ;Define value of variable blength at beginning of next iteration
                  (= (blength (l14 (s Itl14))) (blength (l26 Itl14)))
                  ;Define value of variable m at beginning of next iteration
                  (= (m (l14 (s Itl14))) (m (l26 Itl14)))
               )
            )
         )
         ;The loop-condition doesn't hold in the last iteration
         (not
            (< (i (l14 nl14)) alength)
         )
      )
      ;Define referenced terms denoting variable values at main_end
      (and
         (= (blength main_end) (blength (l14 nl14)))
         (forall ((pos Int))
            (= (b main_end pos) (b (l14 nl14) pos))
         )
      )
   )
)

; Definition: Dense-increasing for i-l14
(assert
   (=
      Dense-increasing-i-l14
      (forall ((Itl14 Nat))
         (=>
            (Sub Itl14 nl14)
            (or
               (= (i (l14 (s Itl14))) (i (l14 Itl14)))
               (= (i (l14 (s Itl14))) (+ (i (l14 Itl14)) 1))
            )
         )
      )
   )
)

; Axiom: already-proven-lemma i-alength-equality-axiom
(assert
   (=>
      (and
         Dense-increasing-i-l14
         (<= (i (l14 zero)) alength)
      )
      (= (i (l14 nl14)) alength)
   )
)

; Axiom: user-axiom-0
(assert
   (<= 1 alength)
)

; Conjecture: find_min_local-conjecture-1
(assert-not
   (forall ((j Int))
      (exists ((k Int))
         (=>
            (and
               (<= 1 alength)
               (<= 0 j)
               (< j (blength main_end))
            )
            (and
               (<= 0 k)
               (< k alength)
               (= (b main_end j) (a k))
            )
         )
      )
   )
)

(check-sat)

