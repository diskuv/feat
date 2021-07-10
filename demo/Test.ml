(* Module aliases if you want to swap out implementations without
   changing the rest of your code. See Feat.ml and FeatNum.ml for
   examples. *)
module Ifseq = Feat.IFSeq
module Enum = Feat.Enum
module Zseq = Z

open Printf
open Fix.Memoize.Int
open Enum

(* -------------------------------------------------------------------------- *)

(* A type of binary trees. *)

type tree =
  | Leaf
  | Node of int * tree * tree

let node (x, (t1, t2)) =
  Node (x, t1, t2)

(* -------------------------------------------------------------------------- *)

(* Enumerating binary trees. *)

let tree : tree enum =
  fix (fun tree ->
    just Leaf ++ pay (map node (just 0 ** tree ** tree))
  )

(* Enumerating weight-balanced binary trees. *)

let wb_tree : tree enum =
  fix (fun tree ->
    just Leaf ++ pay (map node (just 0 ** (tree *-* tree)))
  )

(* Enumerating lists of weight-balanced binary trees. *)

let list_wb_tree : tree list enum =
  list wb_tree

(* Enumerating binary trees with two elements in [0; 1]. *)

let elem : int enum =
  enum (Ifseq.up 0 2)

let etree : tree enum =
  fix (fun tree ->
    just Leaf ++ pay (map node (elem ** tree ** tree))
  )

(* -------------------------------------------------------------------------- *)

(* Testing a sequence. *)

open Ifseq

let rec subrange i j s accu =
  if i < j then
    let accu = get s i :: accu in
    subrange (Zseq.succ i) j s accu
  else
    List.rev accu

let subrange i j s =
  subrange i j s []

let range s =
  subrange Zseq.zero (length s) s

let test name s =
  printf "Testing %s...\n%!" name;
  (* Test [length]. *)
  printf "  Length: %s\n%!" (Zseq.to_string (length s));
  (* By calling [range s], test [get] at every index within range. *)
  assert (Zseq.equal (length s) (Zseq.of_int (List.length (range s))));
  printf "  Every random access succeeds.\n";
  (* Test [foreach]. We check that it produces the same elements as [get],
     in the same order, and that it produces neither too few nor too many
     elements. *)
  let i = ref Zseq.zero in
  foreach s (fun x1 ->
    assert (Zseq.lt !i (length s));
    let x2 = get s !i in
    assert (x1 = x2); (* element equality *)
    i := Zseq.succ !i
  );
  assert (Zseq.equal !i (length s));
  printf "  Iteration via foreach is consistent with random access.\n"

(* -------------------------------------------------------------------------- *)

(* Main. *)

let () =
  for s = 0 to 8 do
    test (sprintf "trees of size %d" s) (tree s);
    test (sprintf "balanced trees of size %d" s) (wb_tree s);
    test (sprintf "lists of balanced trees of size %d" s) (list_wb_tree s);
    test (sprintf "trees of size %d with elements in [0; 1]" s) (etree s);
  done
