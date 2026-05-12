# Connect IQ Watch Message Flow

This document describes the watch-side runtime flow represented by the Paper
Watch page. The Connect IQ app is usually closed, so the background service
receives phone messages first. It then either asks the user to open the app,
saves a waypoint and notifies, or returns an acknowledgement.

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

- `Watch - Launch Navigation`: foreground screen after user accepts
  `Launch navigation?`.
- `Watch - Waypoint Saved`: notification-style result after background waypoint
  save.
- `Watch - Timer Ready`: foreground screen after user accepts `Open timer?`.
- `Watch - Note Ready`: foreground screen after user accepts `Open note?`.
- The watch design intentionally separates `navigate` from `save_waypoint`;
  navigation may create a temporary waypoint internally, but the user-facing
  action is still navigation.
