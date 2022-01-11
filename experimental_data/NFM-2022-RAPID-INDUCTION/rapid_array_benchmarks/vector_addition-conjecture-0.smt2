; main()
; {
;    i = 0 @l12
;    while (i < length) @l13
;    {
;       c[i] = (a[i]) + (b[i]) @l15
;       i = (i) + (1) @l16
;    }
; }
; 

(set-logic UFDTLIA)

(declare-nat Nat zero s p Sub)
(declare-sort Time 0)
(declare-sort Trace 0)
(declare-fun a (Int) Int)
(declare-fun b (Int) Int)
(declare-program-var c (Time Int) Int)
(declare-const-var length Int)
(declare-program-var i (Time) Int)
(declare-time-point l12 Time)
(declare-time-point l13 (Nat) Time)
(declare-final-loop-count nl13 Nat)
(declare-time-point l15 (Nat) Time)
(declare-time-point l16 (Nat) Time)
(declare-time-point main_end Time)
(declare-const t1 Trace)
(declare-lemma-predicate Dense-increasing-i-l13 () Bool)

; Axiom: target symbol definitions for symbol elimination
(assert
   true
)

; Axiom: Semantics of function main
(assert
   (and
      ;Loop at location l13
      (and
         ;Define variable values at beginning of loop
         (= (i (l13 zero)) 0)
         ;The loop-condition holds always before the last iteration
         (forall ((Itl13 Nat))
            (=>
               (Sub Itl13 nl13)
               (< (i (l13 Itl13)) length)
            )
         )
         ;Semantics of the body
         (forall ((Itl13 Nat))
            (=>
               (Sub Itl13 nl13)
               (and
                  ;Update array variable c at location l15
                  (and
                     (= (c (l16 Itl13) (i (l13 Itl13))) (+ (a (i (l13 Itl13))) (b (i (l13 Itl13)))))
                     (forall ((pos Int))
                        (=>
                           (not
                              (= pos (i (l13 Itl13)))
                           )
                           (= (c (l16 Itl13) pos) (c (l13 Itl13) pos))
                        )
                     )
                  )
                  ;Define value of variable i at beginning of next iteration
                  (= (i (l13 (s Itl13))) (+ (i (l13 Itl13)) 1))
                  ;Define value of array variable c at beginning of next iteration
                  (forall ((pos Int))
                     (= (c (l13 (s Itl13)) pos) (c (l16 Itl13) pos))
                  )
               )
            )
         )
         ;The loop-condition doesn't hold in the last iteration
         (not
            (< (i (l13 nl13)) length)
         )
      )
      ;Define referenced terms denoting variable values at main_end
      (forall ((pos Int))
         (= (c main_end pos) (c (l13 nl13) pos))
      )
   )
)

; Definition: Dense-increasing for i-l13
(assert
   (=
      Dense-increasing-i-l13
      (forall ((Itl13 Nat))
         (=>
            (Sub Itl13 nl13)
            (or
               (= (i (l13 (s Itl13))) (i (l13 Itl13)))
               (= (i (l13 (s Itl13))) (+ (i (l13 Itl13)) 1))
            )
         )
      )
   )
)

; Axiom: already-proven-lemma i-length-equality-axiom
(assert
   (=>
      (and
         Dense-increasing-i-l13
         (<= (i (l13 zero)) length)
      )
      (= (i (l13 nl13)) length)
   )
)

; Axiom: user-axiom-0
(assert
   (<= 0 length)
)

; Conjecture: vector_addition-conjecture-0
(assert-not
   (forall ((j Int))
      (=>
         (and
            (<= 0 j)
            (< j length)
            (<= 0 length)
         )
         (= (c main_end j) (+ (a j) (b j)))
      )
   )
)

(check-sat)

