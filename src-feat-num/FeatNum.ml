(******************************************************************************)
(*                                                                            *)
(*                                     Feat                                   *)
(*                                                                            *)
(*                        François Pottier, Inria Paris                       *)
(*                                                                            *)
(*  Copyright Inria. All rights reserved. This file is distributed under the  *)
(*  terms of the MIT license, as described in the file LICENSE.               *)
(******************************************************************************)

(**
  {1 Basics}
  
  Add ["feat-core"] and ["feat-num"] to your OPAM dependencies.

  Then:

  {[
    (* Use [Ifseq] to create your own implicit finite sequences backed by the
       [Num] package. *)
    module Zseq = FeatNum.Zseq
    module Ifseq = FeatCore.IFBigSeq.Make (Zseq) (FeatCore.RandomSig.Standard)

    (* Use [Enum] to create your own enumerations operating on the provided
       [Feat.IFSeq]. *)
    module Enum = Feat.Enum

    (* ----------------------- *)
    (* See demo/ in the source code for a complete example using Ifseq and
       Enum. *)
  ]}

  {1 Customization}
  
  {[
    (* Use [Ifseq] to create your own implicit finite sequences backed by the
       [Num] package with your own random number generator. *)
    module R : FeatCore.RandomSig.S = struct
        type t = ..
        let get_state () : t = ..
        let bits (state: t) : int = ..
        let int (state: t) (exclusive_upper_bound: int) : int = ..
    end
    module Zseq = FeatNum.Zseq
    module Ifseq = FeatCore.IFBigSeq.Make (Zseq) (R)

    (* Use [Enum] to create your own enumerations operating on sequences of your
       custom [Ifseq]. *)
    module Enum = FeatCore.EnumFunctor.Make (Ifseq)
  ]}

  There is another OPAM package [feat] that provides an alternative to [Num] for
  big numbers.
*)

(* Entry point to the [feat-num] package *)

open FeatCore
open Big_int

(** A big number implementation for [feat] with a [Num] backend *)
module Zseq : Bignum.S_EXTENDED with type t = big_int = struct
  exception Overflow

  type t = big_int
  let zero = zero_big_int
  let one = big_int_of_int 1
  let of_int = big_int_of_int
  let pred = pred_big_int
  let add = add_big_int
  let sub = sub_big_int
  let mul = mult_big_int
  let div_rem = quomod_big_int
  let equal = eq_big_int
  let lt = lt_big_int
  let to_int = try int_of_big_int with Failure _ -> raise Overflow
  let (lsl) = shift_left_big_int
  let geq = ge_big_int
  let (lor) = or_big_int
  let (/) = div_big_int
  let ( * ) = mult_big_int
  let (mod) = mod_big_int
  let leq = le_big_int
  let to_string = string_of_big_int
end
