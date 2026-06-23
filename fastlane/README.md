# Play Store metadata (fastlane)

Version-controlled Play Store listing for **Knabberfuchs** (`ch.knabberfuchs.app`),
pushed with [fastlane `supply`](https://docs.fastlane.tools/actions/supply/).
Every lane uploads as a **draft** — nothing goes live until you press
"Send for review" in the Play Console.

## Layout

```
fastlane/
  Appfile                       package name + key path
  Fastfile                      lanes: validate / listing / internal
  metadata/android/<locale>/
    title.txt                   ≤ 30 chars
    short_description.txt        ≤ 80 chars
    full_description.txt         ≤ 4000 chars
    changelogs/1.txt             release notes for versionCode 1 (≤ 500 chars)
    images/
      icon.png                   512×512  — REQUIRED, not yet added (see below)
      featureGraphic.png         1024×500 — REQUIRED, not yet added (see below)
      phoneScreenshots/          1.png … 8.png  (en-US only, for now)
```

Locales: `en-US` (default), `de-DE`, `fr-FR`, `it-IT`.

## No-Ruby alternative: `tool/play_publish.py`

fastlane needs Ruby. If you don't have it, `tool/play_publish.py` pushes this
same metadata tree via the Android Publisher API directly (Python only):

```sh
python3 -m pip install --user google-auth google-api-python-client
python3 tool/play_publish.py            # DRY RUN — validates, saves nothing
python3 tool/play_publish.py --commit   # saves the listing as a draft
```

It reads `fastlane/play-store-key.json` and the `metadata/android/<locale>`
text + screenshots. `--commit` uses `changesNotSentForReview`, so nothing is
submitted for review — you still publish manually in the Console.

## One-time setup

1. **Service account + key (you do this — it's a credential):**
   - Play Console → *Setup → API access* → create / link a Google Cloud service
     account, grant it permission to manage this app.
   - Download its JSON key and save it as `fastlane/play-store-key.json`.
   - This file is **gitignored**. Never commit it, print it, or paste it anywhere.
2. **Install fastlane:** `gem install fastlane` (needs Ruby).

## Lanes

```sh
fastlane validate   # check metadata locally, no upload
fastlane listing    # push text + screenshots as a draft (no binary)
fastlane internal   # upload build/app/outputs/bundle/release/app-release.aab to internal testing (draft)
```

Build the AAB first for `internal`:
`flutter build appbundle --release`

## Still needed before the listing can go live

Graphics aren't generated yet (the repo only has a 256×256 fox logo). Add:

- **`images/icon.png`** — 512×512 32-bit PNG hi-res icon.
- **`images/featureGraphic.png`** — 1024×500 PNG/JPG banner.

Drop them into `metadata/android/en-US/images/` (and per-locale if you want
localized banners). `supply` only uploads files that are present, so their
absence won't break a metadata push — but the Play Console requires both to
publish.

## Notes

- The de/fr/it copy is a first translation pass and is **unreviewed** — give it
  a read before publishing.
- Screenshots currently show the English UI and live only under `en-US`. Add
  localized screenshots under each locale's `images/phoneScreenshots/` later if
  desired.
- `supply` does **not** handle the content-rating questionnaire, target-audience,
  category/tags, or most of the Data Safety form — those stay in the Console.
