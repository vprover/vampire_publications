; main()
; {
;    a[0] = v @l10
;    i = 1 @l11
;    while (i < alength) @l12
;    {
;       a[i] = (a[(i) - (1)]) + (1) @l14
;       i = (i) + (1) @l15
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
(declare-time-point l10 Time)
(declare-time-point l11 Time)
(declare-time-point l12 (Nat) Time)
(declare-final-loop-count nl12 Nat)
(declare-time-point l14 (Nat) Time)
(declare-time-point l15 (Nat) Time)
(declare-time-point main_end Time)
(declare-const t1 Trace)
(declare-lemma-predicate Dense-increasing-i-l12 () Bool)

; Axiom: target symbol definitions for symbol elimination
(assert
   true
)

; Axiom: Semantics of function main
(assert
   (and
      ;Update array variable a at location l10
      (and
         (= (a l11 0) v)
         (forall ((pos Int))
            (=>
               (not
                  (= pos 0)
               )
               (= (a l11 pos) (a l10 pos))
            )
         )
      )
      ;Loop at location l12
      (and
         ;Define variable values at beginning of loop
         (and
            (= (i (l12 zero)) 1)
            (forall ((pos Int))
               (= (a (l12 zero) pos) (a l11 pos))
            )
         )
         ;The loop-condition holds always before the last iteration
         (forall ((Itl12 Nat))
            (=>
               (Sub Itl12 nl12)
               (< (i (l12 Itl12)) alength)
            )
         )
         ;Semantics of the body
         (forall ((Itl12 Nat))
            (=>
               (Sub Itl12 nl12)
               (and
                  ;Update array variable a at location l14
                  (and
                     (= (a (l15 Itl12) (i (l12 Itl12))) (+ (a (l12 Itl12) (- (i (l12 Itl12)) 1)) 1))
                     (forall ((pos Int))
                        (=>
                           (not
                              (= pos (i (l12 Itl12)))
                           )
                           (= (a (l15 Itl12) pos) (a (l12 Itl12) pos))
                        )
                     )
                  )
                  ;Define value of variable i at beginning of next iteration
                  (= (i (l12 (s Itl12))) (+ (i (l12 Itl12)) 1))
                  ;Define value of array variable a at beginning of next iteration
                  (forall ((pos Int))
                     (= (a (l12 (s Itl12)) pos) (a (l15 Itl12) pos))
                  )
               )
            )
         )
         ;The loop-condition doesn't hold in the last iteration
         (not
            (< (i (l12 nl12)) alength)
         )
      )
      ;Define referenced terms denoting variable values at main_end
      (forall ((pos Int))
         (= (a main_end pos) (a (l12 nl12) pos))
      )
   )
)

; Definition: Dense-increasing for i-l12
(assert
   (=
      Dense-increasing-i-l12
      (forall ((Itl12 Nat))
         (=>
            (Sub Itl12 nl12)
            (or
               (= (i (l12 (s Itl12))) (i (l12 Itl12)))
               (= (i (l12 (s Itl12))) (+ (i (l12 Itl12)) 1))
            )
         )
      )
   )
)

; Axiom: already-proven-lemma i-alength-equality-axiom
(assert
   (=>
      (and
         Dense-increasing-i-l12
         (<= (i (l12 zero)) alength)
      )
      (= (i (l12 nl12)) alength)
   )
)

; Axiom: user-axiom-0
(assert
   (<= 0 alength)
)

; Conjecture: init_previous_plus_one_alternative-conjecture-0
(assert-not
   (forall ((pos Int))
      (=>
         (and
            (<= 0 pos)
            (< (+ pos 1) alength)
            (<= 0 alength)
         )
         (<= (a main_end pos) (a main_end (+ pos 1)))
      )
   )
)

(check-sat)

