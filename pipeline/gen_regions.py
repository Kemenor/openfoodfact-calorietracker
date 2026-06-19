#!/usr/bin/env python3
"""Generate regions.json from the OFF parquet: every country with at least
REGION_MIN_PRODUCTS products, mapped to an ISO 3166-1 alpha-2 code. Display
names come from the OFF slug (the common English name, so search works);
pycountry supplies the code. Non-country tags (world, EU, …) are excluded.

Usage: OFF_PARQUET=.cache/food.parquet python gen_regions.py
"""
import json
import os

import duckdb
import pycountry

HERE = os.path.dirname(os.path.abspath(__file__))
SRC = os.environ.get("OFF_PARQUET", os.path.join(HERE, ".cache", "food.parquet"))
THRESHOLD = int(os.environ.get("REGION_MIN_PRODUCTS", "1000"))

EXCLUDE = {"en:world", "en:european-union", "en:unknown", "en:europe"}

# OFF slug -> (iso2, friendly name), where pycountry misses or the slug is ugly.
OVERRIDES = {
    "en:russia": ("ru", "Russia"),
    "en:turkey": ("tr", "Turkey"),
    "en:czech-republic": ("cz", "Czech Republic"),
    "en:south-korea": ("kr", "South Korea"),
    "en:north-korea": ("kp", "North Korea"),
    "en:vietnam": ("vn", "Vietnam"),
    "en:ivory-coast": ("ci", "Côte d'Ivoire"),
    "en:cote-d-ivoire": ("ci", "Côte d'Ivoire"),
    "en:reunion": ("re", "Réunion"),
    "en:democratic-republic-of-the-congo": ("cd", "DR Congo"),
    "en:republic-of-the-congo": ("cg", "Congo"),
    "en:taiwan": ("tw", "Taiwan"),
    "en:iran": ("ir", "Iran"),
    "en:syria": ("sy", "Syria"),
    "en:laos": ("la", "Laos"),
    "en:moldova": ("md", "Moldova"),
    "en:bolivia": ("bo", "Bolivia"),
    "en:venezuela": ("ve", "Venezuela"),
    "en:tanzania": ("tz", "Tanzania"),
    "en:brunei": ("bn", "Brunei"),
    "en:cape-verde": ("cv", "Cape Verde"),
    "en:swaziland": ("sz", "Eswatini"),
    "en:macedonia": ("mk", "North Macedonia"),
    "en:palestine": ("ps", "Palestine"),
}


def main():
    rows = duckdb.execute(
        f"SELECT tag, count(*) n FROM (SELECT unnest(countries_tags) tag "
        f"FROM read_parquet('{SRC}')) WHERE tag LIKE 'en:%' "
        f"GROUP BY tag HAVING n >= {THRESHOLD} ORDER BY n DESC"
    ).fetchall()

    regions, seen, skipped = [], set(), []
    for tag, n in rows:
        if tag in EXCLUDE:
            continue
        if tag in OVERRIDES:
            code, name = OVERRIDES[tag]
        else:
            name = tag[3:].replace("-", " ").title()
            try:
                code = pycountry.countries.lookup(name).alpha_2.lower()
            except LookupError:
                skipped.append((tag, n))
                continue
        if code in seen:
            continue
        seen.add(code)
        regions.append({"code": code, "name": name, "tag": tag, "products": n})

    with open(os.path.join(HERE, "regions.json"), "w") as f:
        json.dump(regions, f, indent=2, ensure_ascii=False)
        f.write("\n")
    print(f"{len(regions)} regions (threshold {THRESHOLD}).")
    if skipped:
        print("UNMAPPED (add to OVERRIDES):")
        for tag, n in skipped:
            print(f"  {tag}  ({n})")


if __name__ == "__main__":
    main()
