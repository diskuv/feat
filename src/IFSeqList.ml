(* No need to use unbounded integers here, since we will run out of time and
   memory before an overflow occurs. *)

type index =
  int

type 'a seq =
  'a list

let empty =
  []

let zero =
  empty

let singleton x =
  [x]

let one =
  singleton

let rev =
  List.rev

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

let rec up i j =
  if i < j then
    i :: up (i + 1) j
  else
    []

let length =
  List.length

let get =
  List.nth

let foreach s k =
  List.iter k s

let rec to_seq xs =
  (* this is [Seq.of_list] *)
  fun () ->
    match xs with
    | [] ->
        Seq.Nil
    | x :: xs ->
        Seq.Cons (x, to_seq xs)