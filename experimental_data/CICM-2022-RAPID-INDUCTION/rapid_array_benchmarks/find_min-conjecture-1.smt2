; main()
; {
;    i = 0 @l6
;    min = 0 @l7
;    while (i < alength) @l8
;    {
;       if (a[i] < min) @l10
;       {
;          min = a[i] @l12
;       }
;       else
;       {
;          skip @l16
;       }
;       i = (i) + (1) @l18
;    }
; }
; 

(set-logic UFDTLIA)

(declare-nat Nat zero s p Sub)
(declare-sort Time 0)
(declare-sort Trace 0)
(declare-fun a (Int) Int)
(declare-const-var alength Int)
(declare-program-var i (Time) Int)
(declare-program-var min (Time) Int)
(declare-time-point l6 Time)
(declare-time-point l7 Time)
(declare-time-point l8 (Nat) Time)
(declare-final-loop-count nl8 Nat)
(declare-time-point l10 (Nat) Time)
(declare-time-point l12 (Nat) Time)
(declare-time-point l16 (Nat) Time)
(declare-time-point l18 (Nat) Time)
(declare-time-point main_end Time)
(declare-const t1 Trace)
(declare-lemma-predicate Dense-increasing-i-l8 () Bool)

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
         (and
            (= (i (l8 zero)) 0)
            (= (min (l8 zero)) 0)
         )
         ;The loop-condition holds always before the last iteration
         (forall ((Itl8 Nat))
            (=>
               (Sub Itl8 nl8)
               (< (i (l8 Itl8)) alength)
            )
         )
         ;Semantics of the body
         (forall ((Itl8 Nat))
            (=>
               (Sub Itl8 nl8)
               (and
                  ;Semantics of IfElse at location l10
                  (and
                     ;Semantics of left branch
                     (=>
                        (< (a (i (l8 Itl8))) (min (l8 Itl8)))
                        (= (min (l18 Itl8)) (a (i (l8 Itl8))))
                     )
                     ;Semantics of right branch
                     (=>
                        (not
                           (< (a (i (l8 Itl8))) (min (l8 Itl8)))
                        )
                        (= (min (l18 Itl8)) (min (l8 Itl8)))
                     )
                  )
                  ;Define value of variable i at beginning of next iteration
                  (= (i (l8 (s Itl8))) (+ (i (l8 Itl8)) 1))
                  ;Define value of variable min at beginning of next iteration
                  (= (min (l8 (s Itl8))) (min (l18 Itl8)))
               )
            )
         )
         ;The loop-condition doesn't hold in the last iteration
         (not
            (< (i (l8 nl8)) alength)
         )
      )
      ;Define referenced terms denoting variable values at main_end
      (= (min main_end) (min (l8 nl8)))
   )
)

; Definition: Dense-increasing for i-l8
(assert
   (=
      Dense-increasing-i-l8
      (forall ((Itl8 Nat))
         (=>
            (Sub Itl8 nl8)
            (or
               (= (i (l8 (s Itl8))) (i (l8 Itl8)))
               (= (i (l8 (s Itl8))) (+ (i (l8 Itl8)) 1))
            )
         )
      )
   )
)

; Axiom: already-proven-lemma i-alength-equality-axiom
(assert
   (=>
      (and
         Dense-increasing-i-l8
         (<= (i (l8 zero)) alength)
      )
      (= (i (l8 nl8)) alength)
   )
)

; Axiom: user-axiom-0
(assert
   (<= 0 alength)
)

; Conjecture: find_min-conjecture-1
(assert-not
   (=>
      (and
         (<= 0 alength)
         (exists ((k Int))
            (and
               (<= 0 k)
               (< k alength)
               (< (a k) 0)
            )
         )
      )
      (exists ((k Int))
         (and
            (<= 0 k)
            (< k alength)
            (= (a k) (min main_end))
         )
      )
   )
)

(check-sat)

