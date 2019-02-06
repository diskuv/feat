open SeqSig

(* An implementation of the signature SEQ,
   instantiated with unbounded integers. *)

include SEQ with type index = Z.t
