import Quickshell
import "./bar"

ShellRoot {
    Variants {
        model: Quickshell.screens

        BarExclusion {}
    }

    Variants {
        model: Quickshell.screens

        Bar {}
    }
}
