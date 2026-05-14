# Watch Paper Design Reference

Source: Paper file `WristLink`, page `Watch`.

These PNGs are design snapshots for Connect IQ watch app planning. They are not runtime Flutter assets.

## Structure

- `00-watch-flow.png` - closed-app watch behavior, phone-selected intents, and background delivery outcomes.
- `received-intents/` - watch UI states for received phone intents.
- `opened-app/` - main screens and navigation states when the user opens the
  watch app directly.

## Update Rules

- Keep filenames numbered so review order stays stable in GitHub and file browsers.
- Use lowercase kebab-case names.
- Update these snapshots only when the Paper design intentionally changes.
- Do not reference these files from Flutter `pubspec.yaml` assets.
