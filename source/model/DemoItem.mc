module DemoItemType {
    const TYPE_NAVIGATION = "Navigate";
    const TYPE_NOTE = "Note";
    const TYPE_TIMER = "Timer";
}

class DemoItem {
    public var title;
    public var detail;
    public var type;
    public var status;

    public function initialize(title, detail, type, status) {
        self.title = title;
        self.detail = detail;
        self.type = type;
        self.status = status;
    }
}
