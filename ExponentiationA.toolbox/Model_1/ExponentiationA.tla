-------------------------- MODULE ExponentiationA --------------------------
EXTENDS Integers, Sequences, TLC

CONSTANT mnSet
ASSUME /\ mnSet \subseteq Seq(Int)
       /\ \A mn \in mnSet : Len(mn) = 2
       
(*********

--algorithm ExponentiationBetter {
  variables mn \in mnSet, m = mn[1], n = mn[2], e = 1, i = 0 ;
  {
    assert IF m = 0 THEN n > 0
                    ELSE n >= 0 ;

    i := n ;
    while (i > 0) {
      e := e * m ;
      i := i - 1 ;      
    } ;
    
    assert e = m ^ n ;
  }
}

********)
\* BEGIN TRANSLATION (chksum(pcal) = "1965e04b" /\ chksum(tla) = "734b4219")
VARIABLES mn, m, n, e, i, pc

vars == << mn, m, n, e, i, pc >>

Init == (* Global variables *)
        /\ mn \in mnSet
        /\ m = mn[1]
        /\ n = mn[2]
        /\ e = 1
        /\ i = 0
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ Assert(IF m = 0 THEN n > 0
                            ELSE n >= 0, 
                   "Failure of assertion at line 13, column 5.")
         /\ i' = n
         /\ pc' = "Lbl_2"
         /\ UNCHANGED << mn, m, n, e >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF i > 0
               THEN /\ e' = e * m
                    /\ i' = i - 1
                    /\ pc' = "Lbl_2"
               ELSE /\ Assert(e = m ^ n, 
                              "Failure of assertion at line 22, column 5.")
                    /\ pc' = "Done"
                    /\ UNCHANGED << e, i >>
         /\ UNCHANGED << mn, m, n >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Fri Oct 28 11:49:57 IST 2022 by nija
\* Created Fri Oct 28 11:49:39 IST 2022 by nija
