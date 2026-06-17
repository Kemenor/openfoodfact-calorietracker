#!/usr/bin/env bash
# Build one per-country OFF pack: <country_tag> <country_code> <out_dir> [parquet_src]
#   e.g. build_pack.sh en:switzerland ch out/ .cache/food.parquet
# Produces <out_dir>/region_<cc>.sqlite(.gz) with a products table + FTS5 index,
# and prints row count + gzip size + sha256.
set -euo pipefail

TAG="$1"; CC="$2"; OUTDIR="$3"
SRC="${4:-https://huggingface.co/datasets/openfoodfacts/product-database/resolve/main/food.parquet}"
DIR="$(cd "$(dirname "$0")" && pwd)"
OUT="$OUTDIR/region_${CC}.sqlite"

mkdir -p "$OUTDIR"
rm -f "$OUT" "$OUT.gz"

echo "[$CC] extracting from $(basename "$SRC") ..."
sed "s|__SRC__|${SRC//&/\\&}|g; s|__COUNTRY_TAG__|${TAG}|g; s|__OUT__|${OUT}|g" \
  "$DIR/build_region.sql.tmpl" | duckdb

echo "[$CC] dedup + index + FTS5 ..."
N=$(python3 "$DIR/finalize_pack.py" "$OUT")
gzip -9 -k -f "$OUT"
SHA=$(sha256sum "$OUT.gz" | cut -d' ' -f1)
echo "[$CC] rows=$N  sqlite=$(du -h "$OUT" | cut -f1)  gz=$(du -h "$OUT.gz" | cut -f1)  sha256=$SHA"
