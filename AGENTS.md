# AGENTS.md

**This project does not contain original code.** All source code in `src/btree/`
is extracted verbatim from the official Rust standard library
([rust-lang/rust](https://github.com/rust-lang/rust),
`library/alloc/src/collections/btree`). Internal crate paths like
`crate::collections::btree::*` are rewritten to `crate::btree::*` so the crate
compiles standalone.

- **Pull a new version:** `make pull-btree TAG=<version>`
- **Module root:** `src/btree/mod.rs` — expose as `pub mod btree;` in your crate root.
- **Adaptation notes:** Not all `alloc` internals may resolve — some paths may
  need manual patching depending on the tag.
