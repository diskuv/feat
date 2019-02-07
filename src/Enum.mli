(* An enumeration of type ['a enum] can be loosely thought of as a set of
   values of type ['a], equipped with a notion of size. More precisely, it
   is a function of a size [s] to a subset of inhabitants of size [s],
   presented as a sequence. *)

(* We expose the fact that enumerations are functions, instead of making [enum]
   an abstract type, because this allows the user to make recursive definitions.
   It is up to the user to ensure that recursion is well-founded; as a rule of
   thumb, every recursive call must appear under [pay]. It is also up to the
   user to take precautions so that these functions have constant time
   complexity (beyond the cost of an initialization phase). This is typically
   achieved by using a memoizing fixed point combinator [fix] instead of
   ordinary recursive definitions. *)

type 'a enum =
  int -> 'a Seq.seq

(* [empty] is the empty enumeration. *)
val empty: 'a enum
val zero : 'a enum

(* The enumeration [just x] contains just the element [x], whose size is
   considered to be zero. *)
val just: 'a -> 'a enum

(* The enumeration [pay e] contains the same elements as [e],
   but their size is increased by one. *)
val pay: 'a enum -> 'a enum

(* [sum e1 e2] is the union of the enumerations [e1] and [e2]. It is up
   to the user to ensure that the sets [e1] and [e2] are disjoint. *)
val sum    : 'a enum -> 'a enum -> 'a enum
val ( ++ ) : 'a enum -> 'a enum -> 'a enum

(* [product e1 e2] is the Cartesian product of the enumerations
   [e1] and [e2]. *)
val product: 'a enum -> 'b enum -> ('a * 'b) enum
val ( ** ) : 'a enum -> 'b enum -> ('a * 'b) enum

(* [product e1 e2] is a subset of the Cartesian product [product e1 e2]
   where the sizes of the left-hand and right-hand pair components must
   differ by at most one. *)
val balanced_product: 'a enum -> 'b enum -> ('a * 'b) enum
val (-**-)          : 'a enum -> 'b enum -> ('a * 'b) enum

(* [map phi e] is the image of the enumeration [e] through the function [phi].
   It is up to the user to ensure that [phi] is injective. *)
val map: ('a -> 'b) -> 'a enum -> 'b enum

(* The enumeration [finite xs] contains the elements in the list [xs].
   They are considered to have size zero. *)
val finite: 'a list -> 'a enum