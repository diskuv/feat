open IFSeqSig

(* An implementation of the signature SEQ,
   instantiated with unbounded integers. *)

include IFSEQ with type index = Z.t

(* Iterated sum. *)
val bigsum: 'a seq list -> 'a seq

(* [sample m s k] is an explicit sequence of at most [m] elements extracted
   out of the implicit sequence [s], prepended in front of the existing
   sequence [k]. If [length s] at most [m], then all elements of [s] are
   produced. Otherwise, a random sample of [m] elements extracted out of
   [s] is produced. *)
val sample: int -> 'a seq -> 'a Seq.t -> 'a Seq.t
