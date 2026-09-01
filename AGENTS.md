# AGENTS.md

## Project Context

WristLink Connect IQ is the Garmin watch companion app for WristLink. It receives compact commands from the WristLink mobile app, such as points, timers, notes, and simple actions, then presents or handles them on supported Garmin devices.

This repository covers only the Connect IQ watch app. The Flutter smartphone app, native Android/iOS Garmin Mobile SDK bridges, and durable phone-side send queue are developed separately.

## Agent Guidance

- Treat this file as durable project guidance. Keep it concise, operational, and specific to this Connect IQ repository.
- Prefer established Connect IQ SDK patterns over generic app architecture patterns.
- When a feature introduces durable project knowledge, architecture rules, platform constraints, verification steps, or conventions that future agents must follow, update `AGENTS.md` as part of the same change.
- When Paper design files are updated, update the corresponding PNG snapshots
  in `docs/design/paper/` in the same change so design reviews stay in sync.
- Do not add research notes, transient implementation plans, or one-off debugging details here. Use implementation notes, PR descriptions, or issue comments for that context.

## Technologies

- Garmin Connect IQ SDK
- Monkey C
- Connect IQ Watch App / Device App runtime
- `Toybox.Application.AppBase` for lifecycle
- `Toybox.WatchUi` for views, delegates, menus, drawing, and input
- `Toybox.Communications` for phone-to-watch and watch-to-phone messages
- `Toybox.Application.Storage` for durable local watch-side state
- `Toybox.Test` for Monkey C unit tests

## Repository Boundaries

- Do not add Flutter, Android, iOS, or Garmin Mobile SDK companion-app code to this repository.
- Do not implement phone-side send queue behavior here. The watch app may persist minimal local watch state, but the durable command queue belongs to the Flutter project.
- Do not add Connect IQ Store metadata, screenshots, marketing copy, or publishing claims that imply Garmin endorsement unless the task is explicitly about store submission assets.
- Do not add Connect IQ watch app logic to the Flutter repository; this project is the watch-side counterpart.

## Recommended Structure

```text
manifest.xml                    # Stable app id, permissions, products, app type, minimum API
monkey.jungle                   # Canonical source, resource, test, and build configuration
source/
  WristLinkApp.mc               # AppBase lifecycle and dependency composition only
  model/                        # UI-independent session/domain state and transitions
  navigation/                   # View/delegate creation and stack transitions
  screens/                      # Screen Views and their focused BehaviorDelegates
  ui/                           # Shared theme, geometry, Drawables, Selectables, formatting
  payloads/                     # Contract models and validation; add when messaging begins
  messaging/                    # Garmin transport and ack/error mapping; add when needed
  storage/                      # Application.Storage adapters and migrations; add when needed
resources/
  strings/                      # User-visible and localizable text
  drawables/                    # Launcher icon and shared static visuals
  layouts/                      # Reusable managed layouts when they reduce code duplication
  menus/                        # Native Menu2 resources
resources-round/                # Optional family overrides; create only when base resources fail
resources-rectangle/            # Optional family overrides; create only when base resources fail
tests/
  model/                        # State-transition and fixture tests
  navigation/                   # Semantic action and route tests
  ui/                           # Pure geometry/formatting tests where practical
  payloads/                     # Mirror source capability folders as they are introduced
  messaging/
  storage/
docs/
  design/                       # Durable runtime and reviewed Paper design references
```

- Create capability directories only when they contain implementation; do not add empty placeholders for future messaging, payload, or storage work.
- Prefer one primary class per `.mc` file and name the file after that class. Keep a screen's View and dedicated delegate together under `screens/`; move only genuinely reusable behavior into `ui/` or `navigation/`.
- Keep dependency direction explicit: `WristLinkApp` composes dependencies; screens depend on navigation/model/UI abstractions; model, payload, messaging, and storage code must not depend on screen classes.
- Keep `WristLinkApp` thin. Initialize app-scoped dependencies in lifecycle methods and return the initial view/delegate pair from `getInitialView()`; do not push views from `onStart()`.
- Put strings, static drawables, native menus, and reusable layouts in resources. Prefer base resources, then family qualifiers, then device-specific qualifiers only when a verified device difference requires them.
- Do not combine a device qualifier with a family qualifier in one resource directory. Keep localization as the final qualifier when combining supported qualifier types.
- Define native destination menus as `Menu2` resources and load them through `Rez`; use programmatic menu construction only when runtime-dynamic items require it.

