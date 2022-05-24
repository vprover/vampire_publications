; main()
; {
;    i = 0 @l14
;    while (i < alength) @l15
;    {
;       a[i] = (i) + (v) @l17
;       i = (i) + (1) @l18
;    }
; }
; 

(set-logic UFDTLIA)

(declare-nat Nat zero s p Sub)
(declare-sort Time 0)
(declare-sort Trace 0)
(declare-program-var a (Time Int) Int)
(declare-const-var alength Int)
(declare-const-var v Int)
(declare-program-var i (Time) Int)
(declare-time-point l14 Time)
(declare-time-point l15 (Nat) Time)
(declare-final-loop-count nl15 Nat)
(declare-time-point l17 (Nat) Time)
(declare-time-point l18 (Nat) Time)
(declare-time-point main_end Time)
(declare-const t1 Trace)
(declare-lemma-predicate Dense-increasing-i-l15 () Bool)

; Axiom: target symbol definitions for symbol elimination
(assert
   true
)

; Axiom: Semantics of function main
(assert
   (and
      ;Loop at location l15
      (and
         ;Define variable values at beginning of loop
         (= (i (l15 zero)) 0)
         ;The loop-condition holds always before the last iteration
         (forall ((Itl15 Nat))
            (=>
               (Sub Itl15 nl15)
               (< (i (l15 Itl15)) alength)
            )
         )
         ;Semantics of the body
         (forall ((Itl15 Nat))
            (=>
               (Sub Itl15 nl15)
               (and
                  ;Update array variable a at location l17
                  (and
                     (= (a (l18 Itl15) (i (l15 Itl15))) (+ (i (l15 Itl15)) v))
                     (forall ((pos Int))
                        (=>
                           (not
                              (= pos (i (l15 Itl15)))
                           )
                           (= (a (l18 Itl15) pos) (a (l15 Itl15) pos))
                        )
                     )
                  )
                  ;Define value of variable i at beginning of next iteration
                  (= (i (l15 (s Itl15))) (+ (i (l15 Itl15)) 1))
                  ;Define value of array variable a at beginning of next iteration
                  (forall ((pos Int))
                     (= (a (l15 (s Itl15)) pos) (a (l18 Itl15) pos))
                  )
               )
            )
         )
         ;The loop-condition doesn't hold in the last iteration
         (not
            (< (i (l15 nl15)) alength)
         )
      )
      ;Define referenced terms denoting variable values at main_end
      (forall ((pos Int))
         (= (a main_end pos) (a (l15 nl15) pos))
      )
   )
)

; Definition: Dense-increasing for i-l15
(assert
   (=
      Dense-increasing-i-l15
      (forall ((Itl15 Nat))
         (=>
            (Sub Itl15 nl15)
            (or
               (= (i (l15 (s Itl15))) (i (l15 Itl15)))
               (= (i (l15 (s Itl15))) (+ (i (l15 Itl15)) 1))
            )
         )
      )
   )
)

; Axiom: already-proven-lemma i-alength-equality-axiom
(assert
   (=>
      (and
         Dense-increasing-i-l15
         (<= (i (l15 zero)) alength)
      )
      (= (i (l15 nl15)) alength)
   )
)

; Axiom: user-axiom-0
(assert
   (<= 0 alength)
)

; Conjecture: init_non_constant_easy-conjecture-3
(assert-not
   (forall ((pos Int))
      (=>
         (and
            (<= 0 alength)
            (<= 0 pos)
            (< pos alength)
            (= v 80)
         )
         (< pos (a main_end pos))
      )
   )
)

(check-sat)

