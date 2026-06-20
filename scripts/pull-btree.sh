#!/usr/bin/env bash
set -euo pipefail

TAG="${1:-1.92.0}"

REPO_URL="https://github.com/rust-lang/rust.git"
CLONE_DIR="/tmp/rust-std-btree-clone"
DEST_DIR="src/btree"

echo "==> Pulling btree subtree from rust-lang/rust at tag $TAG"

rm -rf "$CLONE_DIR" "$DEST_DIR"

git clone --depth 1 --branch "$TAG" --single-branch \
    --filter=tree:0 --sparse \
    "$REPO_URL" "$CLONE_DIR" 2>/dev/null

git -C "$CLONE_DIR" sparse-checkout set --no-cone library/alloc/src/collections/btree
git -C "$CLONE_DIR" checkout

mkdir -p "$DEST_DIR"
cp -r "$CLONE_DIR/library/alloc/src/collections/btree/"* "$DEST_DIR/"

rm -rf "$CLONE_DIR"

echo "==> Adapting internal crate paths..."

case "$(uname -s)" in
    Darwin|*BSD)
        find "$DEST_DIR" -name '*.rs' -exec sed -i '' \
            's/crate::collections::btree::/crate::btree::/g' {} +
        ;;
    Linux)
        find "$DEST_DIR" -name '*.rs' -exec sed -i \
            's/crate::collections::btree::/crate::btree::/g' {} +
        ;;
esac

echo "==> Done! Btree source pulled to $DEST_DIR at tag $TAG"
