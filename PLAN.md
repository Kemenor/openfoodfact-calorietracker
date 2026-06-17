# Calorie Tracker — Plan

An ad-free, no-subscription, no-popup calorie tracker. Android-first (Flutter, so
iOS stays possible). Local-first data, optional Health Connect sync, serverless
recipe sharing, ZIP backup/restore.

## Decisions (from planning)

| Area | Decision |
|---|---|
| Framework | **Flutter** (official OpenFoodFacts Dart pkg, `mobile_scanner`, `health`, `drift`) |
| Food data | **OpenFoodFacts** (barcode) + **USDA FoodData Central** (produce/generic search) + **manual custom foods** |
| Offline | **Live API + local cache** now; optional opt-in **regional offline packs** in Settings later |
| Day model | Entries grouped by **meal** (Breakfast/Lunch/Dinner/Snacks) **with a flat-list toggle** |
| Targets | **Per-weekday** optional calorie target (training days can be higher) + default; counter is per-day |
| Recipes | Create from a meal or selected products; reusable |
| Recipe sharing | **QR** (self-contained, calories+macros, serverless) + **"Share as file"** fallback for big/full-micro recipes |
| Health sync | **Health Connect, write-only, opt-in** (energy + macros + micros). Fast-follow after core logging |
| Backup | **ZIP** = SQLite snapshot (lossless) + JSON export (portable) + CSV of entries; manifest carries schema version |

## Architecture

- **Offline-first.** Everything reads/writes the local SQLite DB. Network is only for
  *resolving new foods* (barcode scan / text search), and results are cached locally.
- **Repository with layered sources** for food lookup:
  `local cache → OpenFoodFacts → USDA FDC → (manual entry prompt)`.
- **History is immutable to food edits.** Each logged entry stores a *snapshot* of the
  food's nutrition + grams, so re-caching or editing a food never rewrites past days.
- Stack: `drift` (SQLite + migrations), `riverpod` (state), `mobile_scanner` (barcode),
  `openfoodfacts` (OFF), `http` (USDA), `health` (Health Connect), `archive`/`share_plus`
  (ZIP backup + share sheet), `qr_flutter` + `mobile_scanner` (QR encode/decode).

### Data model (draft)

- **foods** — `id, source(off|usda|custom), barcode?, name, brand?, locale,
  serving_g?, serving_label?, kcal_100g, protein_100g, carb_100g, fat_100g,
  fiber_100g?, sugar_100g?, sodium_100g?, micros(json)?, updated_at`
- **entries** — `id, date, meal_type, food_ref?, grams, + snapshot(name, kcal,
  protein, carb, fat, micros), created_at`  *(snapshot = stable history)*
- **targets** — `weekday(0-6) → kcal, protein?, carb?, fat?` + a `default` row
- **recipes** / **recipe_items** — recipe header + ingredient snapshots (food + grams)
- **settings** — key/value (locale, health-sync on/off, default view, etc.)

### Quantity model
Grams are primary ("enter gramm"). When the source provides a serving size, offer
quick-pick chips (e.g. "1 serving = 30 g") that just fill the grams field.

## Rate limiting & caching (critical)

API limits force search to be **local-first, network-on-pause** — never per-keystroke:

- OFF product read (barcode): **15 req/min/IP** · OFF search: **10 req/min/IP**
  (OFF explicitly: *don't use for search-as-you-type*) · USDA FDC: **~1000 req/hr**
  with a free key (DEMO_KEY only 30/hr).

Strategy:
1. **Search-as-you-type hits the local cache only** (instant, zero network). The
   `foods` table is the live search index.
2. **Network search is deferred + explicit:** fire an online query only after the user
   pauses (debounce ≥ 600 ms) *and* local results are thin, or when they tap
   "Search online". Results are merged into the cache.
3. **Client-side token-bucket rate limiter per source** wraps every API call: OFF-search
   bucket (10/min), OFF-product bucket (15/min), USDA bucket. Requests queue when the
   bucket is empty; UI shows "searching…/rate-limited, retrying in Ns" instead of erroring.
4. **Aggressive caching:** every fetched product and search hit is stored in `foods`
   with `updated_at`; barcodes cache effectively forever (background refresh only if
   stale). Repeat scans/searches never touch the network.
5. **Barcode scan = single product read**, which is the cheap 15/min endpoint — but it's
   cache-checked first, so a re-scan is free.

## Roadmap (phased)

- **Phase 0 — Scaffold:** Flutter project, drift schema + migrations, settings, theming.
- **Phase 1 — Usable MVP:** barcode scan + text search (OFF/USDA) + manual food;
  log grams into a day; day view (meal grouping + flat toggle) with running total;
  per-weekday target with remaining/over readout; custom foods; local cache.
- **Phase 2 — Recipes & sharing:** build recipe from meal/products; QR share
  (macros, self-contained) + file share fallback; import via QR scan / file.
- **Phase 3 — Health Connect:** opt-in write-only push of energy/macros/micros.
- **Phase 4 — Backup:** ZIP export (SQLite + JSON + CSV) and import with migration.
- **Phase 5 — Offline packs (optional):** DuckDB preprocessing of the OFF Parquet
  (5.74 GB worldwide) into a compact regional SQLite pack (~30–300 MB), downloadable
  from Settings, with live API fallback for misses.

## Prerequisites / open dev details
- Flutter SDK not yet installed on this machine — needed before Phase 0.
- USDA FoodData Central needs a **free API key** (sign up at fdc.nal.usda.gov; DEMO_KEY
  is rate-limited).
- Default locale → device locale (German for CH); OFF returns multilingual names.
- App name/branding: TBD (placeholder until you pick one).
