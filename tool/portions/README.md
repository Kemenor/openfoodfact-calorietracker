# Natural-portion weights

Curated "1 piece weighs N grams" data for common whole foods, so the log sheet
can offer a one-tap natural portion (e.g. *1 medium · 300 g* for a cucumber)
instead of forcing a gram guess.

## How it works

`portions.csv` maps an **exact** Swiss FCDB English name to a portion:

```
name_en,unit,grams
"Cucumber, raw",medium,300
"Egg, raw",piece,50
```

- **Exact-name match** (not fuzzy) so a weight never lands on "Apple pie".
- `unit` is one of a small localized vocabulary — see `portionUnitLabel` in
  `lib/domain/portion_units.dart` and the `portionUnit*` ARB keys:
  `piece, medium, slice, clove, stalk, handful`.
- `grams` is the typical weight of one such portion.

`tool/swiss_fcdb/build.py` joins this onto the catalog and writes two extra
columns (`serving_g`, `serving_unit`) into `assets/swiss_foods.csv.gz`;
`swiss_seed.dart` loads them into `Foods.servingG` / `Foods.servingLabel`.

## Gram weights

Typical edible-portion weights informed by **USDA FoodData Central** standard
reference portions (public domain). Piece weights vary (a "medium" is a range),
so these are convenient starting values the user can adjust — not precise.

## Extending

Add rows to `portions.csv` (use names exactly as they appear in the catalog —
`name_en`), re-run `tool/swiss_fcdb/build.py`, and bump `swissDatasetVersion`
in `swiss_seed.dart`. To introduce a new `unit`, add it to `portionUnitLabel`
and the `portionUnit*` ARB keys (en/de/fr/it).

This is an initial set (~44 foods: produce, eggs, nuts, bread). Densities for
liquids (volume → grams) are a planned follow-up.
