(* The default implementation of the signature SEQ is based on IFSeqSyn,
   instantiated with the unbounded integers provided by [zarith]. *)

include IFSeqSyn.Make(Z)

(* Iterated sum. *)

let bigsum ss =
  List.fold_left sum zero ss

(* For some reason, [Z.random] does not exist. *)
(* For some reason, [Random.int] stops working at [2^30]. *)
(* This is troublesome. *)

let random_bigint (n : Z.t) : Z.t =
  let open Z in
  if n < one lsl 30 then
    Z.of_int (Random.int (Z.to_int n))
  else
    failwith "Can't sample over more than 2^30 elements."
      (* TEMPORARY really unsatisfactory! *)

(* Extract a randomly chosen sample of [m] elements out of a sequence [s]. *)

(* We do not protect against repetitions, as they are unlikely when [s] is
   long. *)

let rec sample (m : int) (s : 'a seq) (k : 'a Seq.t) : 'a Seq.t =
  if m > 0 then
    fun () ->
      let i = random_bigint (length s) in
      let x = get s i in
      Seq.Cons (x, sample (m - 1) s k)
  else
    k

(* If the sequence [s] is short enough, then produce all of its elements;
   otherwise produce a randomly chosen sample, as above. *)

let sample (m : int) (s : 'a seq) (k : 'a Seq.t) : 'a Seq.t =
  if length s <= Z.of_int m then to_seq s k else sample m s k
