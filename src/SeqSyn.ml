(* This is an implementation of sequences as syntax, that is, algebraic data
   structures. This style should be more efficient than the one used in
   SeqObj, because fewer memory blocks are allocated (one block per construct
   instead of typically three) and because it opens the door to rebalancing
   schemes -- e.g., trees of binary [Sum] nodes can be balanced. *)

(* In this implementation, the constructors have time complexity O(1),
   under the assumption that the arithmetic operations provided by [Z]
   cost O(1) as well. *)

module Make (Z : sig
  type t
  val zero: t
  val one: t
  val add: t -> t -> t
  val sub: t -> t -> t
  val mul: t -> t -> t
  val div_rem: t -> t -> t * t
  val equal: t -> t -> bool
  val lt: t -> t -> bool
end) = struct

type index =
  Z.t

(* The data constructors [Sum], [Product], [Map] are annotated with the
   length of the sequence. *)

(* The children of [Sum], [Product], [Map] cannot be [Empty]. *)

type _ seq =
| Empty    : 'a seq
| Singleton: 'a -> 'a seq
| Sum      : index * 'a seq * 'a seq -> 'a seq
| Product  : index * 'a seq * 'b seq -> ('a * 'b) seq
| Map      : index * ('a -> 'b) * 'a seq -> 'b seq

let is_empty (type a) (s : a seq) : bool =
  match s with
  | Empty ->
      true
  | Singleton _ ->
      false
  | Sum _ ->
      false
  | Product _ ->
      false
  | Map _ ->
      false

let length (type a) (s : a seq) : index =
  match s with
  | Empty ->
      Z.zero
  | Singleton _ ->
      Z.one
  | Sum (length, _, _) ->
      length
  | Product (length, _, _) ->
      length
  | Map (length, _, _) ->
      length

let out_of_bounds () =
  failwith "Index is out of bounds."

let empty =
  Empty

let singleton x =
  Singleton x

let sum s1 s2 =
  if is_empty s1 then
    s2
  else if is_empty s2 then
    s1
  else
    let length = Z.add (length s1) (length s2) in
    Sum (length, s1, s2)

let ( ++ ) =
  sum

let product s1 s2 =
  if is_empty s1 || is_empty s2 then
    empty
  else
    let length = Z.mul (length s1) (length s2) in
    Product (length, s1, s2)

let ( ** ) =
  product

let map phi s =
  if is_empty s then
    empty
  else
    Map (length s, phi, s)

let rec get : type a . a seq -> index -> a =
  fun s i ->
    match s with
    | Empty ->
        out_of_bounds()
    | Singleton x ->
        if Z.equal i Z.zero then x else out_of_bounds()
    | Sum (_, s1, s2) ->
        let n1 = length s1 in
        if Z.lt i n1 then get s1 i
        else get s2 (Z.sub i n1)
    | Product (_, s1, s2) ->
        let q, r = Z.div_rem i (length s2) in
        get s1 q, get s2 r
    | Map (_, phi, s) ->
        phi (get s i)

let rec foreach : type a . a seq -> (a -> unit) -> unit =
  fun s k ->
    match s with
    | Empty ->
        ()
    | Singleton x ->
        k x
    | Sum (_, s1, s2) ->
        foreach s1 k;
        foreach s2 k
    | Product (_, s1, s2) ->
        foreach s1 (fun x1 ->
          foreach s2 (fun x2 ->
            k (x1, x2)
          )
        )
    | Map (_, phi, s) ->
        foreach s (fun x -> k (phi x))

end