## Contract And Messaging

- Treat the Flutter app as the producer of already-normalized WristLink contract maps. The watch app may validate, interpret, reject, display, and acknowledge those maps, but must not invent separate payload business rules.
- Keep the Connect IQ app UUID stable. Any UUID change must be coordinated with the Flutter app metadata: Android `com.wristlink.CONNECT_IQ_APP_ID` and iOS `WristLinkConnectIQAppUUID`.
- Use `Toybox.Communications.registerForPhoneAppMessages()` as the primary inbound phone-message path.
- Use `Toybox.Communications.transmit()` only for watch-to-phone responses such as acknowledgements, status, or explicit user actions.
- Every inbound command must resolve to an explicit watch-side outcome: accepted, displayed, completed, rejected, failed, or unsupported.
- Keep acknowledgements small, typed, and contract-compatible. Include enough identity to let the phone correlate the acknowledgement with its send queue item.
- Do not depend on continuous phone connectivity. Handle unavailable BLE, queue-full, too-large, timeout, cancelled, and unknown communication failures as typed outcomes.
- Keep payload maps compact. Garmin communication and storage limits vary by device; reject oversized payloads with a clear typed reason instead of partially processing them.
- Handle malformed messages defensively: missing type, unknown schema version, invalid id, invalid coordinates, invalid timer duration, oversized text, unsupported command, and unknown fields.
- Prefer versioned payload handlers so future contract revisions can be adopted without breaking older installed watch apps.
- Before changing message payloads, acknowledgements, contract schemas, fixtures, or Garmin transport mapping, read `contract/AGENTS.md` if this project contains the shared contract.
- When this project adopts a changed message contract, update the `contract/` submodule pointer and document the adopted revision in implementation notes or the PR description.

## Storage

- Use `Toybox.Application.Storage` for durable watch-side state that must survive app restarts.
- Do not use deprecated `AppBase` property storage APIs for new runtime state.
- Use application settings/properties only for user-configurable settings. Runtime state belongs in `Application.Storage`.
- Store compact primitives, arrays, dictionaries, and byte arrays only when needed. `Application.Storage` value size is limited and total object store capacity varies by device.
- Do not use Symbols as persistent storage keys or values because Garmin documents that Symbols can change between builds.
- Keep storage models separate from message payload maps and UI presentation state. Use explicit mapping functions.

## UI And Device Support

- Keep UI simple and glanceable. Watch screens should prioritize the current command, confirmation state, and recovery from missing phone connectivity.
- The current baseline is Connect IQ API 5.2.0 with explicit `fenix7x` and `edge1040` products. Do not raise the minimum API or broaden products without compiling and exercising the affected device matrix.
- Use current API 5.2 components: `WatchUi.Menu2`/`Menu2InputDelegate` for native destination menus, `BehaviorDelegate` for portable behaviors, and managed `Button`/`Selectable` controls for shared touch/button activation. Do not add legacy `WatchUi.Menu`/`MenuInputDelegate` fallbacks.
- Support both touch and physical-button navigation. Do not assume touchscreen input, extended keys, maps, sensors, AMOLED behavior, or APIs newer than 5.2 without `has` checks and manifest/device gating.
- Keep rendering lightweight. Avoid unnecessary allocations in drawing paths and avoid parsing, storage writes, or communication work inside `onUpdate()`.
- Keep input delegates focused on input handling. Business logic should live in payload, messaging, or domain helpers.
- Register message callbacks during app startup or view initialization in a predictable place, and keep callback handlers short.

## Manifest And Permissions

