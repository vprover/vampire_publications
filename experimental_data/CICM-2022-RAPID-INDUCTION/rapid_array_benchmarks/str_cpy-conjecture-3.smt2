; main()
; {
;    i = 0 @l7
;    while ((i < length) && (!(b[i] == 0))) @l8
;    {
;       a[i] = b[i] @l10
;       i = (i) + (1) @l11
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
(declare-time-point l7 Time)
(declare-time-point l8 (Nat) Time)
(declare-final-loop-count nl8 Nat)
(declare-time-point l10 (Nat) Time)
(declare-time-point l11 (Nat) Time)
(declare-time-point main_end Time)
(declare-const t1 Trace)

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
         (= (i (l8 zero)) 0)
         ;The loop-condition holds always before the last iteration
         (forall ((Itl8 Nat))
            (=>
               (Sub Itl8 nl8)
               (and
                  (< (i (l8 Itl8)) length)
                  (not
                     (= (b (i (l8 Itl8))) 0)
                  )
               )
            )
         )
         ;Semantics of the body
         (forall ((Itl8 Nat))
            (=>
               (Sub Itl8 nl8)
               (and
                  ;Update array variable a at location l10
                  (and
                     (= (a (l11 Itl8) (i (l8 Itl8))) (b (i (l8 Itl8))))
                     (forall ((pos Int))
                        (=>
                           (not
                              (= pos (i (l8 Itl8)))
                           )
                           (= (a (l11 Itl8) pos) (a (l8 Itl8) pos))
                        )
                     )
                  )
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
            (and
               (< (i (l8 nl8)) length)
               (not
                  (= (b (i (l8 nl8))) 0)
               )
            )
         )
      )
      ;Define referenced terms denoting variable values at main_end
      (and
         (= (i main_end) (i (l8 nl8)))
         (forall ((pos Int))
            (= (a main_end pos) (a (l8 nl8) pos))
         )
      )
   )
)

; Axiom: user-axiom-0
(assert
   (<= 0 length)
)

; Conjecture: str_cpy-conjecture-3
(assert-not
   (=>
      (and
         (<= 0 length)
         (< (i main_end) length)
      )
      (= (b (i main_end)) 0)
   )
)

(check-sat)

