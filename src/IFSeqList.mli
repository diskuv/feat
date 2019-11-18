(* This is a naive implementation of finite sequences as lists. *)

open IFSeqSig

include IFSEQ with type index = int
               and type 'a seq = 'a list
