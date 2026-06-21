TAG ?= 1.92.0

.PHONY: pull-btree build test clean

pull-btree:
	scripts/pull-btree.sh $(TAG)

build: pull-btree
	cargo build

test:
	cargo test

clean:
	rm -rf src/btree
	cargo clean
