; main()
; {
;    i = 0 @l14
;    r = alength @l15
;    while ((i < alength) && (r == alength)) @l17
;    {
;       if (a[i] == v) @l19
;       {
;          r = i @l21
;       }
;       else
;       {
;          skip @l25
;       }
;       i = (i) + (1) @l27
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
(declare-program-var r (Time) Int)
(declare-time-point l14 Time)
(declare-time-point l15 Time)
(declare-time-point l17 (Nat) Time)
(declare-final-loop-count nl17 Nat)
(declare-time-point l19 (Nat) Time)
(declare-time-point l21 (Nat) Time)
(declare-time-point l25 (Nat) Time)
(declare-time-point l27 (Nat) Time)
(declare-time-point main_end Time)
(declare-const t1 Trace)

; Axiom: target symbol definitions for symbol elimination
(assert
   true
)

; Axiom: Semantics of function main
(assert
   (and
      ;Loop at location l17
      (and
         ;Define variable values at beginning of loop
         (and
            (= (i (l17 zero)) 0)
            (= (r (l17 zero)) alength)
         )
         ;The loop-condition holds always before the last iteration
         (forall ((Itl17 Nat))
            (=>
               (Sub Itl17 nl17)
               (and
                  (< (i (l17 Itl17)) alength)
                  (= (r (l17 Itl17)) alength)
               )
            )
         )
         ;Semantics of the body
         (forall ((Itl17 Nat))
            (=>
               (Sub Itl17 nl17)
               (and
                  ;Semantics of IfElse at location l19
                  (and
                     ;Semantics of left branch
                     (=>
                        (= (a (i (l17 Itl17))) v)
                        (= (r (l27 Itl17)) (i (l17 Itl17)))
                     )
                     ;Semantics of right branch
                     (=>
                        (not
                           (= (a (i (l17 Itl17))) v)
                        )
                        (= (r (l27 Itl17)) (r (l17 Itl17)))
                     )
                  )
                  ;Define value of variable i at beginning of next iteration
                  (= (i (l17 (s Itl17))) (+ (i (l17 Itl17)) 1))
                  ;Define value of variable r at beginning of next iteration
                  (= (r (l17 (s Itl17))) (r (l27 Itl17)))
               )
            )
         )
         ;The loop-condition doesn't hold in the last iteration
         (not
            (and
               (< (i (l17 nl17)) alength)
               (= (r (l17 nl17)) alength)
            )
         )
      )
      ;Define referenced terms denoting variable values at main_end
      (= (r main_end) (r (l17 nl17)))
   )
)

; Axiom: user-axiom-0
(assert
   (<= 0 alength)
)

; Conjecture: find1-conjecture-3
(assert-not
   (=>
      (and
         (<= 0 alength)
         (< (r main_end) alength)
      )
      (exists ((pos Int))
         (= (a pos) v)
      )
   )
)

(check-sat)

