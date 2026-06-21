# AGENTS.md

**This project does not contain original code.** All source code in `src/btree/`
is extracted verbatim from the official Rust standard library
([rust-lang/rust](https://github.com/rust-lang/rust),
`library/alloc/src/collections/btree`). Internal crate paths like
`crate::collections::btree::*` are rewritten to `crate::btree::*` so the crate
compiles standalone.

- **Pull a new version:** `make pull-btree TAG=<version>`
- **Module root:** `src/btree/mod.rs` — expose as `pub mod btree;` in your crate root.
- **Nightly required:** `rust-toolchain.toml` pins to `nightly` for features
  like `allocator_api`, `core_intrinsics`, `dropck_eyepatch`, `extend_one`, etc.
- **Adaptation notes:** Not all `alloc` internals may resolve — some paths may
  need manual patching depending on the tag.

## Module architecture

| File | Purpose |
|---|---|
| `map.rs` | `BTreeMap<K, V, A>` — the primary ordered-map type with full API |
| `set.rs` | `BTreeSet<T>` — thin wrapper over `BTreeMap<T, SetValZST>` |
| `node.rs` | Internal node representation, `Root`, `NodeRef`, `Handle`, `marker` types |
| `navigate.rs` | `LeafRange`, `LazyLeafRange` — cursor-based tree traversal |
| `search.rs` | Binary search over node key arrays with `SearchBound` enum |
| `fix.rs` | Post-removal rebalancing — merges, steals, tree-height reduction |
| `remove.rs` | `remove_kv_tracking` — single key-value removal |
| `append.rs` | Bulk-building a tree from two sorted iterators via `MergeIterInner` |
| `split.rs` | `calc_split_length` and tree-split operations |
| `merge_iter.rs` | `MergeIterInner<I>` — fused-iterator merge for set operations |
| `borrow.rs` | `DormantMutRef<'a, T>` — safe stacked reborrowing pattern |
| `dedup_sorted_iter.rs` | Deduplicates consecutive equal keys during bulk build |
| `mem.rs` | Panic-safe `take_mut` / `replace` (aborts on panic mid-operation) |
| `set_val.rs` | `SetValZST` — zero-sized sentinel to distinguish set maps at the type level |
| `map/entry.rs` | `Entry`, `VacantEntry`, `OccupiedEntry`, `OccupiedError` |
| `set/entry.rs` | Entry API for `BTreeSet` |
| `map/tests.rs` | 2,589 lines of BTreeMap tests |
| `set/tests.rs` | 856 lines of BTreeSet tests |
| `node/tests.rs` | Node-level unit tests |
| `borrow/tests.rs` | `DormantMutRef` tests |

### Test infrastructure (`src/testing/`)

| File | Purpose |
|---|---|
| `crash_test.rs` | Property-based crash testing with injected panics to verify panic safety |
| `ord_chaos.rs` | Key wrapper that produces deliberately non-deterministic ordering |
| `rng.rs` | Deterministic PRNG seeded from the test function name |
| `macros.rs` | Shared test assertion helpers |

## Common modifications when pulling a new tag

1. **Crate-internal paths** — the `make pull-btree` script rewrites
   `crate::collections::btree::` → `crate::btree::` automatically.
2. **Missing `alloc` re-exports** — the stdlib relies on `alloc::` for `Vec`,
   `Box`, `Allocator`, etc. These are available via `std::alloc::` or
   `std::vec::` in this standalone crate.
3. **Stability attributes** — `#[stable]`, `#[unstable]`, `#[rustc_*]` gates
   are stripped during extraction since they don't apply outside the stdlib.
4. **Feature gates** — new unstable features may need to be added to the
   `#![feature(...)]` list in `src/lib.rs`.

## Running

```sh
cargo build     # requires nightly
cargo test      # runs all btree tests
```
