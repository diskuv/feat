(******************************************************************************)
(*                                                                            *)
(*                                     Feat                                   *)
(*                                                                            *)
(*                        François Pottier, Inria Paris                       *)
(*                                                                            *)
(*  Copyright Inria. All rights reserved. This file is distributed under the  *)
(*  terms of the MIT license, as described in the file LICENSE.               *)
(******************************************************************************)

(** Signature for big numbers satisfied by [Zarith] and adaptable to the older,
    slower but license friendly [Num] package. *)
module type S =
  sig
    type t
    val zero : t
    val one : t
    val of_int : int -> t
    val pred : t -> t
    val add : t -> t -> t
    val sub : t -> t -> t
    val mul : t -> t -> t
    val div_rem : t -> t -> t * t
    val equal : t -> t -> bool
    val lt : t -> t -> bool
    exception Overflow
    val to_int : t -> int

  end

(** Functions for the parts of [Feat] that require more bignum support than {!S} *)
module type S_EXTENDED = sig
  include S

  val (lsl): t -> int -> t
  (** Bit-wise shift to the left [shift_left]. *)

  val geq: t -> t -> bool
  (** Greater than or equal. *)

  val (lor): t -> t -> t
  (** Bit-wise logical inclusive or [logor]. *)

  val (/): t -> t -> t
  (** Truncated division [div]. *)

  val ( * ): t -> t -> t
  (** Multiplication [mul]. *)

  val (mod): t -> t -> t
  (** Remainder [rem]. *)

  val leq: t -> t -> bool
  (** Less than or equal. *)

  val to_string: t -> string
  (** Gives a human-readable, decimal string representation of the argument. *)
end
