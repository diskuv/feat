type 'a enum =
  int -> 'a Seq.seq

let empty : 'a enum =
  fun _s ->
    Seq.empty

let zero =
  empty

let just (x : 'a) : 'a enum =
  fun s ->
    if s = 0 then Seq.singleton x else Seq.empty

let pay (enum : 'a enum) : 'a enum =
  fun s ->
    if s = 0 then Seq.empty else enum (s-1)

let sum (enum1 : 'a enum) (enum2 : 'a enum) : 'a enum =
  fun s ->
    Seq.sum (enum1 s) (enum2 s)

let ( ++ ) =
  sum

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
    Seq.bigsum (
      List.map (fun s1 ->
        let s2 = s - s1 in
        Seq.product (enum1 s1) (enum2 s2)
      ) (up 0 s)
    )

let ( ** ) =
  product

let balanced_product (enum1 : 'a enum) (enum2 : 'b enum) : ('a * 'b) enum =
  fun s ->
    if s mod 2 = 0 then
      let s = s / 2 in
      Seq.product (enum1 s) (enum2 s)
    else
      let s = s / 2 in
      Seq.sum
        (Seq.product (enum1 s) (enum2 (s+1)))
        (Seq.product (enum1 (s+1)) (enum2 s))

let ( -**- ) =
  balanced_product

let map (phi : 'a -> 'b) (enum : 'a enum) : 'b enum =
  fun s ->
    Seq.map phi (enum s)

let finite (xs : 'a list) : 'a enum =
  List.fold_left (++) zero (List.map just xs)
