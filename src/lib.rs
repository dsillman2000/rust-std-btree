#![feature(allocator_api)]
#![feature(core_intrinsics)]
#![feature(dropck_eyepatch)]
#![feature(exact_size_is_empty)]
#![feature(extend_one)]
#![feature(hasher_prefixfree_extras)]
#![feature(map_try_insert)]
#![feature(slice_ptr_get)]

#[cfg(test)]
pub(crate) mod testing;

pub mod btree;
