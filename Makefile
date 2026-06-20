TAG ?= 1.92.0

.PHONY: pull-btree build clean

pull-btree:
	scripts/pull-btree.sh $(TAG)

build: pull-btree
	cargo build

clean:
	rm -rf src/btree
	cargo clean
