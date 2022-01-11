; main()
; {
;    i = 0 @l4
;    while (!(a[i] == 0)) @l5
;    {
;       i = (i) + (1) @l7
;    }
; }
; 

(set-logic UFDTLIA)

(declare-nat Nat zero s p Sub)
(declare-sort Time 0)
(declare-sort Trace 0)
(declare-fun a (Int) Int)
(declare-program-var i (Time) Int)
(declare-time-point l4 Time)
(declare-time-point l5 (Nat) Time)
(declare-final-loop-count nl5 Nat)
(declare-time-point l7 (Nat) Time)
(declare-time-point main_end Time)
(declare-const t1 Trace)

; Axiom: target symbol definitions for symbol elimination
(assert
   true
)

; Axiom: Semantics of function main
(assert
   (and
      ;Loop at location l5
      (and
         ;Define variable values at beginning of loop
         (= (i (l5 zero)) 0)
         ;The loop-condition holds always before the last iteration
         (forall ((Itl5 Nat))
            (=>
               (Sub Itl5 nl5)
               (not
                  (= (a (i (l5 Itl5))) 0)
               )
            )
         )
         ;Semantics of the body
         (forall ((Itl5 Nat))
            (=>
               (Sub Itl5 nl5)
               ;Define value of variable i at beginning of next iteration
               (= (i (l5 (s Itl5))) (+ (i (l5 Itl5)) 1))
            )
         )
         ;The loop-condition doesn't hold in the last iteration
         (not
            (not
               (= (a (i (l5 nl5))) 0)
            )
         )
      )
      ;Define referenced terms denoting variable values at main_end
      (= (i main_end) (i (l5 nl5)))
   )
)

; Conjecture: str_len-conjecture-0
(assert-not
   (=>
      (exists ((pos Int))
         (and
            (<= 0 pos)
            (= (a pos) 0)
         )
      )
      (forall ((j Int))
         (=>
            (and
               (<= 0 j)
               (< j (i main_end))
            )
            (not
               (= (a j) 0)
            )
         )
      )
   )
)

(check-sat)

