import Toybox.Lang;

module DemoSessionState {
    const NAVIGATION_IDLE = "idle";
    const NAVIGATION_LAUNCHED = "launched";
    const TIMER_READY = "ready";
    const TIMER_STARTED = "started";
}

class DemoSession {
    private var _hasPending;
    private var _selectedNoteIndex;
    private var _navigationOutcome;
    private var _timerOutcome;
    private var _savedReceivedNote;
    private var _recentItems as Array<DemoItem>;
    private var _notes as Array<DemoNote>;

    public function initialize() {
        _hasPending = true;
        _selectedNoteIndex = 0;
        _navigationOutcome = DemoSessionState.NAVIGATION_IDLE;
        _timerOutcome = DemoSessionState.TIMER_READY;
        _savedReceivedNote = false;
        _recentItems = DemoData.recentItems();
        _notes = DemoData.notes();
    }

    public function hasPending() {
        return _hasPending;
    }

    public function recentItems() {
        return _recentItems;
    }

    public function recentSummaryCount() {
        return DemoData.RECENT_SUMMARY_COUNT;
    }

    public function notes() {
        return _notes;
    }

    public function noteCount() {
        return _notes.size();
    }

    public function selectedNoteIndex() {
        return _selectedNoteIndex;
    }

    public function selectedNote() {
        return _notes[_selectedNoteIndex];
    }

    public function selectNote(index) {
        if (index >= 0 && index < _notes.size()) {
            _selectedNoteIndex = index;
        }
    }

    public function selectNextNote() {
        _selectedNoteIndex = (_selectedNoteIndex + 1) % _notes.size();
    }

    public function launchNavigation() {
        _navigationOutcome = DemoSessionState.NAVIGATION_LAUNCHED;
        _hasPending = false;
    }

    public function navigationOutcome() {
        return _navigationOutcome;
    }

    public function deferNavigation() {
        _navigationOutcome = DemoSessionState.NAVIGATION_IDLE;
    }

    public function startTimer() {
        _timerOutcome = DemoSessionState.TIMER_STARTED;
    }

    public function timerOutcome() {
        return _timerOutcome;
    }

    public function saveReceivedNote() {
        _savedReceivedNote = true;
        _selectedNoteIndex = 0;
    }

    public function savedReceivedNote() {
        return _savedReceivedNote;
    }
}
