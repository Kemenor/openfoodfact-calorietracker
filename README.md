# Knabberfuchs 🦊

An ad-free, no-subscription, no-popup calorie tracker for Android. Scan a barcode, search,
snap a photo of your meal, or just type a name and the calories. Your data stays on your phone.

> Built because every popular tracker nags with paywalls. This one doesn't.

🌐 [knabberfuchs.ch](https://knabberfuchs.ch)

## What it does

- 📷 **Barcode scan** — Open Food Facts products. Not in the database? Add it yourself (scan the
  nutrition label) and it's saved for next time.
- 🔎 **Fast local search** — Open Food Facts + the curated **Swiss Food Composition Database**,
  plus your own custom foods.
- ⚡ **Quick add** — already know the number? Log “Lasagna · 816 kcal” in a couple of taps.
- 📸 **AI meal recognition** — snap a photo and get the dish + an estimated portion. Runs
  **on-device by default** (no account, no cloud); optionally use your own free **Google Gemini**
  key for sharper results with full macros.
- 🖼️ **Meal from a photo** — photograph a printed ingredient list; on-device OCR turns it into a
  meal to log.
- 📅 **Day by day** — meals group automatically as you add; running total and macros.
- 🎯 **Per-weekday targets** — a minimum, a maximum, or both (training days can differ).
- 📖 **Recipes** — build once, log a portion to any day (broken back into its real ingredients),
  share by **QR or image**, import by **QR or text**.
- 🌍 **Offline, worldwide** — download any of 106 country databases and search with no connection.
- 🗣️ **Multilingual** — English, German, French, Italian.
- ❤️ **Health Connect** — optional, write-only sync of calories & macros.
- 💾 **ZIP backup / restore** — fully local, no cloud, no lock-in.

## Data & privacy

- Food data: **Open Food Facts** (ODbL) + the **Swiss Food Composition Database** (FSVO).
- On-device food image model: **Google AIY food_V1** (Apache-2.0), bundled and run locally.
- The only thing that ever leaves the device is an **optional** Gemini photo upload — and only if
  *you* configure a key. Everything else is on-device. No accounts, no analytics, no server.

## Stack

Flutter · drift (SQLite) · Riverpod · mobile_scanner · `openfoodfacts`/`http` · health ·
`tflite_flutter` (food model) · ML Kit (OCR) · `image_picker`

## Build & run

Dev toolchain lives in a distrobox container (`flutter`). Typical commands:

```sh
flutter test
flutter build apk --debug                                   # emulator
flutter build apk --release --target-platform android-arm64 # phone (~113 MB)
flutter build appbundle                                     # Play Store (per-device split)
```

Architecture, data model, and the phased roadmap are in [`PLAN.md`](./PLAN.md).

## License

TBD
