(******************************************************************************)
(*                                                                            *)
(*                                     Feat                                   *)
(*                                                                            *)
(*                        François Pottier, Inria Paris                       *)
(*                                                                            *)
(*  Copyright Inria. All rights reserved. This file is distributed under the  *)
(*  terms of the MIT license, as described in the file LICENSE.               *)
(******************************************************************************)

(* -------------------------------------------------------------------------- *)

include EnumFunctorIntf

module Make (Ifseq : IFBigSeqSig.IFBIGSEQ) : S with module Ifseq = Ifseq = struct
  module Ifseq = Ifseq

  (* Core combinators. *)

  type 'a enum =
    int -> 'a Ifseq.seq

  let empty : 'a enum =
    fun _s ->
      Ifseq.empty

  let zero =
    empty

  let enum (xs : 'a Ifseq.seq) : 'a enum =
    fun s ->
      if s = 0 then xs else Ifseq.empty

  let just (x : 'a) : 'a enum =
    (* enum (Ifseq.singleton x) *)
    fun s ->
      if s = 0 then Ifseq.singleton x else Ifseq.empty

  let pay (enum : 'a enum) : 'a enum =
    fun s ->
      if s = 0 then Ifseq.empty else enum (s-1)

  let sum (enum1 : 'a enum) (enum2 : 'a enum) : 'a enum =
    fun s ->
      Ifseq.sum (enum1 s) (enum2 s)

  let ( ++ ) =
    sum

  let exists (xs : 'a list) (enum : 'a -> 'b enum) : 'b enum =
    fun s ->
      Ifseq.exists xs (fun x -> enum x s)

  (* [up i j] is the list of the integers of [i] included up to [j] included. *)

  let rec up i j =
    if i <= j then
      i :: up (i + 1) j
    else
      []

  (* This definition of [product] may seem slightly inefficient, as it builds
    intermediate lists, but this is essentially irrelevant when it is used
    in the definition of a memoized function. The overhead is paid only once. *)

  let product (enum1 : 'a enum) (enum2 : 'b enum) : ('a * 'b) enum =
    fun s ->
      Ifseq.bigsum (
        List.map (fun s1 ->
          let s2 = s - s1 in
          Ifseq.product (enum1 s1) (enum2 s2)
        ) (up 0 s)
      )

  let ( ** ) =
    product

  let balanced_product (enum1 : 'a enum) (enum2 : 'b enum) : ('a * 'b) enum =
    fun s ->
      if s mod 2 = 0 then
        let s = s / 2 in
        Ifseq.product (enum1 s) (enum2 s)
      else
        let s = s / 2 in
        Ifseq.sum
          (Ifseq.product (enum1 s) (enum2 (s+1)))
          (Ifseq.product (enum1 (s+1)) (enum2 s))

  let ( *-* ) =
    balanced_product

  let map (phi : 'a -> 'b) (enum : 'a enum) : 'b enum =
    fun s ->
      Ifseq.map phi (enum s)

  (* -------------------------------------------------------------------------- *)

  (* Convenience functions. *)

  let finite (xs : 'a list) : 'a enum =
    List.fold_left (++) zero (List.map just xs)

  let bool : bool enum =
    just false ++ just true
    (* also: [finite [false; true]] *)

  let list (elem : 'a enum) : 'a list enum =
    let cons (x, xs) = x :: xs in
    Fix.Memoize.Int.fix (fun list ->
      just [] ++ pay (map cons (elem ** list))
    )

  let dlist fix elem =
    let cons x xs = x :: xs in
    fix (fun dlist env ->
      just [] ++ pay (
        exists (elem env) (fun (x, env') ->
          map (cons x) (dlist env')
        )
      )
    )

  (* -------------------------------------------------------------------------- *)

  (* Sampling. *)

  let rec sample m e i j k =
    if i < j then
      Ifseq.sample m (e i) (fun () -> sample m e (i + 1) j k ())
    else
      k

end