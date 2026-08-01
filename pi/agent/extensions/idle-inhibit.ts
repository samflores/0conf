import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { spawn } from "node:child_process";
import { randomUUID } from "node:crypto";
import { promises as fs } from "node:fs";
import { join } from "node:path";
import process from "node:process";

const LOCK_DIR = join(
  process.env.XDG_RUNTIME_DIR ??
    `/run/user/${process.getuid?.() ?? 1000}`,
  "pi-stasis-inhibit",
);
const STALE_TTL_MS = 24 * 60 * 60 * 1000;

function stasis(action: "pause" | "resume") {
  spawn("stasis", [action], { stdio: "ignore" }).unref();
}

function lockFile() {
  return join(LOCK_DIR, `${process.pid}-${randomUUID()}.lock`);
}
let mine: string | null = null;

async function gcStale() {
  let names: string[];
  try {
    names = await fs.readdir(LOCK_DIR);
  } catch {
    return;
  }
  const now = Date.now();
  await Promise.all(
    names.map(async (name) => {
      const path = join(LOCK_DIR, name);
      const pid = Number.parseInt(name, 10);
      let alive = false;
      if (Number.isInteger(pid) && pid > 0) {
        alive = isAlive(pid);
      }
      let stale = false;
      try {
        const st = await fs.stat(path);
        if (now - st.mtimeMs > STALE_TTL_MS) stale = true;
      } catch {
        return;
      }
      if (!alive || stale) {
        try {
          await fs.unlink(path);
        } catch {}
      }
    }),
  );
}

function isAlive(pid: number): boolean {
  try {
    process.kill(pid, 0);
    return true;
  } catch {
    return false;
  }
}

async function countActive(): Promise<number> {
  try {
    const names = await fs.readdir(LOCK_DIR);
    return names.filter((n) => n.endsWith(".lock")).length;
  } catch {
    return 0;
  }
}

async function begin() {
  await fs.mkdir(LOCK_DIR, { recursive: true });
  await gcStale();
  mine = lockFile();
  await fs.writeFile(mine, String(process.pid), { flag: "wx" });
  stasis("pause");
}

async function end() {
  if (mine) {
    try {
      await fs.unlink(mine);
    } catch {}
    mine = null;
  }
  await gcStale();
  if ((await countActive()) === 0) stasis("resume");
}

export default function idleInhibitExtension(pi: ExtensionAPI) {
  pi.on("agent_start", async () => begin());
  pi.on("agent_end", async () => end());
  pi.on("session_shutdown", async () => end());
}
