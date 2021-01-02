## TO DO

* We probably want a lazy variant of the combinator `**`, at the level
  of sequences and/or enumerations, so that if the left-hand argument
  produces an empty sequence, then the right-hand argument is not
  evaluated.

* Write some documentation.

* Test. Check that `length`, `get`, `foreach` and `to_seq` are consistent.

* Test. Check that `foreach` is faster than iterated `get`.

* Try implementing a balancing scheme for `Sum`?

* Define a combinator `smap` where the user function `f` has access to the
  size of the data.
