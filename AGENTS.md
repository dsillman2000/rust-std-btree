# AGENTS.md

This project extracts the `library/alloc/src/collections/btree` subtree from
`rust-lang/rust` into `src/btree/`. Internal crate paths like
`crate::collections::btree::*` are rewritten to `crate::btree::*`.

- **Pull a new version:** `make pull-btree TAG=<version>`
- **Module root:** `src/btree/mod.rs` — expose as `pub mod btree;` in your crate root.
- **Adaptation notes:** Not all `alloc` internals may resolve — some paths may
  need manual patching depending on the tag.
