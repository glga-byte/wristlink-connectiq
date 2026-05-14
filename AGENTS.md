# AGENTS.md

## Project Context

WristLink Connect IQ is the Garmin watch companion app for WristLink. It receives compact commands from the WristLink mobile app, such as points, timers, notes, and simple actions, then presents or handles them on supported Garmin devices.

This repository covers only the Connect IQ watch app. The Flutter smartphone app, native Android/iOS Garmin Mobile SDK bridges, and durable phone-side send queue are developed separately.

## Agent Guidance

- Treat this file as durable project guidance. Keep it concise, operational, and specific to this Connect IQ repository.
- Prefer established Connect IQ SDK patterns over generic app architecture patterns.
- When a change adds durable platform constraints, contract rules, verification steps, or project conventions, update this file in the same change.
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
manifest.xml              # App id, permissions, products, app type
monkey.jungle             # Canonical build configuration
source/
  WristLinkApp.mc         # AppBase lifecycle and app-level registration
  WristLinkView.mc        # Primary watch UI
  WristLinkDelegate.mc    # Input handling
  messaging/              # Phone message registration, parsing, ack sending
  payloads/               # Contract-facing payload models and validation
  storage/                # Durable state wrappers over Application.Storage
  ui/                     # Shared drawing, menus, formatting helpers
resources/
  strings/
  layouts/
  drawables/
tests/
  payloads/
  messaging/
  storage/
```

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
- Support both touch and button-first devices. Do not assume touchscreen input, extended keys, maps, sensors, AMOLED behavior, or newer APIs without `has` checks or manifest/device gating.
- Keep rendering lightweight. Avoid unnecessary allocations in drawing paths and avoid parsing, storage writes, or communication work inside `onUpdate()`.
- Keep input delegates focused on input handling. Business logic should live in payload, messaging, or domain helpers.
- Register message callbacks during app startup or view initialization in a predictable place, and keep callback handlers short.

## Manifest And Permissions

- Keep `manifest.xml` product support explicit. Test representative round, square, AMOLED, MIP, touch, and button-first devices before broadening supported products.
- Keep permissions minimal. Add `Communications` only when phone/watch messaging is required, and document any additional permission in the change notes.
- Ensure the app type, entry class, supported products, and permissions remain aligned with the intended Watch App / Device App behavior.

## Testing

- Cover payload parsing, validation, schema-version handling, storage migration/defaults, acknowledgement construction, and communication error mapping with Monkey C tests.
- Add simulator checks for UI or input behavior that unit tests cannot cover.
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
# Compile for at least one supported simulator target.
monkeyc -f monkey.jungle -o bin/WristLink.prg -w -y "$CONNECTIQ_KEY" -d <device_id>

# Run in the simulator.
connectiq
monkeydo bin/WristLink.prg <device_id>

# Run Monkey C unit tests when tests or parsing/storage/messaging logic change.
monkeyc -f monkey.jungle -o bin/WristLinkTest.prg -w -t -y "$CONNECTIQ_KEY" -d <device_id>
monkeydo bin/WristLinkTest.prg <device_id> -t

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
