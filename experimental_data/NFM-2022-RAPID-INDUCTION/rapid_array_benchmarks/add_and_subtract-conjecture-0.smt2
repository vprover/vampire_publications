; main()
; {
;    i = 0 @l6
;    while (i < alength) @l9
;    {
;       a[i] = (a[i]) + (n) @l11
;       i = (i) + (1) @l12
;    }
;    j = 0 @l15
;    while (j < alength) @l17
;    {
;       a[j] = (a[j]) - (n) @l19
;       j = (j) + (1) @l20
;    }
; }
; 

(set-logic UFDTLIA)

(declare-nat Nat zero s p Sub)
(declare-sort Time 0)
(declare-sort Trace 0)
(declare-const-var alength Int)
(declare-program-var a (Time Int) Int)
(declare-program-var i (Time) Int)
(declare-const-var n Int)
(declare-program-var j (Time) Int)
(declare-time-point l6 Time)
(declare-time-point l9 (Nat) Time)
(declare-final-loop-count nl9 Nat)
(declare-time-point l11 (Nat) Time)
(declare-time-point l12 (Nat) Time)
(declare-time-point l15 Time)
(declare-time-point l17 (Nat) Time)
(declare-final-loop-count nl17 Nat)
(declare-time-point l19 (Nat) Time)
(declare-time-point l20 (Nat) Time)
(declare-time-point main_end Time)
(declare-const t1 Trace)
(declare-lemma-predicate Dense-increasing-i-l9 () Bool)
(declare-lemma-predicate Dense-increasing-j-l17 () Bool)

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
            (forall ((pos Int))
               (= (a (l9 zero) pos) (a l6 pos))
            )
         )
         ;The loop-condition holds always before the last iteration
         (forall ((Itl9 Nat))
            (=>
               (Sub Itl9 nl9)
               (< (i (l9 Itl9)) alength)
            )
         )
         ;Semantics of the body
         (forall ((Itl9 Nat))
            (=>
               (Sub Itl9 nl9)
               (and
                  ;Update array variable a at location l11
                  (and
                     (= (a (l12 Itl9) (i (l9 Itl9))) (+ (a (l9 Itl9) (i (l9 Itl9))) n))
                     (forall ((pos Int))
                        (=>
                           (not
                              (= pos (i (l9 Itl9)))
                           )
                           (= (a (l12 Itl9) pos) (a (l9 Itl9) pos))
                        )
                     )
                  )
                  ;Define value of variable i at beginning of next iteration
                  (= (i (l9 (s Itl9))) (+ (i (l9 Itl9)) 1))
                  ;Define value of array variable a at beginning of next iteration
                  (forall ((pos Int))
                     (= (a (l9 (s Itl9)) pos) (a (l12 Itl9) pos))
                  )
               )
            )
         )
         ;The loop-condition doesn't hold in the last iteration
         (not
            (< (i (l9 nl9)) alength)
         )
      )
      ;Loop at location l17
      (and
         ;Define variable values at beginning of loop
         (and
            (= (j (l17 zero)) 0)
            (forall ((pos Int))
               (= (a (l17 zero) pos) (a (l9 nl9) pos))
            )
         )
         ;The loop-condition holds always before the last iteration
         (forall ((Itl17 Nat))
            (=>
               (Sub Itl17 nl17)
               (< (j (l17 Itl17)) alength)
            )
         )
         ;Semantics of the body
         (forall ((Itl17 Nat))
            (=>
               (Sub Itl17 nl17)
               (and
                  ;Update array variable a at location l19
                  (and
                     (= (a (l20 Itl17) (j (l17 Itl17))) (- (a (l17 Itl17) (j (l17 Itl17))) n))
                     (forall ((pos Int))
                        (=>
                           (not
                              (= pos (j (l17 Itl17)))
                           )
                           (= (a (l20 Itl17) pos) (a (l17 Itl17) pos))
                        )
                     )
                  )
                  ;Define value of variable j at beginning of next iteration
                  (= (j (l17 (s Itl17))) (+ (j (l17 Itl17)) 1))
                  ;Define value of array variable a at beginning of next iteration
                  (forall ((pos Int))
                     (= (a (l17 (s Itl17)) pos) (a (l20 Itl17) pos))
                  )
               )
            )
         )
         ;The loop-condition doesn't hold in the last iteration
         (not
            (< (j (l17 nl17)) alength)
         )
      )
      ;Define referenced terms denoting variable values at main_end
      (forall ((pos Int))
         (= (a main_end pos) (a (l17 nl17) pos))
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

; Axiom: already-proven-lemma i-alength-equality-axiom
(assert
   (=>
      (and
         Dense-increasing-i-l9
         (<= (i (l9 zero)) alength)
      )
      (= (i (l9 nl9)) alength)
   )
)

; Definition: Dense-increasing for j-l17
(assert
   (=
      Dense-increasing-j-l17
      (forall ((Itl17 Nat))
         (=>
            (Sub Itl17 nl17)
            (or
               (= (j (l17 (s Itl17))) (j (l17 Itl17)))
               (= (j (l17 (s Itl17))) (+ (j (l17 Itl17)) 1))
            )
         )
      )
   )
)

; Axiom: already-proven-lemma j-alength-equality-axiom
(assert
   (=>
      (and
         Dense-increasing-j-l17
         (<= (j (l17 zero)) alength)
      )
      (= (j (l17 nl17)) alength)
   )
)

; Axiom: user-axiom-0
(assert
   (<= 0 alength)
)

; Conjecture: add_and_subtract-conjecture-0
(assert-not
   (forall ((k Int))
      (=>
         (and
            (<= 0 k)
            (< k alength)
         )
         (= (a main_end k) (a l6 k))
      )
   )
)

(check-sat)

