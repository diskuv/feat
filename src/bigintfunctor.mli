(******************************************************************************)
(*                                                                            *)
(*                                     Feat                                   *)
(*                                                                            *)
(*                        François Pottier, Inria Paris                       *)
(*                                                                            *)
(*  Copyright Inria. All rights reserved. This file is distributed under the  *)
(*  terms of the MIT license, as described in the file LICENSE.               *)
(******************************************************************************)

[@@@ocaml.warning "-67"]

(* Uniform random generation of large integers. *)

module Make (Z : Bignum.S_EXTENDED) (R : RandomSig.S) : sig
    val random: Z.t -> Z.t
end