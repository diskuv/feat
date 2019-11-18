open IFSeqSig

(* An implementation of the signature SEQ,
   instantiated with unbounded integers. *)

include IFSEQ with type index = Z.t

(* Iterated sum. *)
val bigsum: 'a seq list -> 'a seq
