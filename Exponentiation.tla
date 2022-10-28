--------------------------- MODULE Exponentiation ---------------------------

EXTENDS Integers, Sequences, TLC

CONSTANT mSet, nSet
ASSUME /\ mSet \subseteq Int
       /\ nSet \subseteq Int

(*********

--algorithm Exponentiation {
  variables m \in mSet, n \in nSet, e = 1, i = n ;
  {
    assert IF m = 0 THEN n > 0
                    ELSE n >= 0 ;

    while (i > 0) {
      e := e * m ;
      i := i - 1 ;      
    } ;
    
    assert e = m ^ n ;
  }
}

********)
\* BEGIN TRANSLATION (chksum(pcal) = "f788f2e4" /\ chksum(tla) = "584fc297")
VARIABLES m, n, e, i, pc

vars == << m, n, e, i, pc >>

Init == (* Global variables *)
        /\ m \in mSet
        /\ n \in nSet
        /\ e = 1
        /\ i = n
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ Assert(IF m = 0 THEN n > 0
                            ELSE n >= 0, 
                   "Failure of assertion at line 14, column 5.")
         /\ pc' = "Lbl_2"
         /\ UNCHANGED << m, n, e, i >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF i > 0
               THEN /\ e' = e * m
                    /\ i' = i - 1
                    /\ pc' = "Lbl_2"
               ELSE /\ Assert(e = m ^ n, 
                              "Failure of assertion at line 22, column 5.")
                    /\ pc' = "Done"
                    /\ UNCHANGED << e, i >>
         /\ UNCHANGED << m, n >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Fri Oct 28 09:43:38 IST 2022 by nija
\* Created Fri Oct 14 16:19:01 IST 2022 by nija
