# Connect IQ Watch App Runtime

This document describes the watch-side runtime represented by the Paper Watch
page: background message handling, manual app launch, main screens, navigation,
and acknowledgement outcomes.

The Connect IQ app is usually closed, so the background service receives phone
messages first. It then either asks the user to open the app, saves a waypoint
and notifies, or returns an acknowledgement. When the user opens WristLink
directly, the foreground app presents the same local state through a compact
watch inbox and native Garmin menu destinations.

## Shared Setup Flow

1. Watch app starts or is installed.
2. Watch app registers for phone messages:
   - Call `Background.registerForPhoneAppMessageEvent()`.
   - Use `System.ServiceDelegate.onPhoneAppMessage()` as the closed/background
     entry point.
3. Foreground app registers any foreground callbacks needed for notifications
   and pending background data.
4. Phone sends a validated WristLink v1 envelope through Garmin transport.
5. Watch background service receives the message while the app may be closed.
6. Background service parses:
   - protocol version
   - message id
   - kind
   - payload
   - point intent when `kind == point`
7. Background service stores the pending message by id before showing UI or
   doing work.
8. Background service routes by kind and intent.
9. Watch sends an acknowledgement when the message is accepted, rejected,
   unsupported, or retryable.

## Manual App Launch Flow

When the user opens WristLink directly from the watch app list, the app should
act as a compact inbox for watch-side WristLink activity. Manual launch must use
the same pending-message store as background wake flows, so messages declined
from a Garmin wake prompt can still be reviewed before they expire or are
dismissed.

1. User opens WristLink on the watch.
2. App loads compact local state:
   - newest pending actionable message
   - recent received items and outcomes
   - saved app-owned notes
   - last phone/watch communication status
3. App shows the `Home / Inbox` screen.
4. If there is one pending actionable message, it is the primary selectable
   item on the home screen.
5. If there are no pending actionable messages, home shows `Ready` and
   `No pending requests` with recent/note counts and a `Recent` action.
6. User selects the pending item:
   - navigate point opens `Launch navigation?`
   - timer opens `Timer received`
   - note opens `Note received`
   - unsupported command opens a status/result screen
7. If user selects the clear home state:
   - open `Recent items`
8. User opens the native app menu for secondary destinations:
   - `Recent items`
   - `Saved notes`
   - `Status`
   - `About`
9. Back returns to the previous screen or exits the app from `Home / Inbox`.

Manual launch does not create new phone commands. The phone app remains the
producer of WristLink contract messages; the watch app reviews, displays,
handles, dismisses, or acknowledges received messages.

## Main Screens And Navigation

Use `Toybox.WatchUi.View` screens with focused delegates rather than a custom
tab bar. Garmin devices vary across touch, button-first, round, square, AMOLED,
and MIP displays, so every primary path must work with select/back/menu and page
navigation behaviors.

- `Home / Inbox`: default launch view. Shows connection/status and small counts
  for pending, recent, and saved note state. When pending work exists, show the
  newest actionable item and `Open`. When clear, show `Ready`, `No pending
  requests`, and `Recent`; do not show a disabled `Open` button. Use the light
  empty-home treatment when there is no pending work so the screen reads as
  passive review rather than an incoming action.
- `Pending Request Detail`: foreground action view for the selected pending
  item. Reuse the existing `Launch navigation?`, `Timer received`, and
  `Note received` screens from wake flows.
- `Recent items`: short list of received items and their final watch outcome.
  Use compact rows with kind, label/title, and status.
- `Saved notes`: list and detail views for app-owned notes saved from phone
  messages. Keep note bodies short, scrollable, and readable.
- `Status`: phone connection and transport recovery review view. Show last
  message status, last acknowledgement status, and whether the app is waiting
  for the phone.
- `About`: app version and adopted contract version. Keep this in the menu, not
  on the main path.

Recommended input mapping:

- Select: open the highlighted row or perform the primary action. On clear
  home, open `Recent items`.
- Back: return to the previous view, then exit from `Home / Inbox`.
- Menu: open the native `Menu2` navigation menu where supported, with a
  `Menu` fallback if needed.
- Next/previous page or up/down: move through list rows or scroll long text.
- Touch: may tap visible primary actions, but no flow may require touch.

Prefer native Garmin controls for secondary UI. Use menu items for destinations
and confirmation dialogs for simple yes/no decisions. Keep custom full-screen
views for WristLink-specific pending requests where the phone-sent content must
be readable at a glance.

Visual theme rule:

- Black screens represent pending, live, or action-oriented states.
- White screens represent saved, completed, reviewable, or menu-destination
  information. `Home / Inbox` also uses the white treatment when empty because
  it is a passive ready state. `Status` stays white while it is a passive
  connection review screen; use a black state only for an explicit blocking
  recovery action.

