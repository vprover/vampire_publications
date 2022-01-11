; main()
; {
;    i = 0 @l6
;    j = 0 @l7
;    while (i < blength) @l8
;    {
;       a[i] = b[j] @l10
;       i = (i) + (1) @l11
;       j = (j) + (1) @l12
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
(declare-program-var j (Time) Int)
(declare-time-point l6 Time)
(declare-time-point l7 Time)
(declare-time-point l8 (Nat) Time)
(declare-final-loop-count nl8 Nat)
(declare-time-point l10 (Nat) Time)
(declare-time-point l11 (Nat) Time)
(declare-time-point l12 (Nat) Time)
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
         (and
            (= (j (l8 zero)) 0)
            (= (i (l8 zero)) 0)
         )
         ;The loop-condition holds always before the last iteration
         (forall ((Itl8 Nat))
            (=>
               (Sub Itl8 nl8)
               (< (i (l8 Itl8)) blength)
            )
         )
         ;Semantics of the body
         (forall ((Itl8 Nat))
            (=>
               (Sub Itl8 nl8)
               (and
                  ;Update array variable a at location l10
                  (and
                     (= (a (l11 Itl8) (i (l8 Itl8))) (b (j (l8 Itl8))))
                     (forall ((pos Int))
                        (=>
                           (not
                              (= pos (i (l8 Itl8)))
                           )
                           (= (a (l11 Itl8) pos) (a (l8 Itl8) pos))
                        )
                     )
                  )
                  ;Define value of variable j at beginning of next iteration
                  (= (j (l8 (s Itl8))) (+ (j (l8 Itl8)) 1))
                  ;Define value of variable i at beginning of next iteration
                  (= (i (l8 (s Itl8))) (+ (i (l8 Itl8)) 1))
                  ;Define value of array variable a at beginning of next iteration
                  (forall ((pos Int))
                     (= (a (l8 (s Itl8)) pos) (a (l11 Itl8) pos))
                  )
               )
            )
         )
         ;The loop-condition doesn't hold in the last iteration
         (not
            (< (i (l8 nl8)) blength)
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

; Axiom: already-proven-lemma i-blength-equality-axiom
(assert
   (=>
      (and
         Dense-increasing-i-l8
         (<= (i (l8 zero)) blength)
      )
      (= (i (l8 nl8)) blength)
   )
)

; Axiom: user-axiom-0
(assert
   (forall ((it Nat))
      (= (i (l8 it)) (j (l8 it)))
   )
)

; Axiom: user-axiom-1
(assert
   (<= 0 blength)
)

; Conjecture: copy_two_indices-conjecture-0
(assert-not
   (forall ((k Int))
      (=>
         (and
            (<= 0 blength)
            (<= 0 k)
            (< k blength)
         )
         (= (a main_end k) (b k))
      )
   )
)

(check-sat)

