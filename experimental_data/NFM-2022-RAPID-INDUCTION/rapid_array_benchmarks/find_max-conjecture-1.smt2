; main()
; {
;    i = 0 @l7
;    max = 0 @l8
;    while (i < alength) @l9
;    {
;       if (a[i] > max) @l11
;       {
;          max = a[i] @l13
;       }
;       else
;       {
;          skip @l17
;       }
;       i = (i) + (1) @l19
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
(declare-program-var max (Time) Int)
(declare-time-point l7 Time)
(declare-time-point l8 Time)
(declare-time-point l9 (Nat) Time)
(declare-final-loop-count nl9 Nat)
(declare-time-point l11 (Nat) Time)
(declare-time-point l13 (Nat) Time)
(declare-time-point l17 (Nat) Time)
(declare-time-point l19 (Nat) Time)
(declare-time-point main_end Time)
(declare-const t1 Trace)
(declare-lemma-predicate Dense-increasing-i-l9 () Bool)

; Axiom: target symbol definitions for symbol elimination
(assert
   true
)

; Axiom: Semantics of function main
(assert
   (and
      ;Loop at location l9
      (and
         ;Define variable values at beginning of loop
         (and
            (= (i (l9 zero)) 0)
            (= (max (l9 zero)) 0)
         )
         ;The loop-condition holds always before the last iteration
         (forall ((Itl9 Nat))
            (=>
               (Sub Itl9 nl9)
               (< (i (l9 Itl9)) alength)
            )
         )
         ;Semantics of the body
         (forall ((Itl9 Nat))
            (=>
               (Sub Itl9 nl9)
               (and
                  ;Semantics of IfElse at location l11
                  (and
                     ;Semantics of left branch
                     (=>
                        (> (a (i (l9 Itl9))) (max (l9 Itl9)))
                        (= (max (l19 Itl9)) (a (i (l9 Itl9))))
                     )
                     ;Semantics of right branch
                     (=>
                        (not
                           (> (a (i (l9 Itl9))) (max (l9 Itl9)))
                        )
                        (= (max (l19 Itl9)) (max (l9 Itl9)))
                     )
                  )
                  ;Define value of variable i at beginning of next iteration
                  (= (i (l9 (s Itl9))) (+ (i (l9 Itl9)) 1))
                  ;Define value of variable max at beginning of next iteration
                  (= (max (l9 (s Itl9))) (max (l19 Itl9)))
               )
            )
         )
         ;The loop-condition doesn't hold in the last iteration
         (not
            (< (i (l9 nl9)) alength)
         )
      )
      ;Define referenced terms denoting variable values at main_end
      (= (max main_end) (max (l9 nl9)))
   )
)

; Definition: Dense-increasing for i-l9
(assert
   (=
      Dense-increasing-i-l9
      (forall ((Itl9 Nat))
         (=>
            (Sub Itl9 nl9)
            (or
               (= (i (l9 (s Itl9))) (i (l9 Itl9)))
               (= (i (l9 (s Itl9))) (+ (i (l9 Itl9)) 1))
            )
         )
      )
   )
)

; Axiom: already-proven-lemma i-alength-equality-axiom
(assert
   (=>
      (and
         Dense-increasing-i-l9
         (<= (i (l9 zero)) alength)
      )
      (= (i (l9 nl9)) alength)
   )
)

; Axiom: user-axiom-0
(assert
   (<= 0 alength)
)

; Conjecture: find_max-conjecture-1
(assert-not
   (=>
      (and
         (<= 0 alength)
         (exists ((k Int))
            (and
               (<= 0 k)
               (< k alength)
               (<= 0 (a k))
            )
         )
      )
      (exists ((k Int))
         (and
            (<= 0 k)
            (< k alength)
            (= (a k) (max main_end))
         )
      )
   )
)

(check-sat)

