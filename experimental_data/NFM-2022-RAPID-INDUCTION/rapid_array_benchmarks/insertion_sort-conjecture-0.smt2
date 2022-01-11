; main()
; {
;    j = 1 @l4
;    while (j < alength) @l10
;    {
;       pivot = a[j] @l12
;       i = (j) - (1) @l13
;       while ((i >= 0) && (a[i] > pivot)) @l14
;       {
;          a[(i) + (1)] = a[i] @l16
;          i = (i) - (1) @l17
;       }
;       a[(i) + (1)] = pivot @l19
;       j = (j) + (1) @l20
;    }
; }
; 

(set-logic UFDTLIA)

(declare-nat Nat zero s p Sub)
(declare-sort Time 0)
(declare-sort Trace 0)
(declare-program-var i (Time) Int)
(declare-program-var j (Time) Int)
(declare-program-var pivot (Time) Int)
(declare-const-var alength Int)
(declare-program-var a (Time Int) Int)
(declare-time-point l4 Time)
(declare-time-point l10 (Nat) Time)
(declare-final-loop-count nl10 Nat)
(declare-time-point l12 (Nat) Time)
(declare-time-point l13 (Nat) Time)
(declare-time-point l14 (Nat Nat) Time)
(declare-final-loop-count nl14 (Nat) Nat)
(declare-time-point l16 (Nat Nat) Time)
(declare-time-point l17 (Nat Nat) Time)
(declare-time-point l19 (Nat) Time)
(declare-time-point l20 (Nat) Time)
(declare-time-point main_end Time)
(declare-const t1 Trace)
(declare-lemma-predicate Dense-increasing-j-l10 () Bool)

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
         (= (j (l10 zero)) 1)
         ;The loop-condition holds always before the last iteration
         (forall ((Itl10 Nat))
            (=>
               (Sub Itl10 nl10)
               (< (j (l10 Itl10)) alength)
            )
         )
         ;Semantics of the body
         (forall ((Itl10 Nat))
            (=>
               (Sub Itl10 nl10)
               (and
                  ;Loop at location l14
                  (and
                     ;Define variable values at beginning of loop
                     (and
                        (= (i (l14 Itl10 zero)) (- (j (l10 Itl10)) 1))
                        (forall ((pos Int))
                           (= (a (l14 Itl10 zero) pos) (a (l10 Itl10) pos))
                        )
                     )
                     ;The loop-condition holds always before the last iteration
                     (forall ((Itl14 Nat))
                        (=>
                           (Sub Itl14 (nl14 Itl10))
                           (and
                              (>= (i (l14 Itl10 Itl14)) 0)
                              (> (a (l14 Itl10 Itl14) (i (l14 Itl10 Itl14))) (a (l10 Itl10) (j (l10 Itl10))))
                           )
                        )
                     )
                     ;Semantics of the body
                     (forall ((Itl14 Nat))
                        (=>
                           (Sub Itl14 (nl14 Itl10))
                           (and
                              ;Update array variable a at location l16
                              (and
                                 (= (a (l17 Itl10 Itl14) (+ (i (l14 Itl10 Itl14)) 1)) (a (l14 Itl10 Itl14) (i (l14 Itl10 Itl14))))
                                 (forall ((pos Int))
                                    (=>
                                       (not
                                          (= pos (+ (i (l14 Itl10 Itl14)) 1))
                                       )
                                       (= (a (l17 Itl10 Itl14) pos) (a (l14 Itl10 Itl14) pos))
                                    )
                                 )
                              )
                              ;Define value of variable i at beginning of next iteration
                              (= (i (l14 Itl10 (s Itl14))) (- (i (l14 Itl10 Itl14)) 1))
                              ;Define value of array variable a at beginning of next iteration
                              (forall ((pos Int))
                                 (= (a (l14 Itl10 (s Itl14)) pos) (a (l17 Itl10 Itl14) pos))
                              )
                           )
                        )
                     )
                     ;The loop-condition doesn't hold in the last iteration
                     (not
                        (and
                           (>= (i (l14 Itl10 (nl14 Itl10))) 0)
                           (> (a (l14 Itl10 (nl14 Itl10)) (i (l14 Itl10 (nl14 Itl10)))) (a (l10 Itl10) (j (l10 Itl10))))
                        )
                     )
                  )
                  ;Update array variable a at location l19
                  (and
                     (= (a (l20 Itl10) (+ (i (l14 Itl10 (nl14 Itl10))) 1)) (a (l10 Itl10) (j (l10 Itl10))))
                     (forall ((pos Int))
                        (=>
                           (not
                              (= pos (+ (i (l14 Itl10 (nl14 Itl10))) 1))
                           )
                           (= (a (l20 Itl10) pos) (a (l14 Itl10 (nl14 Itl10)) pos))
                        )
                     )
                  )
                  ;Define value of variable j at beginning of next iteration
                  (= (j (l10 (s Itl10))) (+ (j (l10 Itl10)) 1))
                  ;Define value of array variable a at beginning of next iteration
                  (forall ((pos Int))
                     (= (a (l10 (s Itl10)) pos) (a (l20 Itl10) pos))
                  )
                  ;Define value of variable i at beginning of next iteration
                  (= (i (l10 (s Itl10))) (i (l14 Itl10 (nl14 Itl10))))
                  ;Define value of variable pivot at beginning of next iteration
                  (= (pivot (l10 (s Itl10))) (a (l10 Itl10) (j (l10 Itl10))))
               )
            )
         )
         ;The loop-condition doesn't hold in the last iteration
         (not
            (< (j (l10 nl10)) alength)
         )
      )
      ;Define referenced terms denoting variable values at main_end
      (forall ((pos Int))
         (= (a main_end pos) (a (l10 nl10) pos))
      )
   )
)

; Definition: Dense-increasing for j-l10
(assert
   (=
      Dense-increasing-j-l10
      (forall ((Itl10 Nat))
         (=>
            (Sub Itl10 nl10)
            (or
               (= (j (l10 (s Itl10))) (j (l10 Itl10)))
               (= (j (l10 (s Itl10))) (+ (j (l10 Itl10)) 1))
            )
         )
      )
   )
)

; Axiom: already-proven-lemma j-alength-equality-axiom
(assert
   (=>
      (and
         Dense-increasing-j-l10
         (<= (j (l10 zero)) alength)
      )
      (= (j (l10 nl10)) alength)
   )
)

; Conjecture: insertion_sort-conjecture-0
(assert-not
   (forall ((k Int))
      (=>
         (and
            (<= 2 alength)
            (<= 0 k)
            (< k (- alength 1))
         )
         (<= (a main_end k) (a main_end (+ k 1)))
      )
   )
)

(check-sat)

