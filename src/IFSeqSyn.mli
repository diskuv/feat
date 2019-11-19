open IFSeqSig

(* This is an implementation of implicit finite sequences as syntax,
   that is, algebraic data structures. *)

(* In this implementation, the constructors have time complexity O(1),
   under the assumption that the arithmetic operations provided by [Z]
   cost O(1) as well. *)

module Make (Z : sig
  type t
  val zero: t
  val one: t
  val of_int: int -> t
  val pred: t -> t
  val add: t -> t -> t
  val sub: t -> t -> t
  val mul: t -> t -> t
  val div_rem: t -> t -> t * t
  val equal: t -> t -> bool
  val lt: t -> t -> bool
  exception Overflow
  val to_int: t -> int
end)
: IFSEQ with type index = Z.t