; main()
; {
;    b[0] = a[0] @l8
;    blength = 1 @l9
;    i = 1 @l11
;    m = 0 @l12
;    while (i < alength) @l13
;    {
;       if (a[i] > a[m]) @l15
;       {
;          b[blength] = a[i] @l17
;          blength = (blength) + (1) @l18
;          m = i @l19
;       }
;       else
;       {
;          skip @l23
;       }
;       i = (i) + (1) @l25
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
(declare-program-var i (Time) Int)
(declare-program-var m (Time) Int)
(declare-time-point l8 Time)
(declare-time-point l9 Time)
(declare-time-point l11 Time)
(declare-time-point l12 Time)
(declare-time-point l13 (Nat) Time)
(declare-final-loop-count nl13 Nat)
(declare-time-point l15 (Nat) Time)
(declare-time-point l17 (Nat) Time)
(declare-time-point l18 (Nat) Time)
(declare-time-point l19 (Nat) Time)
(declare-time-point l23 (Nat) Time)
(declare-time-point l25 (Nat) Time)
(declare-time-point main_end Time)
(declare-const t1 Trace)
(declare-lemma-predicate Dense-increasing-i-l13 () Bool)

; Axiom: target symbol definitions for symbol elimination
(assert
   true
)

; Axiom: Semantics of function main
(assert
   (and
      ;Update array variable b at location l8
      (and
         (= (b l9 0) (a 0))
         (forall ((pos Int))
            (=>
               (not
                  (= pos 0)
               )
               (= (b l9 pos) (b l8 pos))
            )
         )
      )
      ;Loop at location l13
      (and
         ;Define variable values at beginning of loop
         (and
            (= (i (l13 zero)) 1)
            (forall ((pos Int))
               (= (b (l13 zero) pos) (b l9 pos))
            )
            (= (blength (l13 zero)) 1)
            (= (m (l13 zero)) 0)
         )
         ;The loop-condition holds always before the last iteration
         (forall ((Itl13 Nat))
            (=>
               (Sub Itl13 nl13)
               (< (i (l13 Itl13)) alength)
            )
         )
         ;Semantics of the body
         (forall ((Itl13 Nat))
            (=>
               (Sub Itl13 nl13)
               (and
                  ;Semantics of IfElse at location l15
                  (and
                     ;Semantics of left branch
                     (=>
                        (> (a (i (l13 Itl13))) (a (m (l13 Itl13))))
                        (and
                           ;Update array variable b at location l17
                           (and
                              (= (b (l18 Itl13) (blength (l13 Itl13))) (a (i (l13 Itl13))))
                              (forall ((pos Int))
                                 (=>
                                    (not
                                       (= pos (blength (l13 Itl13)))
                                    )
                                    (= (b (l18 Itl13) pos) (b (l13 Itl13) pos))
                                 )
                              )
                           )
                           (forall ((pos Int))
                              (= (b (l25 Itl13) pos) (b (l18 Itl13) pos))
                           )
                           (= (blength (l25 Itl13)) (+ (blength (l13 Itl13)) 1))
                           (= (m (l25 Itl13)) (i (l13 Itl13)))
                        )
                     )
                     ;Semantics of right branch
                     (=>
                        (not
                           (> (a (i (l13 Itl13))) (a (m (l13 Itl13))))
                        )
                        (and
                           (forall ((pos Int))
                              (= (b (l25 Itl13) pos) (b (l13 Itl13) pos))
                           )
                           (= (blength (l25 Itl13)) (blength (l13 Itl13)))
                           (= (m (l25 Itl13)) (m (l13 Itl13)))
                        )
                     )
                  )
                  ;Define value of variable i at beginning of next iteration
                  (= (i (l13 (s Itl13))) (+ (i (l13 Itl13)) 1))
                  ;Define value of array variable b at beginning of next iteration
                  (forall ((pos Int))
                     (= (b (l13 (s Itl13)) pos) (b (l25 Itl13) pos))
                  )
                  ;Define value of variable blength at beginning of next iteration
                  (= (blength (l13 (s Itl13))) (blength (l25 Itl13)))
                  ;Define value of variable m at beginning of next iteration
                  (= (m (l13 (s Itl13))) (m (l25 Itl13)))
               )
            )
         )
         ;The loop-condition doesn't hold in the last iteration
         (not
            (< (i (l13 nl13)) alength)
         )
      )
      ;Define referenced terms denoting variable values at main_end
      (and
         (= (blength main_end) (blength (l13 nl13)))
         (forall ((pos Int))
            (= (b main_end pos) (b (l13 nl13) pos))
         )
      )
   )
)

; Definition: Dense-increasing for i-l13
(assert
   (=
      Dense-increasing-i-l13
      (forall ((Itl13 Nat))
         (=>
            (Sub Itl13 nl13)
            (or
               (= (i (l13 (s Itl13))) (i (l13 Itl13)))
               (= (i (l13 (s Itl13))) (+ (i (l13 Itl13)) 1))
            )
         )
      )
   )
)

; Axiom: already-proven-lemma i-alength-equality-axiom
(assert
   (=>
      (and
         Dense-increasing-i-l13
         (<= (i (l13 zero)) alength)
      )
      (= (i (l13 nl13)) alength)
   )
)

; Axiom: user-axiom-0
(assert
   (<= 1 alength)
)

; Conjecture: find_max_local-conjecture-1
(assert-not
   (forall ((j Int))
      (exists ((k Int))
         (=>
            (and
               (<= 1 alength)
               (<= 0 j)
               (< j (blength main_end))
            )
            (and
               (<= 0 k)
               (< k alength)
               (= (b main_end j) (a k))
            )
         )
      )
   )
)

(check-sat)

