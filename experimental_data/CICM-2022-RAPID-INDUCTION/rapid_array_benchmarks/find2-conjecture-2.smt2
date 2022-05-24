; main()
; {
;    i = 0 @l14
;    while ((i < alength) && (!(a[i] == v))) @l15
;    {
;       i = (i) + (1) @l17
;    }
; }
; 

(set-logic UFDTLIA)

(declare-nat Nat zero s p Sub)
(declare-sort Time 0)
(declare-sort Trace 0)
(declare-fun a (Int) Int)
(declare-const-var alength Int)
(declare-const-var v Int)
(declare-program-var i (Time) Int)
(declare-time-point l14 Time)
(declare-time-point l15 (Nat) Time)
(declare-final-loop-count nl15 Nat)
(declare-time-point l17 (Nat) Time)
(declare-time-point main_end Time)
(declare-const t1 Trace)

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
               (and
                  (< (i (l15 Itl15)) alength)
                  (not
                     (= (a (i (l15 Itl15))) v)
                  )
               )
            )
         )
         ;Semantics of the body
         (forall ((Itl15 Nat))
            (=>
               (Sub Itl15 nl15)
               ;Define value of variable i at beginning of next iteration
               (= (i (l15 (s Itl15))) (+ (i (l15 Itl15)) 1))
            )
         )
         ;The loop-condition doesn't hold in the last iteration
         (not
            (and
               (< (i (l15 nl15)) alength)
               (not
                  (= (a (i (l15 nl15))) v)
               )
            )
         )
      )
      ;Define referenced terms denoting variable values at main_end
      (= (i main_end) (i (l15 nl15)))
   )
)

; Axiom: user-axiom-0
(assert
   (<= 0 alength)
)

; Conjecture: find2-conjecture-2
(assert-not
   (=>
      (and
         (<= 0 alength)
         (not
            (= (i main_end) alength)
         )
      )
      (exists ((pos Int))
         (= (a pos) v)
      )
   )
)

(check-sat)

