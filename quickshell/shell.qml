import Quickshell
import "./bar"
import "./osd"

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
}
