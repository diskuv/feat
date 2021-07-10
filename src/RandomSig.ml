(******************************************************************************)
(*                                                                            *)
(*                                     Feat                                   *)
(*                                                                            *)
(*                        François Pottier, Inria Paris                       *)
(*                                                                            *)
(*  Copyright Inria. All rights reserved. This file is distributed under the  *)
(*  terms of the MIT license, as described in the file LICENSE.               *)
(******************************************************************************)

(* 2021-07-10. Authored by Jonah Beckford, Diskuv, Inc, and distributed under
   the MIT license. *)

(** The signature of a random number generator that is compatible with {!Random.State}. *)
module type S = sig
  type t
  (** The type of random number generator. *)

  val get_state : unit -> t
  (** Return the current state of the generator. *)

  val bits : t -> int
  (** Return 30 random bits in a nonnegative integer. *)

  val int : t -> int -> int
  (** [int bound] returns a random integer between 0 (inclusive)
     and [bound] (exclusive).  [bound] must be greater than 0 and less
     than 2{^30}. *)
end

(** The OCaml {!Random.State} pseudo-random number generator. *)
module Standard : S = struct
   type t = Random.State.t
   let get_state = Random.get_state
   let bits = Random.State.bits
   let int = Random.State.int
end
