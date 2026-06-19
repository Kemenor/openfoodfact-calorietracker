#!/usr/bin/env python3
"""Publish built region packs + a manifest to the Hugging Face dataset, in a
single commit.

Usage: HF_TOKEN=... python publish.py [out_dir] [version]
  version defaults to today's date (YYYYMMDD).

Reads regions.json for code/name/tag. The HF dataset is PUBLIC, so the app
downloads anonymously; only this upload needs the write token.
"""
import datetime
import hashlib
import json
import os
import sqlite3
import sys

from huggingface_hub import CommitOperationAdd, HfApi

REPO = os.environ.get("HF_REPO", "Knabberfuchs/offline-packs")
HERE = os.path.dirname(os.path.abspath(__file__))
OUTDIR = sys.argv[1] if len(sys.argv) > 1 else os.path.join(HERE, "out")
VERSION = sys.argv[2] if len(sys.argv) > 2 else datetime.date.today().strftime("%Y%m%d")
REGIONS = json.load(open(os.path.join(HERE, "regions.json")))

api = HfApi(token=os.environ["HF_TOKEN"])
api.create_repo(REPO, repo_type="dataset", exist_ok=True, private=False)


def sha256(path):
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


ops, regions_meta = [], []
for r in REGIONS:
    cc = r["code"]
    gz = os.path.join(OUTDIR, f"region_{cc}.sqlite.gz")
    sq = os.path.join(OUTDIR, f"region_{cc}.sqlite")
    if not os.path.exists(gz):
        print(f"skip {cc}: no pack at {gz}")
        continue
    count = sqlite3.connect(sq).execute("SELECT count(*) FROM products").fetchone()[0]
    sha = sha256(gz)
    # Content-addressed version: changes only when the pack's bytes change, so a
    # weekly rebuild of unchanged data doesn't trip "update available". The path
    # carries the hash too, so each version has a stable (cache-safe) URL.
    version = sha[:16]
    path_in_repo = f"packs/{cc}/{version}/region_{cc}.sqlite.gz"
    ops.append(CommitOperationAdd(path_in_repo=path_in_repo, path_or_fileobj=gz))
    regions_meta.append({
        "code": cc, "name": r["name"], "country_tag": r["tag"],
        "version": version, "products": count,
        "file": path_in_repo, "size": os.path.getsize(gz),
        "sha256": sha, "deltas": [],
    })
    print(f"staged {cc}: {count} products, {os.path.getsize(gz)} bytes")

manifest = {
    "schema": 1,
    "updatedAt": datetime.datetime.now(datetime.timezone.utc).isoformat(),
    "baseUrl": f"https://huggingface.co/datasets/{REPO}/resolve/main",
    "attribution": "Product data from Open Food Facts (https://openfoodfacts.org), ODbL.",
    "regions": regions_meta,
}
mpath = os.path.join(OUTDIR, "manifest.json")
json.dump(manifest, open(mpath, "w"), indent=2)
ops.append(CommitOperationAdd(path_in_repo="manifest.json", path_or_fileobj=mpath))

print(f"\ncommitting {len(regions_meta)} packs + manifest in one commit ...")
api.create_commit(
    repo_id=REPO, repo_type="dataset", operations=ops,
    commit_message=f"Publish {len(regions_meta)} regions ({VERSION})",
)
print(f"Published {len(regions_meta)} region(s) to {REPO} (version {VERSION}).")
