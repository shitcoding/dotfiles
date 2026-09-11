#!/usr/bin/env python3
"""Clear every shell pane in the current tab, leaving TUI apps alone.

Port of the tmux binding:

    bind L run-shell "tmux list-panes -F '#{pane_id} #{pane_current_command}' |
      while read -r p c; do case $c in zsh|bash|tmux) tmux send-keys -t $p C-l ;; esac; done"

tmux's `list-panes` defaults to the current WINDOW, so the herdr equivalent is
the current TAB. Everything runs over ONE socket connection rather than N CLI
invocations -- a `herdr pane process-info` spawn per pane would reintroduce, in
miniature, exactly the per-pane-scan cost the tmux setup was tuned to avoid.

Bind via config.toml:

    [[keys.command]]
    key = "prefix+shift+l"
    type = "shell"
    command = "~/.dotfiles/herdr/scripts/clear-panes.py"

NOTE prefix+shift+l is herdr's default `swap_pane_right`; rebind that first or
`herdr config check` will report the duplicate and silently disable one of them.

Pass --dry-run to print what would be cleared without sending anything.
"""

import json
import os
import socket
import sys

# A pane is "at a prompt" only if every foreground process is a shell. Anything
# else (nvim, htop, a running build) means a keypress would reach the program.
SHELLS = {"zsh", "bash", "sh", "fish", "dash", "ksh", "tmux"}


def rpc(path, method, params, _seq=[0]):
    """One request per connection -- the herdr socket closes after each reply.

    Still much cheaper than shelling out to the `herdr` binary per pane: no
    process spawn, no binary load, just a UNIX-socket round trip.
    """
    _seq[0] += 1
    sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    sock.settimeout(5)
    sock.connect(path)
    try:
        sock.sendall(
            (json.dumps({"id": f"clear-panes:{_seq[0]}", "method": method, "params": params}) + "\n").encode()
        )
        buf = b""
        while not buf.endswith(b"\n"):
            chunk = sock.recv(65536)
            if not chunk:
                break
            buf += chunk
    finally:
        sock.close()
    reply = json.loads(buf.decode().splitlines()[0])
    if "error" in reply:
        raise RuntimeError(f"{method}: {reply['error']}")
    return reply["result"]


def main():
    dry = "--dry-run" in sys.argv
    path = os.environ.get("HERDR_SOCKET_PATH") or os.path.expanduser("~/.config/herdr/herdr.sock")
    if not os.path.exists(path):
        sys.exit(f"no herdr socket at {path}")

    panes = rpc(path, "pane.list", {})["panes"]

    # Prefer the tab the binding fired in; fall back to the focused pane's tab
    # so the script is also usable straight from a shell.
    tab = os.environ.get("HERDR_ACTIVE_TAB_ID")
    if not tab:
        focused = next((p for p in panes if p.get("focused")), None)
        if not focused:
            sys.exit("no focused pane and HERDR_ACTIVE_TAB_ID unset")
        tab = focused["tab_id"]

    cleared, skipped = [], []
    for pane in (p for p in panes if p.get("tab_id") == tab):
        pid = pane["pane_id"]
        procs = rpc(path, "pane.process_info", {"pane_id": pid})["process_info"]
        names = [p.get("name", "") for p in procs.get("foreground_processes", [])]
        # No reported process => an idle shell that has not been polled yet.
        if names and not all(n in SHELLS for n in names):
            skipped.append((pid, ",".join(names)))
            continue
        cleared.append((pid, ",".join(names) or "shell"))
        if not dry:
            rpc(path, "pane.send_keys", {"pane_id": pid, "keys": ["ctrl+l"]})

    verb = "would clear" if dry else "cleared"
    for pid, what in cleared:
        print(f"{verb} {pid} ({what})")
    for pid, what in skipped:
        print(f"skipped {pid} ({what})")


if __name__ == "__main__":
    main()