- Keep `manifest.xml` product support explicit and test every declared product. Before broadening support, add simulator coverage for each newly introduced screen shape, display technology, and input model rather than inferring support from the current matrix.
- Keep the minimum API aligned with the oldest supported product. For the current `fenix7x` and `edge1040` baseline, use API 5.2.0 and verify every referenced Toybox API against that level.
- Keep permissions minimal. Add `Communications` only when phone/watch messaging is required, and document any additional permission in the change notes.
- Ensure the app type, entry class, supported products, and permissions remain aligned with the intended Watch App / Device App behavior.

## Testing

- Mirror source capability boundaries under `tests/` so model, navigation, payload, messaging, and storage behavior can be exercised without simulator-only UI tests.
- Cover payload parsing, validation, schema-version handling, storage migration/defaults, acknowledgement construction, and communication error mapping with Monkey C tests.
- Add simulator checks for UI or input behavior that unit tests cannot cover.
- When simulator verification is required, use Computer Use when available to inspect and interact with the Connect IQ Device Simulator. Exercise the touch and physical-button flows relevant to the change and inspect the rendered result instead of relying only on a successful deploy.
- Keep builds, deployment, unit tests, and runtime-log collection on the `monkeyc`/`monkeydo` command-line path. If Computer Use is unavailable or simulator access is denied, report the visual or input check as not verified and provide the remaining manual steps; do not claim simulator verification from compilation alone.
- Include malformed and oversized payload cases when changing message handling.

## Local Tooling

- Use the Garmin Connect IQ SDK and Garmin Monkey C VS Code extension when available.
- Keep `monkey.jungle` as the canonical build configuration.
- Use SDK command-line tools for repeatable checks when possible:
  - `monkeyc` for compile/package validation.
  - `connectiq` to start the simulator.
  - `monkeydo` to run the built `.prg` on a simulator device.
- Prefer compiling with warnings enabled.
- Use `monkeyc --unit-test` / `-t` builds and `monkeydo ... -t` for unit tests when the local SDK supports that flow.
- Do not commit developer private keys. Keep signing keys outside the repository.

## Verification

Run relevant checks before handing off changes:

```sh
# Compile for both baseline simulator targets.
monkeyc -f monkey.jungle -o bin/WristLink-fenix7x.prg -w -y "$CONNECTIQ_KEY" -d fenix7x
monkeyc -f monkey.jungle -o bin/WristLink-edge1040.prg -w -y "$CONNECTIQ_KEY" -d edge1040

# Run in the simulator.
connectiq
monkeydo bin/WristLink-fenix7x.prg fenix7x
monkeydo bin/WristLink-edge1040.prg edge1040

# Run Monkey C unit tests when tests or parsing/storage/messaging logic change.
monkeyc -f monkey.jungle -o bin/WristLinkTest-fenix7x.prg -w -t -y "$CONNECTIQ_KEY" -d fenix7x
monkeyc -f monkey.jungle -o bin/WristLinkTest-edge1040.prg -w -t -y "$CONNECTIQ_KEY" -d edge1040
monkeydo bin/WristLinkTest-fenix7x.prg fenix7x -t
monkeydo bin/WristLinkTest-edge1040.prg edge1040 -t

# Before Connect IQ Store submission, export an .iq package and verify manifest products.
```

## Reference Links

Use these links to verify Connect IQ behavior when touching platform-sensitive code:

- https://developer.garmin.com/connect-iq/overview/
- https://developer.garmin.com/connect-iq/sdk/
- https://developer.garmin.com/connect-iq/submit-an-app/
- https://developer.garmin.com/connect-iq/api-docs/Toybox/Communications.html
- https://developer.garmin.com/connect-iq/api-docs/Toybox/Application/Storage.html
- https://developer.garmin.com/connect-iq/api-docs/Toybox/Test.html
- https://developer.garmin.com/connect-iq/core-topics/application-and-system-modules/
- https://developer.garmin.com/connect-iq/core-topics/build-configuration/
- https://developer.garmin.com/connect-iq/core-topics/resources/
- https://developer.garmin.com/connect-iq/core-topics/input-handling/
- https://developer.garmin.com/connect-iq/api-docs/Toybox/WatchUi/Menu2.html
