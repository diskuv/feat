# CHANGES

## 202107XX

- Introduce new OCaml packages `feat-core` which is all of the non-Zarith
  code of the `feat` package, and `feat-num` which adds `Num` based big
  integers to `feat-core`
- Introduce `IFBigSeqSig` and `EnumFunctor` to allow non-IFSeqSyn
  implementations of implicit finite sequences to be used
  with enumerations.
- Use big integer `Z` comparison functions rather than rely on
  big integer polymorphic comparison only implemented in
  Zarith. In general allow non-Zarith implementations of big integers
  especially for users who have license conflicts with GNU MP.
- Introduce `RandomSig` to allow alternative random number
  generators to be used.
