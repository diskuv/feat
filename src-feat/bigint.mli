(******************************************************************************)
(*                                                                            *)
(*                                     Feat                                   *)
(*                                                                            *)
(*                        François Pottier, Inria Paris                       *)
(*                                                                            *)
(*  Copyright Inria. All rights reserved. This file is distributed under the  *)
(*  terms of the MIT license, as described in the file LICENSE.               *)
(******************************************************************************)

(** Uniform random generation of large integers using the pseudo-random number
    generator of {!Random.State} and big numbers from [Zarith]. *)
val random: Z.t -> Z.t
