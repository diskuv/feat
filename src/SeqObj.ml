(* This is an implementation of sequences as objects, that is, records of
   closures. This is the implementation style proposed in the Feat paper
   by Duregard et al. *)

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

(* A sequence stores its length (which is computed at construction time)
   as well as [get] and [foreach] methods. *)

type 'a seq = {
  length : index;
  get    : index -> 'a;
  foreach: ('a -> unit) -> unit;
}

let is_empty s =
  Z.equal s.length Z.zero

let out_of_bounds () =
  failwith "Index is out of bounds."

let empty =
  let length = Z.zero
  and get _ = out_of_bounds()
  and foreach _k = () in
  { length; get; foreach }

let singleton x =
  let length = Z.one
  and get i = if Z.equal i Z.zero then x else out_of_bounds()
  and foreach k = k x in
  { length; get; foreach }

let sum s1 s2 =
  let length =
    Z.add s1.length s2.length
  and get i =
    if Z.lt i s1.length then s1.get i
    else s2.get (Z.sub i s1.length)
  and foreach k =
    s1.foreach k;
    s2.foreach k
  in
  { length; get; foreach }

let sum s1 s2 =
  (* To save space and reduce access time, we recognize an empty sequence as a
     neutral element for concatenation. *)
  if is_empty s1 then
    s2
  else if is_empty s2 then
    s1
  else
    sum s1 s2

let ( ++ ) =
  sum

let product s1 s2 =
  let length =
    Z.mul s1.length s2.length
  and get i =
    let q, r = Z.div_rem i s2.length in
    s1.get q, s2.get r
  and foreach k =
    s1.foreach (fun x1 ->
      s2.foreach (fun x2 ->
        k (x1, x2)
      )
    )
  in
  { length; get; foreach }

let product s1 s2 =
  (* To save space, we recognize an empty sequence as an absorbing element for
     product. This also eliminates the risk of a division by zero in the above
     code, which could arise if the user attempts an out-of-bounds access. *)
  if is_empty s1 || is_empty s2 then
    empty
  else
    product s1 s2

let ( ** ) =
  product

let map phi s =
  let length = s.length
  and get i = phi (s.get i)
  and foreach k = s.foreach (fun x -> k (phi x)) in
  { length; get; foreach }

let map phi s =
  (* To save space, we recognize an empty sequence as a fixed point for map. *)
  if is_empty s then
    empty
  else
    map phi s

let length s =
  s.length

let get s i =
  s.get i

let foreach s k =
  s.foreach k

end
