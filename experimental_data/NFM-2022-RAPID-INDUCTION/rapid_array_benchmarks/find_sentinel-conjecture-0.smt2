; main()
; {
;    i = 0 @l12
;    a[j] = v @l13
;    while ((i < alength) && (!(a[i] == v))) @l14
;    {
;       i = (i) + (1) @l16
;    }
; }
; 

(set-logic UFDTLIA)

(declare-nat Nat zero s p Sub)
(declare-sort Time 0)
(declare-sort Trace 0)
(declare-program-var a (Time Int) Int)
(declare-const-var j Int)
(declare-const-var v Int)
(declare-const-var alength Int)
(declare-program-var i (Time) Int)
(declare-time-point l12 Time)
(declare-time-point l13 Time)
(declare-time-point l14 (Nat) Time)
(declare-final-loop-count nl14 Nat)
(declare-time-point l16 (Nat) Time)
(declare-time-point main_end Time)
(declare-const t1 Trace)

; Axiom: target symbol definitions for symbol elimination
(assert
   true
)

; Axiom: Semantics of function main
(assert
   (and
      ;Update array variable a at location l13
      (and
         (= (a (l14 zero) j) v)
         (forall ((pos Int))
            (=>
               (not
                  (= pos j)
               )
               (= (a (l14 zero) pos) (a l13 pos))
            )
         )
      )
      ;Loop at location l14
      (and
         ;Define variable values at beginning of loop
         (= (i (l14 zero)) 0)
         ;The loop-condition holds always before the last iteration
         (forall ((Itl14 Nat))
            (=>
               (Sub Itl14 nl14)
               (and
                  (< (i (l14 Itl14)) alength)
                  (not
                     (= (a (l14 zero) (i (l14 Itl14))) v)
                  )
               )
            )
         )
         ;Semantics of the body
         (forall ((Itl14 Nat))
            (=>
               (Sub Itl14 nl14)
               ;Define value of variable i at beginning of next iteration
               (= (i (l14 (s Itl14))) (+ (i (l14 Itl14)) 1))
            )
         )
         ;The loop-condition doesn't hold in the last iteration
         (not
            (and
               (< (i (l14 nl14)) alength)
               (not
                  (= (a (l14 zero) (i (l14 nl14))) v)
               )
            )
         )
      )
      ;Define referenced terms denoting variable values at main_end
      (= (i main_end) (i (l14 nl14)))
   )
)

; Axiom: user-axiom-0
(assert
   (<= 0 alength)
)

; Conjecture: find_sentinel-conjecture-0
(assert-not
   (=>
      (and
         (<= 0 alength)
         (<= 0 j)
         (< j alength)
      )
      (<= (i main_end) j)
   )
)

(check-sat)

