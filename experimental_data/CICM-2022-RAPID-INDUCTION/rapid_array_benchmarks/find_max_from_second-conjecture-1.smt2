; main()
; {
;    i = 1 @l9
;    max = a[0] @l10
;    while (i < alength) @l11
;    {
;       if (a[i] > max) @l13
;       {
;          max = a[i] @l15
;       }
;       else
;       {
;          skip @l19
;       }
;       i = (i) + (1) @l21
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
(declare-time-point l9 Time)
(declare-time-point l10 Time)
(declare-time-point l11 (Nat) Time)
(declare-final-loop-count nl11 Nat)
(declare-time-point l13 (Nat) Time)
(declare-time-point l15 (Nat) Time)
(declare-time-point l19 (Nat) Time)
(declare-time-point l21 (Nat) Time)
(declare-time-point main_end Time)
(declare-const t1 Trace)
(declare-lemma-predicate Dense-increasing-i-l11 () Bool)

; Axiom: target symbol definitions for symbol elimination
(assert
   true
)

; Axiom: Semantics of function main
(assert
   (and
      ;Loop at location l11
      (and
         ;Define variable values at beginning of loop
         (and
            (= (i (l11 zero)) 1)
            (= (max (l11 zero)) (a 0))
         )
         ;The loop-condition holds always before the last iteration
         (forall ((Itl11 Nat))
            (=>
               (Sub Itl11 nl11)
               (< (i (l11 Itl11)) alength)
            )
         )
         ;Semantics of the body
         (forall ((Itl11 Nat))
            (=>
               (Sub Itl11 nl11)
               (and
                  ;Semantics of IfElse at location l13
                  (and
                     ;Semantics of left branch
                     (=>
                        (> (a (i (l11 Itl11))) (max (l11 Itl11)))
                        (= (max (l21 Itl11)) (a (i (l11 Itl11))))
                     )
                     ;Semantics of right branch
                     (=>
                        (not
                           (> (a (i (l11 Itl11))) (max (l11 Itl11)))
                        )
                        (= (max (l21 Itl11)) (max (l11 Itl11)))
                     )
                  )
                  ;Define value of variable i at beginning of next iteration
                  (= (i (l11 (s Itl11))) (+ (i (l11 Itl11)) 1))
                  ;Define value of variable max at beginning of next iteration
                  (= (max (l11 (s Itl11))) (max (l21 Itl11)))
               )
            )
         )
         ;The loop-condition doesn't hold in the last iteration
         (not
            (< (i (l11 nl11)) alength)
         )
      )
      ;Define referenced terms denoting variable values at main_end
      (= (max main_end) (max (l11 nl11)))
   )
)

; Definition: Dense-increasing for i-l11
(assert
   (=
      Dense-increasing-i-l11
      (forall ((Itl11 Nat))
         (=>
            (Sub Itl11 nl11)
            (or
               (= (i (l11 (s Itl11))) (i (l11 Itl11)))
               (= (i (l11 (s Itl11))) (+ (i (l11 Itl11)) 1))
            )
         )
      )
   )
)

; Axiom: already-proven-lemma i-alength-equality-axiom
(assert
   (=>
      (and
         Dense-increasing-i-l11
         (<= (i (l11 zero)) alength)
      )
      (= (i (l11 nl11)) alength)
   )
)

; Axiom: user-axiom-0
(assert
   (<= 1 alength)
)

; Conjecture: find_max_from_second-conjecture-1
(assert-not
   (=>
      (<= 1 alength)
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

