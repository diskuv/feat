(******************************************************************************)
(*                                                                            *)
(*                                     Feat                                   *)
(*                                                                            *)
(*                        François Pottier, Inria Paris                       *)
(*                                                                            *)
(*  Copyright Inria. All rights reserved. This file is distributed under the  *)
(*  terms of the MIT license, as described in the file LICENSE.               *)
(******************************************************************************)

(* Entry point to the [feat] package *)

(**
  {1 Basics}
  
  Add ["feat-core"] and ["feat"] to your OPAM dependencies.

  Then:

  {[
    (* Use [Ifseq] to create your own implicit finite sequences backed by the
       [Zarith] package. *)
    module Ifseq = Feat.IFSeq
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
       [Zarith] package with your own random number generator. *)
    module R : RandomSig.S = struct
        type t = ..
        let get_state () : t = ..
        let bits (state: t) : int = ..
        let int (state: t) (exclusive_upper_bound: int) : int = ..
    end
    module Ifseq = FeatCore.IFBigSeq.Make (Z) (R)

    (* Use [Enum] to create your own enumerations operating on sequences of your
       custom [Ifseq]. *)
    module Enum = FeatCore.EnumFunctor.Make (Ifseq)
  ]}

  There is another OPAM package [feat-num] that provides an alternative to [Zarith] for big numbers.
*)

(* These modules must exist at the toplevel for compatibility with version 20201231.
   In a theoretical world only the non-FeatCore modules should be exported, and users should
   directly depend on FeatCore. But it is already released, so maintaining backwards
   compatibility is important!
 *)
module Enum = Enum
module IFSeq = IFSeq
module IFSeqList = FeatCore.IFSeqList
module IFSeqObj = FeatCore.IFSeqObj
module IFSeqSig = FeatCore.IFSeqSig
module IFSeqSyn = FeatCore.IFSeqSyn
module Bigint = Bigint
