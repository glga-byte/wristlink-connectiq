## Purpose

Defines the locally demonstrable WristLink watch experience so its primary screens, menu destinations, and input paths can be validated in the Connect IQ simulator before messaging and persistence are implemented.

## ADDED Requirements

### Requirement: Simulator-runnable watch experience
The application SHALL declare Connect IQ API level 5.2.0 as its minimum and SHALL initially support the `edge1040` and `fenix7x` products. It SHALL launch as a Garmin Connect IQ Watch App on both simulator targets and present a usable WristLink screen without requiring a paired phone, received message, network connection, or previously stored state.

#### Scenario: Launch without external dependencies
- **WHEN** the application is started in the supported Connect IQ simulator with no paired phone and no existing application data
- **THEN** the WristLink Home screen is displayed with local dummy content and remains navigable

#### Scenario: Compile and launch on both baseline products
- **WHEN** the application is compiled with API level 5.2.0 for `edge1040` and `fenix7x`
- **THEN** each build succeeds and launches in its corresponding simulator profile

### Requirement: Locally demonstrable Inbox states
The Home screen SHALL provide locally driven pending and empty Inbox states that match the information hierarchy in the Paper design references. The pending state SHALL identify the pending item, summarize recent items and saved notes, and offer an action to open the item. The empty state SHALL state that no requests are pending, retain summary counts, and offer an action to view recent items.

#### Scenario: Pending Inbox state
- **WHEN** the local demonstration state contains a pending navigation item
- **THEN** Home shows the item title and destination, non-zero pending/recent/note summaries, and an Open action that opens the received-navigation screen

#### Scenario: Empty Inbox state
- **WHEN** the local demonstration state contains no pending item
- **THEN** Home shows "No pending requests", zero pending items, the dummy recent and note counts, and a Recent action that opens Recent Items

#### Scenario: Both Inbox states are reachable locally
- **WHEN** a user follows the local demonstration flow without phone messaging
- **THEN** the user can observe both the pending and empty Home states during the simulator session

### Requirement: Native destination menu
The application SHALL provide a native watch menu containing Recent Items, Saved Notes, Status, and About destinations in that order. The menu SHALL be reachable from the Home experience and SHALL return users predictably to the prior screen when dismissed.

#### Scenario: Open the menu
- **WHEN** the user invokes the watch menu action from Home
- **THEN** the native menu displays Recent Items, Saved Notes, Status, and About

#### Scenario: Select a menu destination
- **WHEN** the user selects any destination in the native menu
- **THEN** the corresponding WristLink screen opens

#### Scenario: Return from a menu destination
- **WHEN** the user performs the Back action from Recent Items, Saved Notes, Status, or About
- **THEN** the native destination menu is shown again

### Requirement: Recent Items screen
Recent Items SHALL show representative local navigation, note, and timer entries with their type and current dummy status. Selecting an entry SHALL open the corresponding local detail or received-item experience.

#### Scenario: View recent items
- **WHEN** the user opens Recent Items
- **THEN** the screen lists a pending navigation item, a saved note item, and an accepted timer item using local dummy data

#### Scenario: Open a recent item
- **WHEN** the user selects a navigation, note, or timer entry
- **THEN** the application opens the corresponding navigation, note, or timer screen without contacting a phone

### Requirement: Saved Notes screen
Saved Notes SHALL display readable local note content, the current note position and total count, and controls for advancing to the next note and opening the destination menu.

#### Scenario: View a saved note
- **WHEN** the user opens Saved Notes
- **THEN** a dummy note title, note body, position, total count, and saved-time summary are visible

#### Scenario: Advance through saved notes
- **WHEN** the user activates Next while more than one dummy note is available
- **THEN** the next local note is displayed and the position indicator is updated

### Requirement: Status and About screens
The Status screen SHALL present deterministic local demonstration values for readiness, phone-link state, last acknowledgement, and contract version. The About screen SHALL identify WristLink as a Connect IQ app and SHALL show deterministic contract-version and application-identity information.

#### Scenario: View local status
- **WHEN** the user opens Status
- **THEN** the screen displays the configured dummy readiness, phone-link, acknowledgement, and contract values without performing a communications check

#### Scenario: View application information
- **WHEN** the user opens About
- **THEN** the screen displays WristLink, Connect IQ, the dummy contract version, and stable application identity information

### Requirement: Received navigation screen
The received-navigation screen SHALL show a local navigation request with its destination and SHALL offer Launch and Later actions. Neither action SHALL invoke external navigation or phone communication in this change.

#### Scenario: Choose Launch
- **WHEN** the user activates Launch on the dummy navigation request
- **THEN** the application presents a local navigation handoff outcome and remains within the WristLink simulator experience

#### Scenario: Choose Later
- **WHEN** the user activates Later on the dummy navigation request
- **THEN** the application returns to the Inbox without invoking navigation or communication services

### Requirement: Received timer screen
The received-timer screen SHALL show a local timer duration and label with a Start timer action. Activating the action SHALL demonstrate a local timer outcome without receiving, acknowledging, or persisting a timer command.

#### Scenario: View a received timer
- **WHEN** the user opens the dummy received-timer item
- **THEN** the timer duration, label, visual progress treatment, and Start timer action are visible

#### Scenario: Start the dummy timer
- **WHEN** the user activates Start timer
- **THEN** the application presents a locally driven started-timer outcome without contacting a phone or writing durable state

### Requirement: Received note screen
The received-note screen SHALL show a readable local note title and body with a Save note action. Activating the action SHALL demonstrate a local saved-note outcome without durable persistence.

#### Scenario: View a received note
- **WHEN** the user opens the dummy received-note item
- **THEN** the note title, note body, and Save note action are visible

#### Scenario: Save the dummy note
- **WHEN** the user activates Save note
- **THEN** the application opens a local saved-note outcome using the same dummy content without writing durable state

### Requirement: Button and touch navigation parity
Every actionable screen and menu destination SHALL be operable with standard physical watch inputs. On supported touchscreen devices, the same actions SHALL also be operable by touch, and the resulting destinations or state changes SHALL be equivalent.

#### Scenario: Navigate with physical buttons
- **WHEN** the `fenix7x` simulator is operated without touch input
- **THEN** the user can move focus, activate actions, open the menu, and return through every required screen using physical input controls

#### Scenario: Navigate with touch
- **WHEN** the `edge1040` or `fenix7x` simulator is operated with touch input
- **THEN** the user can activate every visible action and menu destination by touch and receives the same result as the equivalent physical-button action

### Requirement: Legible supported-device presentation
Required text, focus state, and primary actions SHALL remain visible and legible within the usable display area of the supported round `fenix7x` and rectangular `edge1040` simulator targets, without relying on touchscreen-only affordances.

#### Scenario: Render on representative display shapes
- **WHEN** each required screen is viewed on the round `fenix7x` and rectangular `edge1040` simulator targets
- **THEN** its essential content and currently actionable control are not clipped and can be distinguished from non-actionable content

### Requirement: Local-only state boundary
All content and state transitions in this change SHALL use deterministic in-memory dummy data. The application MUST NOT register for phone messages, transmit acknowledgements, invoke phone-side behavior, or read from or write to durable application storage.

#### Scenario: Exercise the complete demonstration flow
- **WHEN** the user navigates through Home, every menu destination, and every received-item screen
- **THEN** all displayed content and outcomes are produced locally and no communications or persistent-storage operation is attempted
