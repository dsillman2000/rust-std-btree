# rust-std-btree

Verbatim extraction of the Rust standard library's BTree implementation.

**I do not own any of the contents.** All source code in `src/btree/` is
extracted from the [rust-lang/rust](https://github.com/rust-lang/rust)
repository (`library/alloc/src/collections/btree`) and is licensed under MIT
(or Apache 2.0 at your option), the same as Rust itself.

The long-term goal is to fork and adapt this codebase for use cases outside
the standard library — for example, a PyO3 binding exposing a Python
`BTreeMap` type, or a disk-managed B-tree backed by a file.

## Project structure

```
src/
  lib.rs                          Crate root — enables nightly features, exports `pub mod btree`
  btree/
    mod.rs                        Module root — re-exports all submodules
    map.rs                        BTreeMap<K, V> — the primary map (3,430 lines)
    set.rs                        BTreeSet<T> — set wrapper around BTreeMap (2,428 lines)
    node.rs                       Node data structures, tree invariants, root ops (1,883 lines)
    navigate.rs                   Tree navigation and leaf range iteration (788 lines)
    search.rs                     Binary search over node keys (288 lines)
    fix.rs                        Tree rebalancing — merges and rotations (185 lines)
    append.rs                     Bulk append from two sorted iterators (112 lines)
    remove.rs                     Key-value removal (98 lines)
    merge_iter.rs                 Iterator that merges two sorted streams (98 lines)
    split.rs                      Tree split operations (79 lines)
    borrow.rs                     DormantMutRef — safe reborrowing for complex control flow (69 lines)
    dedup_sorted_iter.rs          Deduplicating sorted-key iterator (49 lines)
    mem.rs                        Panic-safe take_mut / replace helpers (33 lines)
    set_val.rs                    SetValZST — ZST marker distinguishing BTreeSet internals (8 lines)
    map/
      entry.rs                    Entry API — in-place key lookups (Vacant / Occupied)
      tests.rs                    BTreeMap property-based tests
    set/
      entry.rs                    Entry API for BTreeSet
      tests.rs                    BTreeSet tests
    node/
      tests.rs                    Node-level unit tests
    borrow/
      tests.rs                    Borrow tests
  testing/
    mod.rs                        Test harness root
    crash_test.rs                 Crash-test framework for panic-safety coverage
    ord_chaos.rs                  Non-deterministic ordering test (deliberately unstable sort)
    rng.rs                        Deterministic RNG seeded from test context
    macros.rs                     Shared test macros
```

## Design notes

- **B-tree invariants:** Every internal node holds between `B-1` and `2B-1`
  keys (`B = 6`). The root may hold as few as 0 keys. All leaves sit at the
  same depth.
- **Node representation:** `node.rs` uses unsafe code to simulate dependent
  types — Rust lacks polymorphic recursion, so leaf and internal nodes share
  the same struct but differ in which fields are populated. The `marker` module
  encodes node type at the type level.
- **`DormantMutRef`:** `borrow.rs` models stacked mutable borrows too complex
  for the borrow checker to follow, while preserving uniqueness guarantees.
- **Search:** `search.rs` implements binary search over node keys using
  `SearchBound`, an enum richer than `Bound` that distinguishes inclusive,
  exclusive, and unconditional bounds for range queries.
- **Rebalancing:** `fix.rs` walks up the tree after removals, merging underfull
  nodes with siblings or stealing a key, shrinking height only when the root
  empties.
- **Crash testing:** `crash_test.rs` runs operations with injected panics to
  verify the structure is not left inconsistent mid-operation.

## Requirements

Nightly Rust (uses `allocator_api`, `core_intrinsics`, `dropck_eyepatch`, and
other unstable features).

```sh
cargo build
cargo test
make pull-btree TAG=1.92.0    # extract a different stdlib version
```

See `AGENTS.md` for development notes.
