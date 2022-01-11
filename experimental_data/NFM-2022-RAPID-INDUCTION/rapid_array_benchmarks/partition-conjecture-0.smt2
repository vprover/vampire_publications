; main()
; {
;    blength = 0 @l16
;    clength = 0 @l18
;    i = 0 @l20
;    while (i < alength) @l21
;    {
;       if (a[i] >= 0) @l23
;       {
;          b[blength] = a[i] @l25
;          blength = (blength) + (1) @l26
;       }
;       else
;       {
;          c[clength] = a[i] @l30
;          clength = (clength) + (1) @l31
;       }
;       i = (i) + (1) @l33
;    }
; }
; 

(set-logic UFDTLIA)

(declare-nat Nat zero s p Sub)
(declare-sort Time 0)
(declare-sort Trace 0)
(declare-fun a (Int) Int)
(declare-const-var alength Int)
(declare-program-var b (Time Int) Int)
(declare-program-var blength (Time) Int)
(declare-program-var c (Time Int) Int)
(declare-program-var clength (Time) Int)
(declare-program-var i (Time) Int)
(declare-time-point l16 Time)
(declare-time-point l18 Time)
(declare-time-point l20 Time)
(declare-time-point l21 (Nat) Time)
(declare-final-loop-count nl21 Nat)
(declare-time-point l23 (Nat) Time)
(declare-time-point l25 (Nat) Time)
(declare-time-point l26 (Nat) Time)
(declare-time-point l30 (Nat) Time)
(declare-time-point l31 (Nat) Time)
(declare-time-point l33 (Nat) Time)
(declare-time-point main_end Time)
(declare-const t1 Trace)
(declare-lemma-predicate Dense-increasing-i-l21 () Bool)

; Axiom: target symbol definitions for symbol elimination
(assert
   true
)

; Axiom: Semantics of function main
(assert
   (and
      ;Loop at location l21
      (and
         ;Define variable values at beginning of loop
         (and
            (= (i (l21 zero)) 0)
            (= (blength (l21 zero)) 0)
            (= (clength (l21 zero)) 0)
         )
         ;The loop-condition holds always before the last iteration
         (forall ((Itl21 Nat))
            (=>
               (Sub Itl21 nl21)
               (< (i (l21 Itl21)) alength)
            )
         )
         ;Semantics of the body
         (forall ((Itl21 Nat))
            (=>
               (Sub Itl21 nl21)
               (and
                  ;Semantics of IfElse at location l23
                  (and
                     ;Semantics of left branch
                     (=>
                        (>= (a (i (l21 Itl21))) 0)
                        (and
                           ;Update array variable b at location l25
                           (and
                              (= (b (l26 Itl21) (blength (l21 Itl21))) (a (i (l21 Itl21))))
                              (forall ((pos Int))
                                 (=>
                                    (not
                                       (= pos (blength (l21 Itl21)))
                                    )
                                    (= (b (l26 Itl21) pos) (b (l21 Itl21) pos))
                                 )
                              )
                           )
                           (forall ((pos Int))
                              (= (b (l33 Itl21) pos) (b (l26 Itl21) pos))
                           )
                           (= (clength (l33 Itl21)) (clength (l21 Itl21)))
                           (forall ((pos Int))
                              (= (c (l33 Itl21) pos) (c (l21 Itl21) pos))
                           )
                           (= (blength (l33 Itl21)) (+ (blength (l21 Itl21)) 1))
                        )
                     )
                     ;Semantics of right branch
                     (=>
                        (not
                           (>= (a (i (l21 Itl21))) 0)
                        )
                        (and
                           ;Update array variable c at location l30
                           (and
                              (= (c (l31 Itl21) (clength (l21 Itl21))) (a (i (l21 Itl21))))
                              (forall ((pos Int))
                                 (=>
                                    (not
                                       (= pos (clength (l21 Itl21)))
                                    )
                                    (= (c (l31 Itl21) pos) (c (l21 Itl21) pos))
                                 )
                              )
                           )
                           (forall ((pos Int))
                              (= (b (l33 Itl21) pos) (b (l21 Itl21) pos))
                           )
                           (= (clength (l33 Itl21)) (+ (clength (l21 Itl21)) 1))
                           (forall ((pos Int))
                              (= (c (l33 Itl21) pos) (c (l31 Itl21) pos))
                           )
                           (= (blength (l33 Itl21)) (blength (l21 Itl21)))
                        )
                     )
                  )
                  ;Define value of variable i at beginning of next iteration
                  (= (i (l21 (s Itl21))) (+ (i (l21 Itl21)) 1))
                  ;Define value of array variable b at beginning of next iteration
                  (forall ((pos Int))
                     (= (b (l21 (s Itl21)) pos) (b (l33 Itl21) pos))
                  )
                  ;Define value of variable blength at beginning of next iteration
                  (= (blength (l21 (s Itl21))) (blength (l33 Itl21)))
                  ;Define value of array variable c at beginning of next iteration
                  (forall ((pos Int))
                     (= (c (l21 (s Itl21)) pos) (c (l33 Itl21) pos))
                  )
                  ;Define value of variable clength at beginning of next iteration
                  (= (clength (l21 (s Itl21))) (clength (l33 Itl21)))
               )
            )
         )
         ;The loop-condition doesn't hold in the last iteration
         (not
            (< (i (l21 nl21)) alength)
         )
      )
      ;Define referenced terms denoting variable values at main_end
      (and
         (= (clength main_end) (clength (l21 nl21)))
         (= (blength main_end) (blength (l21 nl21)))
         (forall ((pos Int))
            (= (c main_end pos) (c (l21 nl21) pos))
         )
         (forall ((pos Int))
            (= (b main_end pos) (b (l21 nl21) pos))
         )
      )
   )
)

; Definition: Dense-increasing for i-l21
(assert
   (=
      Dense-increasing-i-l21
      (forall ((Itl21 Nat))
         (=>
            (Sub Itl21 nl21)
            (or
               (= (i (l21 (s Itl21))) (i (l21 Itl21)))
               (= (i (l21 (s Itl21))) (+ (i (l21 Itl21)) 1))
            )
         )
      )
   )
)

; Axiom: already-proven-lemma i-alength-equality-axiom
(assert
   (=>
      (and
         Dense-increasing-i-l21
         (<= (i (l21 zero)) alength)
      )
      (= (i (l21 nl21)) alength)
   )
)

; Axiom: user-axiom-0
(assert
   (<= 0 alength)
)

; Conjecture: partition-conjecture-0
(assert-not
   (forall ((pos Int))
      (=>
         (and
            (<= 0 alength)
            (<= 0 pos)
            (< pos (blength main_end))
         )
         (<= 0 (b main_end pos))
      )
   )
)

(check-sat)

