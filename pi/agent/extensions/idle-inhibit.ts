import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { spawn } from "node:child_process";

function run(action: "begin" | "end") {
  const child = spawn(
    process.env.SHELL || "/bin/sh",
    ["-lc", `~/.local/bin/ai-idle-inhibit ${action}`],
    {
      detached: false,
      stdio: "ignore",
    },
  );

  child.unref();
}

export default function idleInhibitExtension(pi: ExtensionAPI) {
  pi.on("turn_start", async () => {
    run("begin");
  });

  pi.on("turn_end", async () => {
    run("end");
  });

  pi.on("session_shutdown", async () => {
    run("end");
  });
}
