open IFSeqSig

(* An implementation of the signature SEQ,
   instantiated with unbounded integers. *)

include IFSEQ with type index = Z.t

(* Iterated sum. *)
val bigsum: 'a seq list -> 'a seq

(* [sample m s] is an explicit sequence of at most [m] elements extracted
   out of the implicit sequence [s]. If [length s] at most [m], then all
   elements of [s] are produced. Otherwise, a random sample of [m] elements
   is extracted out of [s]. *)
val sample: int -> 'a seq -> 'a Seq.t
