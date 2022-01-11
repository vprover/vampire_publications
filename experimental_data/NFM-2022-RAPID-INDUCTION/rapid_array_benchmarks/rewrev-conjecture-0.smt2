; main()
; {
;    val2 = 3 @l6
;    val1 = 7 @l7
;    low = 2 @l8
;    i = (alength) - (2) @l10
;    while (i >= (0) - (1)) @l12
;    {
;       if (i >= 0) @l14
;       {
;          a[i] = val1 @l16
;       }
;       else
;       {
;          skip @l18
;       }
;       a[(i) + (1)] = val2 @l20
;       i = (i) - (1) @l21
;    }
; }
; 

(set-logic UFDTLIA)

(declare-nat Nat zero s p Sub)
(declare-sort Time 0)
(declare-sort Trace 0)
(declare-program-var i (Time) Int)
(declare-program-var a (Time Int) Int)
(declare-const-var alength Int)
(declare-const-var val2 Int)
(declare-const-var val1 Int)
(declare-const-var low Int)
(declare-time-point l6 Time)
(declare-time-point l7 Time)
(declare-time-point l8 Time)
(declare-time-point l10 Time)
(declare-time-point l12 (Nat) Time)
(declare-final-loop-count nl12 Nat)
(declare-time-point l14 (Nat) Time)
(declare-time-point l16 (Nat) Time)
(declare-time-point l18 (Nat) Time)
(declare-time-point l20 (Nat) Time)
(declare-time-point l21 (Nat) Time)
(declare-time-point main_end Time)
(declare-const t1 Trace)
(declare-lemma-predicate Dense-decreasing-i-l12 () Bool)

; Axiom: target symbol definitions for symbol elimination
(assert
   true
)

; Axiom: Semantics of function main
(assert
   (and
      ;Update variable low at location l8
      (= low 2)
      ;Loop at location l12
      (and
         ;Define variable values at beginning of loop
         (= (i (l12 zero)) (- alength 2))
         ;The loop-condition holds always before the last iteration
         (forall ((Itl12 Nat))
            (=>
               (Sub Itl12 nl12)
               (>= (i (l12 Itl12)) (- 0 1))
            )
         )
         ;Semantics of the body
         (forall ((Itl12 Nat))
            (=>
               (Sub Itl12 nl12)
               (and
                  ;Semantics of IfElse at location l14
                  (and
                     ;Semantics of left branch
                     (=>
                        (>= (i (l12 Itl12)) 0)
                        ;Update array variable a at location l16
                        (and
                           (= (a (l20 Itl12) (i (l12 Itl12))) 7)
                           (forall ((pos Int))
                              (=>
                                 (not
                                    (= pos (i (l12 Itl12)))
                                 )
                                 (= (a (l20 Itl12) pos) (a (l12 Itl12) pos))
                              )
                           )
                        )
                     )
                     ;Semantics of right branch
                     (=>
                        (not
                           (>= (i (l12 Itl12)) 0)
                        )
                        (forall ((pos Int))
                           (= (a (l20 Itl12) pos) (a (l12 Itl12) pos))
                        )
                     )
                  )
                  ;Update array variable a at location l20
                  (and
                     (= (a (l21 Itl12) (+ (i (l12 Itl12)) 1)) 3)
                     (forall ((pos Int))
                        (=>
                           (not
                              (= pos (+ (i (l12 Itl12)) 1))
                           )
                           (= (a (l21 Itl12) pos) (a (l20 Itl12) pos))
                        )
                     )
                  )
                  ;Define value of variable i at beginning of next iteration
                  (= (i (l12 (s Itl12))) (- (i (l12 Itl12)) 1))
                  ;Define value of array variable a at beginning of next iteration
                  (forall ((pos Int))
                     (= (a (l12 (s Itl12)) pos) (a (l21 Itl12) pos))
                  )
               )
            )
         )
         ;The loop-condition doesn't hold in the last iteration
         (not
            (>= (i (l12 nl12)) (- 0 1))
         )
      )
      ;Define referenced terms denoting variable values at main_end
      (forall ((pos Int))
         (= (a main_end pos) (a (l12 nl12) pos))
      )
   )
)

; Definition: Dense-decreasing for i-l12
(assert
   (=
      Dense-decreasing-i-l12
      (forall ((Itl12 Nat))
         (=>
            (Sub Itl12 nl12)
            (or
               (= (i (l12 (s Itl12))) (i (l12 Itl12)))
               (= (i (l12 (s Itl12))) (- (i (l12 Itl12)) 1))
            )
         )
      )
   )
)

; Axiom: already-proven-lemma i-0-1-equality-axiom
(assert
   (=>
      (and
         Dense-decreasing-i-l12
         (>= (i (l12 zero)) (- (- 0 1) 1))
      )
      (= (i (l12 nl12)) (- 0 1))
   )
)

; Conjecture: user-conjecture-0
(assert-not
   (forall ((pos Int))
      (=>
         (and
            (>= alength 0)
            (<= 0 pos)
            (< pos alength)
         )
         (>= (a main_end pos) low)
      )
   )
)

(check-sat)

