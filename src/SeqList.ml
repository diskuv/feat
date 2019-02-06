(* This is naive implementation of sequences as lists. *)

(* No need to use unbounded integers here, since we will run out of time and
   memory before an overflow occurs. *)

type index =
  int

type 'a seq =
  'a list

let empty =
  []

let singleton x =
  [x]

let sum =
  (@)

let ( ++ ) =
  sum

let product (s1 : 'a seq) (s2 : 'b seq) : ('a * 'b) seq =
  List.flatten (s1 |> List.map (fun x1 ->
    s2 |> List.map (fun x2 ->
      (x1, x2)
    )
  ))

let ( ** ) =
  product

let map =
  List.map

let length =
  List.length

let get =
  List.nth

let foreach s k =
  List.iter k s
