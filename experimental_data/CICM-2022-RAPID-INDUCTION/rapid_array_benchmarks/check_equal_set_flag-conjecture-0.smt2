; main()
; {
;    r = 0 @l14
;    i = 0 @l15
;    while (i < length) @l16
;    {
;       if (!(a[i] == b[i])) @l18
;       {
;          r = 1 @l20
;       }
;       else
;       {
;          skip @l24
;       }
;       i = (i) + (1) @l26
;    }
; }
; 

(set-logic UFDTLIA)

(declare-nat Nat zero s p Sub)
(declare-sort Time 0)
(declare-sort Trace 0)
(declare-fun a (Int) Int)
(declare-fun b (Int) Int)
(declare-const-var length Int)
(declare-program-var r (Time) Int)
(declare-program-var i (Time) Int)
(declare-time-point l14 Time)
(declare-time-point l15 Time)
(declare-time-point l16 (Nat) Time)
(declare-final-loop-count nl16 Nat)
(declare-time-point l18 (Nat) Time)
(declare-time-point l20 (Nat) Time)
(declare-time-point l24 (Nat) Time)
(declare-time-point l26 (Nat) Time)
(declare-time-point main_end Time)
(declare-const t1 Trace)
(declare-lemma-predicate Dense-increasing-i-l16 () Bool)

; Axiom: target symbol definitions for symbol elimination
(assert
   true
)

; Axiom: Semantics of function main
(assert
   (and
      ;Loop at location l16
      (and
         ;Define variable values at beginning of loop
         (and
            (= (i (l16 zero)) 0)
            (= (r (l16 zero)) 0)
         )
         ;The loop-condition holds always before the last iteration
         (forall ((Itl16 Nat))
            (=>
               (Sub Itl16 nl16)
               (< (i (l16 Itl16)) length)
            )
         )
         ;Semantics of the body
         (forall ((Itl16 Nat))
            (=>
               (Sub Itl16 nl16)
               (and
                  ;Semantics of IfElse at location l18
                  (and
                     ;Semantics of left branch
                     (=>
                        (not
                           (= (a (i (l16 Itl16))) (b (i (l16 Itl16))))
                        )
                        (= (r (l26 Itl16)) 1)
                     )
                     ;Semantics of right branch
                     (=>
                        (not
                           (not
                              (= (a (i (l16 Itl16))) (b (i (l16 Itl16))))
                           )
                        )
                        (= (r (l26 Itl16)) (r (l16 Itl16)))
                     )
                  )
                  ;Define value of variable i at beginning of next iteration
                  (= (i (l16 (s Itl16))) (+ (i (l16 Itl16)) 1))
                  ;Define value of variable r at beginning of next iteration
                  (= (r (l16 (s Itl16))) (r (l26 Itl16)))
               )
            )
         )
         ;The loop-condition doesn't hold in the last iteration
         (not
            (< (i (l16 nl16)) length)
         )
      )
      ;Define referenced terms denoting variable values at main_end
      (= (r main_end) (r (l16 nl16)))
   )
)

; Definition: Dense-increasing for i-l16
(assert
   (=
      Dense-increasing-i-l16
      (forall ((Itl16 Nat))
         (=>
            (Sub Itl16 nl16)
            (or
               (= (i (l16 (s Itl16))) (i (l16 Itl16)))
               (= (i (l16 (s Itl16))) (+ (i (l16 Itl16)) 1))
            )
         )
      )
   )
)

; Axiom: already-proven-lemma i-length-equality-axiom
(assert
   (=>
      (and
         Dense-increasing-i-l16
         (<= (i (l16 zero)) length)
      )
      (= (i (l16 nl16)) length)
   )
)

; Axiom: user-axiom-0
(assert
   (<= 0 length)
)

; Conjecture: check_equal_set_flag-conjecture-0
(assert-not
   (=>
      (and
         (<= 0 length)
         (= (r main_end) 1)
      )
      (exists ((k Int))
         (not
            (= (a k) (b k))
         )
      )
   )
)

(check-sat)

