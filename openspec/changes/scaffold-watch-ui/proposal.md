## Why

WristLink needs a runnable Connect IQ watch-app foundation that turns the existing Paper designs into a coherent, testable simulator experience. Establishing the complete local-only navigation and screen structure now enables UI validation before phone messaging and durable state are introduced.

## What Changes

- Scaffold the Garmin Connect IQ Watch App, including its manifest, build configuration, resources, application lifecycle, views, and input delegates.
- Add dummy Home and Inbox states plus received navigation, timer, and note experiences based on `docs/design/paper`.
- Add a native menu with Recent Items, Saved Notes, Status, and About destinations.
- Support equivalent navigation using physical buttons and touch input on compatible devices.
- Populate every experience with local dummy data and make the app runnable in the Connect IQ simulator.
- Keep phone messaging, acknowledgements, and persistent storage outside this change.

## Capabilities

### New Capabilities

- `watch-app-ui`: Defines the simulator-runnable watch application, its dummy-data screens and states, native menu destinations, and button/touch navigation behavior.

### Modified Capabilities

None.

## Impact

- Adds the initial Connect IQ application structure across `manifest.xml`, `monkey.jungle`, `source/`, and `resources/`.
- Introduces local presentation models and navigation behavior derived from the Paper design references.
- Adds simulator-oriented verification for the supported screen flow and input methods.
- Does not change any phone/watch contract, communications integration, or persistent storage behavior.
