(* The default implementation of the signature SEQ is based on IFSeqSyn,
   instantiated with the unbounded integers provided by [zarith]. *)

include IFSeqSyn.Make(Z)

let bigsum ss =
  List.fold_left sum zero ss
