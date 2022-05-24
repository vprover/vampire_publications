; main()
; {
;    i = 0 @l9
;    while (i < length) @l10
;    {
;       a[i] = b[((length) - (1)) - (i)] @l12
;       i = (i) + (1) @l13
;    }
; }
; 

(set-logic UFDTLIA)

(declare-nat Nat zero s p Sub)
(declare-sort Time 0)
(declare-sort Trace 0)
(declare-program-var a (Time Int) Int)
(declare-fun b (Int) Int)
(declare-const-var length Int)
(declare-program-var i (Time) Int)
(declare-time-point l9 Time)
(declare-time-point l10 (Nat) Time)
(declare-final-loop-count nl10 Nat)
(declare-time-point l12 (Nat) Time)
(declare-time-point l13 (Nat) Time)
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
         (= (i (l10 zero)) 0)
         ;The loop-condition holds always before the last iteration
         (forall ((Itl10 Nat))
            (=>
               (Sub Itl10 nl10)
               (< (i (l10 Itl10)) length)
            )
         )
         ;Semantics of the body
         (forall ((Itl10 Nat))
            (=>
               (Sub Itl10 nl10)
               (and
                  ;Update array variable a at location l12
                  (and
                     (= (a (l13 Itl10) (i (l10 Itl10))) (b (- (- length 1) (i (l10 Itl10)))))
                     (forall ((pos Int))
                        (=>
                           (not
                              (= pos (i (l10 Itl10)))
                           )
                           (= (a (l13 Itl10) pos) (a (l10 Itl10) pos))
                        )
                     )
                  )
                  ;Define value of variable i at beginning of next iteration
                  (= (i (l10 (s Itl10))) (+ (i (l10 Itl10)) 1))
                  ;Define value of array variable a at beginning of next iteration
                  (forall ((pos Int))
                     (= (a (l10 (s Itl10)) pos) (a (l13 Itl10) pos))
                  )
               )
            )
         )
         ;The loop-condition doesn't hold in the last iteration
         (not
            (< (i (l10 nl10)) length)
         )
      )
      ;Define referenced terms denoting variable values at main_end
      (forall ((pos Int))
         (= (a main_end pos) (a (l10 nl10) pos))
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

; Axiom: already-proven-lemma i-length-equality-axiom
(assert
   (=>
      (and
         Dense-increasing-i-l10
         (<= (i (l10 zero)) length)
      )
      (= (i (l10 nl10)) length)
   )
)

; Axiom: user-axiom-0
(assert
   (<= 0 length)
)

; Conjecture: reverse-conjecture-0
(assert-not
   (forall ((j Int))
      (=>
         (and
            (<= 0 length)
            (<= 0 j)
            (< j length)
         )
         (= (a main_end j) (b (- (- length 1) j)))
      )
   )
)

(check-sat)

