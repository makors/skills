---
name: csl
description: "Use for any TJHSST CSL sysadmin work: servers, services, ansible, passcard, or anything on *.csl.tjhsst.edu / *.tjhsst.edu infrastructure."
---

# CSL

The Computer Systems Lab at TJHSST is run by student sysadmins, and I'm one of them. We run real services the school depends on: Ion (the intranet), @tjhsst.edu mail, Director (student and club sites), plus servers, workstations, HPC clusters, storage, auth and more. Other sysadmins share all of this, so be careful with anything people use.

## Where things are

- `~/Developer/ansible`: config for most machines. `hosts` is the inventory, `<service>.yml` are playbooks, `roles/` has the config. If a change belongs in ansible, put it there and apply with `ansible-playbook` (limit it to the hosts you mean). Its README has the team's rules.
- **If it isn't immediately obvious which machine runs something or what its hostname is, look in ansible first** (`hosts`, `host_vars/`, `group_vars/`, the service's playbook and role). Service names often aren't the machines: e.g. mail.tjhsst.edu is actually served by `smith.tjhsst.edu` and `casey.tjhsst.edu`.
- `~/Developer/keybase-passcard`: shared team passwords (GPG). `./passcard.py -h`.
- Hosts are usually `<name>.csl.tjhsst.edu` when connected to the WireGuard VPN. If these hostnames do NOT work, you must go through my account on the remote access server: `ssh 2028bconrad@ras2.tjhsst.edu`. The SSH key should already work. Using it as a jump host (`ssh -J 2028bconrad@ras2.tjhsst.edu root@<host>.csl.tjhsst.edu`) keeps passwords on this machine.

## Credentials

My SSH key and GPG key are already unlocked, so you never need a passphrase. Use credentials, don't look at them: never print, log, commit or paste a password or code into chat.

**Passcard (shared root/service passwords):**
- `./passcard.py -n get <name> | tail -1` (`-n` skips git; `tail -1` drops status lines). Feed it straight into the command that needs it, e.g. `sshpass -f <(./passcard.py -n get <name> | tail -1) ssh root@<host>`, or `--vault-password-file <(...)` for ansible.
- Don't change team passwords or who can read them (`passcard.py edit/add/remove-user`, `rotate.py`, `revoke.py`). They push to git for everyone.
- Leave 2FA/backup codes, CA signing keys and the master/superuser accounts alone unless I specifically ask.

**1Password (`op-agent`): my own logins, including 2028bconrad.** `op-agent` is the `op` CLI limited to my `tjCSL` vault. Use it whenever you need credentials for a web interface or my own account. My main TJ login (2028bconrad) is the **TJ Intranet** item.
- Find items: `op-agent item list --vault tjCSL`
- Password: `op-agent read "op://tjCSL/<item>/password"`
- One-time code: `op-agent item get "<item>" --vault tjCSL --otp`
- If a login has no separate prompt for the one-time code (e.g. SSH without a key, or some web interfaces), the password field takes **`<password><otp>`** run together. Get the code right before you use it, because it expires in ~30s. Example:
  `sshpass -f <(printf '%s%s' "$(op-agent read 'op://tjCSL/TJ Intranet/password')" "$(op-agent item get 'TJ Intranet' --vault tjCSL --otp)") ssh 2028bconrad@<host>`
- Typing these into a login form is fine. Don't echo them anywhere else.

## Browser

For web UIs (dashboards, iLO consoles, admin panels), use whatever browser tool you have. Sign in with credentials from `op-agent` (above). If what you need isn't in the vault, ask me.

## Work where I can see it

Run server work in the shared tmux session `csl` so I can `tmux attach -t csl` and watch. Use as many windows as you need, but name each one so I can tell which task it belongs to (e.g. `ntp-drift/ntp1`, `ntp-drift/ntp2`). Tell me the names. Close them when you're done; if something's wrong or you need me, leave the window open and put `!` in front of its name.

A reliable way to drive it: `tmux send-keys -t csl:NAME -l 'cmd; echo "::done N $?::"'` then `send-keys Enter`, poll `tmux capture-pane -p -J -S -1000` for the marker, and read the output. It works inside SSH sessions too. Avoid pagers and interactive programs.

## Check with me

Before anything that's hard to undo or would take down something people are using, and before pushing to shared repos. Otherwise, use your judgment.

## Claude in Chrome

If you need access to something on the web that isn't in the `tjCSL` vault, and you have Claude in Chrome, use it before asking me: it can request a login from my full 1Password (`request_credentials` / `autofill_credential`). I approve it, and 1Password fills it without you seeing it.
