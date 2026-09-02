## 1. Connect IQ Project Scaffold

- [x] 1.1 Add `manifest.xml` as a Watch App with one stable generated UUID, `minApiLevel` 5.2.0, only `fenix7x` and `edge1040` products, and no permissions; verify the SDK accepts the manifest for both product builds.
- [x] 1.2 Add canonical `monkey.jungle`, launcher icon, string/drawable/menu resources, a shared source-level `UiTheme` color palette, and the planned source/test directories without empty future capability folders; document the Connect IQ resource-schema constraint and verify minimal string, drawable, menu, and theme references resolve in a warning-enabled `monkeyc` build.
- [x] 1.3 Implement `WristLinkApp` with `AppBase.getInitialView()` returning the Home view/delegate and no service or persistence lifecycle hooks; verify both simulator profiles launch directly into WristLink Home without a phone.
- [x] 1.4 Audit the scaffold against API 5.2.0 and remove any legacy or deprecated API usage; verify compiler output contains no deprecation warnings and source contains no `WatchUi.Menu`, `MenuInputDelegate`, or AppBase property calls.

## 2. Local Demo Model

- [x] 2.1 Implement compact local models and `DemoData` fixtures for Trailhead parking, Gate code, the three-minute Tea timer, recent items, notes, status, and About identity; verify unit tests assert the seeded labels, counts, types, and statuses.
- [x] 2.2 Implement `DemoSession` state for pending/empty Inbox, selected note, navigation outcome, timer outcome, and session-only saved-note behavior; verify unit tests cover every transition and a fresh session restores the original fixtures.
- [x] 2.3 Add Monkey C test configuration for the model layer; verify a `monkeyc -t` build and `monkeydo ... -t` run report all model tests passing on a baseline simulator target.

## 3. Navigation and Current UI Foundations

- [x] 3.1 Implement `AppNavigator` as the sole factory for view/delegate pairs and push/pop behavior; once the navigation tests are runnable, restore `monkey.jungle` to `base.sourcePath = source;tests` so the complete test tree is included; verify `monkeyc -t` discovers and runs both model and navigation tests, and that route tests or a minimal simulator harness cover Home, menu, each destination, received-item details, and Back-stack return paths.
- [x] 3.2 Define the destination menu as a `Menu2` resource under `resources/menus/`, load it through `Rez`, and handle it with `Menu2InputDelegate`; verify the native menu shows Recent Items, Saved Notes, Status, and About in order on both simulators without legacy or programmatic fallback construction.
- [x] 3.3 Add shared light/dark theme, safe-area geometry, typography, cards, progress treatment, and primitive icon utilities; verify a representative screen compiles and renders without clipping at 280×280 and 282×470.
- [x] 3.4 Add managed `Text`, `TextArea`, `Button`, and `Selectable` screen composition plus a reusable `BehaviorDelegate` activation path; verify physical focus and touch selection dispatch the same semantic action without manual tap hit-testing.
- [x] 3.5 Keep rendering paths allocation-light and presentation-only; verify code review confirms `onUpdate()` performs drawing without parsing, navigation, session mutation, communications, or storage work.

## 4. Home and Menu Destination Screens

- [ ] 4.1 Implement pending and empty Home/Inbox presentations with their summary counts, Open/Recent actions, and dark/light treatments; verify the local Launch flow reaches empty Home and a fresh session starts at pending Home.
- [ ] 4.2 Implement Recent Items with selectable navigation, note, and timer rows and their dummy outcomes; verify selecting each row opens its corresponding received or detail screen and Back returns to Recent Items.
- [ ] 4.3 Implement Saved Notes with readable title/body, position/total metadata, Next cycling, and menu access; verify two dummy notes cycle correctly and Back from a menu-selected Saved Notes screen returns to the native menu.
- [ ] 4.4 Implement Status using deterministic readiness, phone-link, acknowledgement, and contract fixtures; verify the displayed values do not invoke or depend on live connectivity APIs.
- [ ] 4.5 Implement About using WristLink, Connect IQ, contract version, and stable manifest identity data; verify the displayed UUID matches `manifest.xml` and Back returns to the native menu.

## 5. Received-Item Screens and Local Outcomes

- [ ] 5.1 Implement the received-navigation screen with destination, Launch, and Later actions; verify Launch shows a local handoff outcome then permits return to empty Home, while Later returns to pending Home without external navigation.
- [ ] 5.2 Implement the received-timer screen with duration, label, progress treatment, Start timer, and local started state; verify activation changes only in-memory UI state and no alarm, background timer, communication, or storage API is called.
- [ ] 5.3 Implement the received-note screen with readable title/body, Save note, and local saved-note routing; verify Save opens the matching Saved Notes content and restarting the app discards the session-only result.

## 6. Device Layout and Input Parity

- [ ] 6.1 Complete a no-touch walkthrough on `fenix7x` using physical controls for focus, selection, menu, paging, and Back; verify every required screen and action is reachable and the active selection is visibly highlighted.
- [ ] 6.2 Complete a touch walkthrough on `edge1040`; verify every visible action and list row is selectable, the tall rectangular layout uses available space, and essential content is not clipped.
- [ ] 6.3 Repeat touch activation on `fenix7x` and compare results with its physical-button path; verify both input methods produce identical routes and `DemoSession` transitions.
- [ ] 6.4 Inspect all implemented screens against `docs/design/paper`; verify content hierarchy, dark/action and light/review themes, labels, focus, and primary actions match the references without packaging the PNGs as runtime assets.

## 7. Final Verification and Project Guidance

- [ ] 7.1 Compile warning-enabled application builds for both targets with `monkeyc -f monkey.jungle -w -y "$CONNECTIQ_KEY" -d fenix7x` and `-d edge1040`; verify both commands succeed with no deprecated or unavailable API warnings.
- [ ] 7.2 Run the complete Monkey C unit-test suite on the supported SDK; verify all demo-state and navigation-action tests pass and failures produce a non-zero result.
- [ ] 7.3 Audit `source/` and `manifest.xml` for scope boundaries; verify there are no Communications or Background registrations, transmissions, external navigation calls, persistent-storage calls, or unnecessary permissions.
- [ ] 7.4 Document the API 5.2.0 baseline, `fenix7x`/`edge1040` verification matrix, external signing-key requirement, and simulator commands in project guidance; verify instructions can be followed from a clean checkout without committing a private key.
- [ ] 7.5 Run `openspec validate scaffold-watch-ui --strict` and review every requirement scenario against the simulator checklist; verify the change validates and no specified screen, state, input path, or out-of-scope boundary remains untested.
