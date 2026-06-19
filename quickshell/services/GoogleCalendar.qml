pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property string configDir: Quickshell.env("HOME") + "/.config/0conf/gcal"
    readonly property string configPath: configDir + "/settings.json"
    readonly property string accountsDir: configDir + "/accounts"

    property int refreshIntervalMinutes: 10
    property int lookaheadDays: 7
    // accounts: [{ alias, label, color?, calendars: [calendarTitle, ...] }]
    property var accounts: []

    // Merged event list across accounts, sorted by start. Each event:
    //   { account, label, color, title, location, calendar, url,
    //     start: Date, end: Date, allDay: bool }
    property var events: []
    property var nextEvent: null
    property int minutesToNext: -1
    property date lastRefresh: new Date(0)
    property bool refreshing: false
    property string lastError: ""

    // Per-account discovered calendars (from `gcalcli list`). Keyed by alias.
    //   { alias: [{ access, title }, ...] }
    property var calendarsByAccount: ({})
    // Per-account primary email, auto-discovered from `gcalcli list` output.
    // The primary calendar is owned and named after the account email.
    property var _accountEmails: ({})
    property int _pendingListers: 0
    property bool _refreshAfterDiscovery: false

    // If an in-flight batch never completes (e.g. a gcalcli subprocess hangs
    // or its onExited never fires), `refreshing` stays true and every later
    // refresh() returns early — the widget silently freezes. Treat a batch
    // older than this as dead and reclaim state on the next refresh attempt.
    readonly property int _staleBatchMs: 120000
    property double _batchStartedAt: 0

    function refresh() {
        if (root.refreshing) {
            var ageMs = Date.now() - root._batchStartedAt
            if (ageMs < root._staleBatchMs) return
            // Stale batch: drop any in-flight subprocesses and reset.
            for (var k in _fetchers) {
                var p = _fetchers[k]
                if (p) p.destroy()
            }
            _fetchers = ({})
            _pendingFetches = 0
            _collected = []
            _batchErrors = []
            root.refreshing = false
            root.lastError = "previous refresh timed out"
        }
        if (!root.accounts || root.accounts.length === 0) {
            root.events = []
            root.nextEvent = null
            root.minutesToNext = -1
            return
        }
        root.refreshing = true
        root._batchStartedAt = Date.now()
        _pendingFetches = root.accounts.length
        _collected = []
        _batchErrors = []
        for (var i = 0; i < root.accounts.length; i++) {
            _fetchOne(i, root.accounts[i])
        }
    }

    function discoverCalendars() {
        _pendingListers = root.accounts.length
        for (var i = 0; i < root.accounts.length; i++) {
            _listOne(root.accounts[i])
        }
    }

    function _shquote(s) {
        return "'" + String(s).replace(/'/g, "'\\''") + "'"
    }

    function saveSettings() {
        var json = JSON.stringify({
            refresh_interval_minutes: root.refreshIntervalMinutes,
            lookahead_days: root.lookaheadDays,
            accounts: root.accounts
        }, null, 2)
        saveProc.command = ["sh", "-c",
            "mkdir -p '" + root.configDir + "' && printf %s " +
            _shquote(json) + " > '" + root.configPath + "'"]
        saveProc.running = true
    }

    function openUrl(url) {
        if (!url || url.length === 0) return
        Quickshell.execDetached(["xdg-open", url])
    }

    // Notify-before window for upcoming events, in minutes.
    property int notifyMinutesBefore: 2
    // Set of event keys already notified for this run; cleared on service reload.
    property var _notifiedKeys: ({})
    property var _notifiers: ({})
    property int _notifierSeq: 0

    function _eventKey(ev) { return ev.url + "|" + ev.start.getTime() }

    function _maybeNotifyImminent(now) {
        var thresholdMs = root.notifyMinutesBefore * 60000
        for (var i = 0; i < root.events.length; i++) {
            var e = root.events[i]
            if (e.allDay) continue
            var dt = e.start.getTime() - now.getTime()
            if (dt > thresholdMs) break  // events are sorted by start
            if (dt < -30000) continue    // already 30s past start; skip
            var key = _eventKey(e)
            if (_notifiedKeys[key]) continue
            _notifiedKeys[key] = true
            _dispatchNotification(e)
        }
    }

    function _dispatchNotification(ev) {
        var minutes = Math.max(0, Math.round((ev.start.getTime() - Date.now()) / 60000))
        var when = minutes <= 0 ? "starting now" : ("in " + minutes + " min")
        var bits = [when]
        if (ev.label) bits.push(ev.label)
        if (ev.location) bits.push(ev.location)
        var body = bits.join(" · ")

        var args = ["notify-send",
                    "-a", "quickshell-calendar",
                    "-u", "critical",
                    "-t", "0",
                    "-i", "appointment-soon-symbolic",
                    "-A", "open=Open in Calendar"]
        if (ev.meetUrl && ev.meetUrl.length > 0) {
            args.push("-A"); args.push("meet=Join Meet")
        }
        args.push(ev.title || "(untitled)")
        args.push(body)

        var seq = ++_notifierSeq
        var proc = notifierComponent.createObject(root, {
            seq: seq, event: ev, cmd: args
        })
        _notifiers[seq] = proc
        proc.start()
    }

    function _onNotifierDone(seq, ev, stdout) {
        var action = String(stdout).trim()
        if (action === "open") root.openUrl(ev.url)
        else if (action === "meet") root.openUrl(ev.meetUrl)
        var n = _notifiers[seq]
        if (n) { n.destroy(); delete _notifiers[seq] }
    }

    function toggleCalendar(accountIndex, calendarTitle) {
        var accs = root.accounts.slice()
        var acc = Object.assign({}, accs[accountIndex])
        var cals = (acc.calendars || []).slice()
        var idx = cals.indexOf(calendarTitle)
        if (idx >= 0) cals.splice(idx, 1)
        else cals.push(calendarTitle)
        acc.calendars = cals
        accs[accountIndex] = acc
        root.accounts = accs
        saveSettings()
        refresh()
    }

    // --- Internal state for in-flight batch ----------------------------------
    property int _pendingFetches: 0
    property var _collected: []
    property var _batchErrors: []
    property var _fetchers: ({})
    property var _listers: ({})

    // `env` reset by Process doesn't inherit a useful PATH, so user-local
    // tools like ~/.local/bin/gcalcli aren't found. Reconstruct PATH here.
    readonly property string _path: {
        var home = Quickshell.env("HOME") || ""
        var inherited = Quickshell.env("PATH") || "/usr/local/bin:/usr/bin:/bin"
        return home + "/.local/bin:" + inherited
    }

    function _envForAccount(alias) {
        var dir = root.accountsDir + "/" + alias
        return ["env",
                "PATH=" + root._path,
                "GCALCLI_CONFIG=" + dir,
                "XDG_DATA_HOME=" + dir]
    }

    function _pad(n) { return n < 10 ? "0" + n : "" + n }
    function _isoDate(d) {
        return d.getFullYear() + "-" + _pad(d.getMonth() + 1) + "-" + _pad(d.getDate())
    }

    function _fetchOne(index, acc) {
        var now = new Date()
        var end = new Date(now.getTime() + root.lookaheadDays * 86400000)
        var cmd = _envForAccount(acc.alias).concat([
            "gcalcli", "agenda", "--tsv",
            "--details", "title", "--details", "location",
            "--details", "calendar", "--details", "url",
            "--details", "conference"
        ])
        var cals = acc.calendars || []
        for (var i = 0; i < cals.length; i++) {
            cmd.push("--calendar"); cmd.push(cals[i])
        }
        cmd.push(_isoDate(now))
        cmd.push(_isoDate(end))
        var proc = fetcherComponent.createObject(root, { idx: index, account: acc, cmd: cmd })
        _fetchers[index] = proc
        proc.start()
    }

    function _onFetchDone(index, account, text, ok, err) {
        var who = account.label || account.alias
        if (ok) {
            var parsed = _parseTsv(text, account)
            for (var i = 0; i < parsed.length; i++) _collected.push(parsed[i])
            console.log("GoogleCalendar:", who, "fetched", parsed.length, "events")
        } else {
            var msg = who + ": " + err
            _batchErrors.push(msg)
            console.warn("GoogleCalendar:", msg)
        }
        var f = _fetchers[index]
        if (f) { f.destroy(); delete _fetchers[index] }
        _pendingFetches -= 1
        if (_pendingFetches > 0) return

        _collected.sort(function(a, b) { return a.start.getTime() - b.start.getTime() })
        var now = new Date()
        var kept = []
        for (var j = 0; j < _collected.length; j++) {
            var e = _collected[j]
            if (e.end.getTime() < now.getTime()) continue
            kept.push(e)
            if (kept.length >= 200) break
        }
        // If every account errored, keep the previous events visible rather
        // than blanking the widget. A transient gcalcli/network hiccup
        // shouldn't make the day's schedule disappear.
        var allFailed = _batchErrors.length === root.accounts.length
        if (allFailed && root.events.length > 0) {
            console.warn("GoogleCalendar: all fetches failed, keeping previous", root.events.length, "events")
        } else {
            root.events = kept
        }
        root.lastError = _batchErrors.join(" | ")
        root.lastRefresh = now
        root.refreshing = false
        _recomputeNext()
    }

    function _recomputeNext() {
        var now = new Date()
        var next = null
        for (var i = 0; i < root.events.length; i++) {
            var e = root.events[i]
            if (e.allDay) continue
            if (e.start.getTime() > now.getTime()) { next = e; break }
        }
        root.nextEvent = next
        _maybeNotifyImminent(now)
        if (next) {
            var diffMs = next.start.getTime() - now.getTime()
            root.minutesToNext = Math.max(0, Math.floor(diffMs / 60000))
        } else {
            root.minutesToNext = -1
        }
    }

    // --- TSV parser ----------------------------------------------------------

    function _parseTsv(text, account) {
        var lines = text.split("\n")
        var out = []
        var email = root._accountEmails[account.alias] || ""
        // First line is header.
        for (var i = 1; i < lines.length; i++) {
            var line = lines[i]
            if (line === "") continue
            var p = line.split("\t")
            // Expected columns with --details title,location,calendar,url,conference:
            //   start_date, start_time, end_date, end_time,
            //   html_link, hangout_link, conference_entry_point_type, conference_uri,
            //   title, location, calendar
            if (p.length < 11) continue
            var startDate = p[0], startTime = p[1]
            var endDate = p[2], endTime = p[3]
            var url = p[4]
            var hangoutLink = p[5]
            // p[6] = conference_entry_point_type (ignored)
            var conferenceUri = p[7]
            var title = p[8], location = p[9], calendar = p[10]

            var meetUrl = hangoutLink || conferenceUri || ""

            var allDay = startTime === "" && endTime === ""
            var start, end
            if (allDay) {
                start = _parseLocalDate(startDate, "00:00")
                end = _parseLocalDate(endDate, "23:59")
            } else {
                start = _parseLocalDate(startDate, startTime)
                end = _parseLocalDate(endDate, endTime)
            }
            if (!start || !end) continue

            // Drop events whose title is in the account's ignore_titles list
            // (case-insensitive, trimmed). Useful for auto-generated entries
            // like Workspace "Working location" all-day events.
            var ignored = false
            var ignoreList = account.ignore_titles || []
            var titleNorm = String(title || "").trim().toLowerCase()
            for (var ig = 0; ig < ignoreList.length; ig++) {
                if (String(ignoreList[ig]).trim().toLowerCase() === titleNorm) {
                    ignored = true
                    break
                }
            }
            if (ignored) continue

            out.push({
                account: account.alias,
                label: account.label || account.alias,
                color: account.color || "",
                title: title || "(untitled)",
                location: location || "",
                calendar: calendar || "",
                url: _withAuthuser(url, email),
                meetUrl: _withAuthuser(meetUrl, email),
                start: start, end: end, allDay: allDay
            })
        }
        return out
    }

    // Append authuser=<email> to a Google URL so the browser uses the matching
    // session even when multiple Google accounts are signed in.
    function _withAuthuser(url, email) {
        if (!url || url.length === 0 || !email || email.length === 0) return url || ""
        var sep = url.indexOf("?") >= 0 ? "&" : "?"
        return url + sep + "authuser=" + encodeURIComponent(email)
    }

    function _parseLocalDate(dateStr, timeStr) {
        var dm = dateStr.match(/^(\d{4})-(\d{2})-(\d{2})$/)
        if (!dm) return null
        var tm = timeStr.match(/^(\d{2}):(\d{2})$/)
        var h = 0, mi = 0
        if (tm) { h = parseInt(tm[1]); mi = parseInt(tm[2]) }
        return new Date(parseInt(dm[1]), parseInt(dm[2]) - 1, parseInt(dm[3]), h, mi, 0)
    }

    // --- Calendar discovery (`gcalcli list`) --------------------------------

    function _listOne(acc) {
        var cmd = _envForAccount(acc.alias).concat(["gcalcli", "--nocolor", "list"])
        var proc = listerComponent.createObject(root, { alias: acc.alias, cmd: cmd })
        _listers[acc.alias] = proc
        proc.start()
    }

    // gcalcli list output (with --nocolor):
    //   " Access  Title"
    //   " ------  -----"
    //   "  owner  Some Calendar"
    //   " reader  Other Calendar"
    function _parseListOutput(text) {
        var lines = text.split("\n")
        var cals = []
        for (var i = 0; i < lines.length; i++) {
            var line = lines[i]
            var trimmed = line.replace(/^\s+/, "")
            if (trimmed === "") continue
            if (trimmed.indexOf("Access") === 0) continue
            if (trimmed.indexOf("---") === 0) continue
            // Split on first run of 2+ spaces.
            var m = trimmed.match(/^(\S+)\s{2,}(.+)$/)
            if (!m) continue
            cals.push({ access: m[1], title: m[2] })
        }
        return cals
    }

    function _onListDone(alias, text, ok) {
        if (ok) {
            var cals = _parseListOutput(text)
            var copy = Object.assign({}, root.calendarsByAccount)
            copy[alias] = cals
            root.calendarsByAccount = copy

            // Heuristic: the account's primary calendar is owned and its title
            // looks like an email address.
            for (var i = 0; i < cals.length; i++) {
                if (cals[i].access === "owner" && /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(cals[i].title)) {
                    var emails = Object.assign({}, root._accountEmails)
                    emails[alias] = cals[i].title
                    root._accountEmails = emails
                    break
                }
            }
        }
        var l = _listers[alias]
        if (l) { l.destroy(); delete _listers[alias] }
        _pendingListers = Math.max(0, _pendingListers - 1)
        if (_pendingListers === 0 && _refreshAfterDiscovery) {
            _refreshAfterDiscovery = false
            root.refresh()
        }
    }

    // --- Config load/save ----------------------------------------------------

    Component.onCompleted: loadProc.running = true

    Process {
        id: loadProc
        command: ["sh", "-c", "cat '" + root.configPath + "' 2>/dev/null"]
        stdout: StdioCollector {
            onStreamFinished: {
                var t = this.text.trim()
                if (t !== "") {
                    try {
                        var o = JSON.parse(t)
                        if (typeof o.refresh_interval_minutes === "number")
                            root.refreshIntervalMinutes = o.refresh_interval_minutes
                        if (typeof o.lookahead_days === "number")
                            root.lookaheadDays = o.lookahead_days
                        if (Array.isArray(o.accounts)) root.accounts = o.accounts
                    } catch (e) {
                        root.lastError = "settings.json: " + e
                    }
                }
                // Run discovery first; refresh is triggered when it completes
                // so events have the right authuser= for URL routing.
                _refreshAfterDiscovery = true
                root.discoverCalendars()
            }
        }
    }

    Process { id: saveProc }

    Timer {
        interval: Math.max(1, root.refreshIntervalMinutes) * 60000
        running: true
        repeat: true
        onTriggered: root.refresh()
    }

    Timer {
        interval: 60000
        running: true
        repeat: true
        onTriggered: root._recomputeNext()
    }

    // --- Subprocess components ----------------------------------------------

    Component {
        id: fetcherComponent
        Process {
            id: fp
            property int idx: -1
            property var account: ({})
            property var cmd: []
            property string _text: ""
            property string _err: ""

            function start() {
                fp.command = cmd
                fp.running = true
            }

            stdout: StdioCollector { onStreamFinished: { fp._text = this.text } }
            stderr: StdioCollector { onStreamFinished: { fp._err = this.text } }
            onExited: function(code) {
                var ok = (code === 0)
                root._onFetchDone(fp.idx, fp.account, fp._text, ok, fp._err || ("gcalcli exit " + code))
            }
        }
    }

    Component {
        id: listerComponent
        Process {
            id: lp
            property string alias: ""
            property var cmd: []
            property string _text: ""

            function start() {
                lp.command = cmd
                lp.running = true
            }

            stdout: StdioCollector { onStreamFinished: { lp._text = this.text } }
            onExited: function(code) {
                root._onListDone(lp.alias, lp._text, code === 0)
            }
        }
    }

    Component {
        id: notifierComponent
        Process {
            id: np
            property int seq: 0
            property var event: ({})
            property var cmd: []
            property string _text: ""

            function start() {
                np.command = cmd
                np.running = true
            }

            stdout: StdioCollector { onStreamFinished: { np._text = this.text } }
            onExited: function(code) {
                root._onNotifierDone(np.seq, np.event, np._text)
            }
        }
    }
}
