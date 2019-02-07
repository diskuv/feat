(* The default implementation of the signature SEQ is based on SeqSyn,
   instantiated with the unbounded integers provided by [zarith]. *)

include SeqSyn.Make(Z)

let bigsum ss =
  List.fold_left sum zero ss
