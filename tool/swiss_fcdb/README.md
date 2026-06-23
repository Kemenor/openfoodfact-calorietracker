# Swiss Food Composition Database → bundled catalog

Builds `assets/swiss_foods.csv.gz` (the multilingual whole-food catalog seeded
on first launch) from the **Swiss Food Composition Database**, published by the
**Federal Food Safety and Veterinary Office (FSVO/BLV)**, naehrwertdaten.ch.

This replaced the old English-only USDA generic-foods layer: the Swiss DB ships
curated names in **DE / FR / IT / EN** (exactly the app's UI locales) plus
per-language synonyms, so search and display work natively in every language —
no machine translation needed.

## License / attribution

Free for commercial use "subject to acknowledgment of the source." The app
credits it in Settings → About. Do **not** strip that credit.
See <https://naehrwertdaten.ch/en/informations/>.

## Source files

The DB is published as one Excel file per language, all sharing a stable numeric
`ID` column (the join key). Place them next to this script as `de.xlsx`,
`fr.xlsx`, `it.xlsx`, `en.xlsx`. They are git-ignored (large binaries).

Current generation (**2025/07**, 1190 generic foods, all four languages). The
download links live behind each language's `/downloads/` page on
`naehrwertdaten.ch` (geo-restricted to CH); the files themselves are served from
the BLV foodcase host:

```sh
B=https://webapp.prod.blv.foodcase-services.com/wp-content/uploads/2025/07
curl -L -o en.xlsx "$B/Swiss_food_composition_database.xlsx"
curl -L -o de.xlsx "$B/Schweizer_Nahrwertdatenbank.xlsx"
curl -L -o fr.xlsx "$B/Base_de_donnees_suisse_des_valeurs_nutritives.xlsx"
curl -L -o it.xlsx "$B/Banca_dati_svizzera_dei_valori_nutritivi.xlsx"
```

Always fetch all four from the **same** generation so the `ID` join lines up.
To find newer links later, scrape each `/<lang>/downloads/` page for the
`.xlsx` href.

## Build

```sh
pip install --user openpyxl
python3 tool/swiss_fcdb/build.py      # writes ../../assets/swiss_foods.csv.gz
```

Then bump `swissDatasetVersion` in `lib/data/sources/swiss_seed.dart` so existing
installs re-import. CSV columns: `id, name_en, name_de, name_fr, name_it,
kcal100, protein100, carb100, fat100, fiber100, sugar100, satfat100,
sodium_mg100, search_text`. English is the canonical/fallback `name`; the others
override per locale. `search_text` is every language's name + synonyms,
lower-cased, so search is language-agnostic.

**To add Italian later:** drop `it.xlsx` in, re-run `build.py`, bump the version.
The ID join slots the Italian names straight in — no code changes.