## Navigate Point Flow

Phone sends:

```text
kind: point
payload.intent: navigate
payload.label: Trailhead parking
payload.lat/lon: selected coordinates
```

Watch flow:

1. Background service receives the point message.
2. Validate point coordinates and `intent == navigate`.
3. Store pending navigation message.
4. Create or stage a temporary waypoint if Garmin navigation requires a
   persisted content target.
5. Call `Background.requestApplicationWake("Launch navigation?")`.
6. Call `Background.exit({ messageId, flow: "navigate" })`.
7. Garmin shows the system popup: `Launch navigation?`.
8. If user declines:
   - app stays closed
   - message remains pending or receives retryable/rejected based on
     implementation policy
9. If user accepts:
   - app opens
   - foreground receives background data
   - app loads the pending message
   - app shows the custom `Launch navigation?` screen from the Watch design
10. User taps `Launch`.
11. Watch app opens Garmin navigation for the staged waypoint/point.
12. Watch sends `accepted` acknowledgement if navigation handoff succeeds.
13. Watch sends `retryable` or `rejected` acknowledgement if navigation cannot
    be launched.

## Save Waypoint Flow

Phone sends:

```text
kind: point
payload.intent: save_waypoint
payload.label: Trailhead parking
payload.lat/lon: selected coordinates
```

Watch flow:

1. Background service receives the point message.
2. Validate point coordinates and `intent == save_waypoint`.
3. Build a `Position.Location` from lat/lon.
4. Call `PersistedContent.saveWaypoint(location, { :name => label })`.
5. Show a notification:
   - title: `Waypoint saved`
   - subtitle/body: point label and coordinates
6. Do not show navigation UI.
7. Do not include a navigation CTA.
8. Send `accepted` acknowledgement if the waypoint is saved.
9. Send `rejected` or `retryable` acknowledgement if saving fails.

## Timer Flow

Phone sends:

```text
kind: timer
payload.label: Tea
payload.durationSec: 180
```

Watch flow:

1. Background service receives timer message.
2. Validate label and duration.
3. Store pending timer message.
4. Call `Background.requestApplicationWake("Open timer?")`.
5. Call `Background.exit({ messageId, flow: "timer" })`.
6. Garmin shows the system popup: `Open timer?`.
7. If user accepts:
   - foreground app opens
   - app loads pending timer
   - app shows `Timer received` screen
   - user taps `Start timer`
8. Watch starts the timer.
9. Watch sends `accepted` acknowledgement.
10. If timer cannot be started, send `retryable` or `rejected`.

## Note Flow

Phone sends:

```text
kind: note
payload.title: Gate code
payload.body: Code 1234. Use the side entrance.
```

Watch flow:

1. Background service receives note message.
2. Validate title/body.
3. Store pending note message.
4. Call `Background.requestApplicationWake("Open note?")`.
5. Call `Background.exit({ messageId, flow: "note" })`.
6. Garmin shows the system popup: `Open note?`.
7. If user accepts:
   - foreground app opens
   - app loads pending note
   - app shows `Note received` screen
   - user taps `Save note`
8. Watch stores the note in app-owned storage.
9. Watch sends `accepted` acknowledgement.
10. If note cannot be saved, send `retryable` or `rejected`.

## Failure And Ack Rules

- Malformed envelope: send `rejected`.
- Unsupported version: send `unsupported`.
- Unsupported kind or point intent: send `unsupported` or `rejected`.
- Temporary Garmin issue: send `retryable`.
- Successful handling: send `accepted`.
- Point, timer, note, and command should require acknowledgements so the phone
  queue reflects actual watch handling, not just phone-to-watch transport
  success.

## Design Mapping

- `Watch - Home Inbox`: default screen after manual app launch.
- `Watch - Home Empty`: default screen after manual app launch when there are
  no pending actionable messages.
- `Watch - Native Menu`: native Garmin `Menu2` / `Menu` destination list opened
  from the menu key or equivalent device control.
- `Watch - Launch Navigation`: foreground screen after user accepts
  `Launch navigation?` or opens a pending navigate item from `Home / Inbox`.
- `Watch - Waypoint Saved`: notification-style result after background waypoint
  save.
- `Watch - Timer Ready`: foreground screen after user accepts `Open timer?`.
- `Watch - Note Ready`: foreground screen after user accepts `Open note?`.
- `Watch - Recent Items`: menu destination for recently received messages and
  outcomes.
- `Watch - Saved Notes`: menu destination for app-owned notes saved from phone
  messages.
- `Watch - Status`: menu destination for phone/watch communication state and
  recovery.
- `Watch - About`: menu destination for app, contract, and stable UUID
  metadata.
- The watch design intentionally separates `navigate` from `save_waypoint`;
  navigation may create a temporary waypoint internally, but the user-facing
  action is still navigation.
