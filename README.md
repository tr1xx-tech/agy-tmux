# 🚎 Antigravity for SSH (`gem`) -- Region Bypass Branch (`bypass`)

A powerful, all-in-one wrapper and session manager for `agy` (Antigravity CLI). It automatically isolates your sessions in `tmux` **and incorporates a built-in region check bypass** directly within the `gem` command.

> [!IMPORTANT]
> **Why is this `bypass` branch needed?**
> Starting from Antigravity CLI updates (**v1.1.2 / v1.2.2+**), Google introduced strict region eligibility blocking (`Eligibility check failed: Your current account is not eligible for Antigravity...`) and Long-Running Operation (`LRO`) verification. Even if you use a VPN, `agy` often checks your Google Account registration territory (`regionCode`) or blocks session streams with `403 Forbidden` / `404 Not Found` modals upon startup.
>
> **This branch (`bypass`) completely eliminates these region errors without modifying or overwriting your official `agy` binary.**

---

## 🚀 Quick Install (Bypass Branch)

Run this single command to install `gem` with the built-in region check bypass globally on your server:

```bash
curl -sL https://raw.githubusercontent.com/tr1xx-tech/agy-tmux/bypass/install.sh | bash
```

*During installation, the script verifies dependencies (`tmux`, `python3`) and installs `mitmproxy` automatically.*

---

## 🎑 How the Built-In Region Bypass Works (`mitmdump`)

Instead of requiring external systemd daemons, background services, or modified binaries, **the entire bypass mechanism is 100% self-contained inside the single `gem` file**:

1. **On-Demand Inline Proxy (`mitmdump`):** When you type `gem` (or `gem -c`, `gem 1`), the script dynamically selects a free TCP port and launches a lightweight `mitmdump` (from `mitmproxy`) instance directly in memory scoped strictly to your current CLI invocation.
2. **Transparent Traffic Interception:** `gem` automatically passes `HTTP_PROXY`, `HTTPS_PROXY`, and `SSL_CERT_FILE` environment variables exclusively to the `agy` process without affecting the rest of your operating system.
3. **Payload Manipulation:** The internal proxy addon intercepts and modifies critical Google Cloud Code API responses on the fly:
   - **`loadCodeAssist`**: Strips out `"ineligibleTiers"` (`UNSUPPORTED_LOCATION`) and forces `"allowedTiers"` to include `Antigravity`.
   - **`onboardUser`**: Intercepts `403 Forbidden` errors and returns a completed Long-Running Operation (`LRO`) JSON (`{"done": true, "response": {...}}`) so `agy` never queries `GET /v1internal/` (preventing the robot `404 Not Found` HTML crash).
   - **`fetchUserInfo` / `fetchAdminControls`**: Overrides your account profile `"regionCode"` to `"US" or `"EU" or `GB"`.
4. **Auto-Cleanup:** As soon as you exit your Antigravity CLI session or close the `tmux` window, `gem` cleanly terminates the background `mitmdump` process so no proxy lingers in the background.

---

## �? Why else is this useful?

if you run Antigravity CLI on a remote server via SSH, this script solves multiple workflow challenges simultaneously:
- **Connection Drops:** If your SSH connection disconnects, your `agy` session and its ongoing tasks won't die. Simply reconnect and type `gem` to resume exactly where you left off.
- **Update Immunity:** Because `gem intercepts traffic dynamically rather than patching files, updating official Antigravity (`agy updatel) will **never** break or overwrite your region bypass.
- **Multitasking:** Need to run multiple agents in parallel for different projects? Use `gem 1`, `gem 2`, etc., to spawn and jump between isolated background sessions in seconds (each session automatically receives its own isolated bypass port).
- **Convenience:** Replaces tedious `tmux new-session`, `tmux attach`, or `tmux kill-session` commands with a fast, single-word shortcut `gem`.

---

## 💤 Usage

Simply type `gem` to start or attach to the default `agy` session with region bypass active.

```text
Usage: gem [options] [suffix]

Manage tmux sessions for agy (Antigravity CLI) with built-in region bypass.

Commands & Options:
  -h, --help, h, help      Show this help message
  -s, --session SUFFIX    Open or create session agy-<suffix>
  -d, --delete SUFFIX     Delete session agy-<suffix> hor "agy" if no suffix)
  -l, --list, l, list      List all active tmux sessions
  -c, --continue, c        Start agy with the last dialog (agy -c) if session is created
  [suffix]                 Open or create session agy-<suffix> (positional)
  d [suffix]               Delete session agy-<suffix> (positional)

Examples:
  gem                     Open/create session "agy" and run "agy" (with bypass)
  gem 1                    Open/create session "agy-1" and run "agy" (with bypass)
  gem c                    Open/create session "agy" and run "agy -c" (with bypass)
  gem c 1                  Open/create session "agy-1" and run "agy -c" (with bypass)
  gem -d 1 / gem d 1       Delete session "agy-1"
  gem -l / gem l           List all active tmux sessions
`
