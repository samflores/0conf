import Quickshell
import "./bar"
import "./osd"
import "./notifications"

ShellRoot {
    Variants {
        model: Quickshell.screens

        BarExclusion {}
    }

    Variants {
        model: Quickshell.screens

        Bar {}
    }

    Variants {
        model: Quickshell.screens

        Osd {}
    }

    Variants {
        model: Quickshell.screens

        NotificationLayer {}
    }
}
