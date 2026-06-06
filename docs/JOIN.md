# `bin/join` — one-line ansible-pull enrollment

The simplest way to put a Mac or Linux machine under ansible-pull management.
One command. No 1Password, no gum, no SSH-server setup. Run it on a laptop or
server and that machine starts pulling and applying this repo's config on a
schedule — so you can then manage *anything* on it with Ansible (packages,
services, users, files, configs).

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/nsheaps/n8-ansible/main/bin/join)
```

> Use the `bash <(curl ...)` form (not `curl ... | bash`) so the script keeps
> your terminal as stdin and can prompt you.

## What it does

1. **Installs `git` + `ansible`** via the platform package manager
   (Homebrew / apt / dnf / pacman).
2. **Prompts for three things** (only when run interactively; otherwise uses
   defaults / env vars / flags):
   - **Name** for this machine in the inventory (default: `hostname -s`)
   - **Where to pull from** — repo URL + branch
   - **How often** to check for updates (minutes)
3. **Creates a dedicated `ansible` user** with passwordless sudo and installs a
   small pull loop that runs *as that user*:
   - **Linux** — an `ansible` crontab entry calling `/usr/local/bin/ansible-pull-run`
   - **macOS** — a LaunchDaemon (`com.n8-ansible.pull`, `UserName=ansible`)
     calling the same script
4. **Opens a draft PR** adding `host_vars/<name>.yml` and the inventory entry.
   It runs `gh auth login` first if you aren't already logged in. If `gh` isn't
   available it prints the files for you to add manually instead.
5. **Runs the first pull immediately.**

## Why an `ansible` user (and not root)?

The pull runs as a dedicated `ansible` account that has `NOPASSWD: ALL` sudo
(via `/etc/sudoers.d/ansible-pull`). That keeps the automation off the root
login while still letting `become: true` tasks do anything they need. This
matches the user model the `ansible-pull` role already uses.

## Non-interactive use

Every prompt has a flag and an environment variable, so it runs unattended in
CI or over a pipe:

```bash
ANSIBLE_PULL_NAME=mylaptop \
ANSIBLE_PULL_MINUTES=15 \
ANSIBLE_PULL_NO_PR=1 \
  bash bin/join
```

| Flag          | Env var                | Default                        |
|---------------|------------------------|--------------------------------|
| `--name`      | `ANSIBLE_PULL_NAME`    | `hostname -s`                  |
| `--repo`      | `ANSIBLE_PULL_REPO`    | this repo's HTTPS URL          |
| `--branch`    | `ANSIBLE_PULL_BRANCH`  | `main`                         |
| `--minutes`   | `ANSIBLE_PULL_MINUTES` | `30`                           |
| `--group`     | `ANSIBLE_PULL_GROUP`   | `workstation`                  |
| `--no-pr`     | `ANSIBLE_PULL_NO_PR=1` | open the PR                    |
| `--uninstall` | —                      | remove the local pull schedule |

## After enrollment

- **The schedule won't do host-specific work until the PR is merged.** Until
  this machine's name is in `./hosts`, `ansible-pull` matches nothing for it.
  Merge the draft PR and the next pull applies its config.
- **Generated `host_vars/<name>.yml` sets `ansible_pull_enabled: false`** so the
  heavier `ansible-pull` role doesn't install a *second*, competing cron job.
  `bin/join` owns the pull schedule for hosts enrolled this way.
- **Edit `user_configs`** in the generated host_vars to map this machine's login
  user(s) to a profile in `roles/users/`.

## Operating it

```bash
# Run a pull right now
sudo -H -u ansible /usr/local/bin/ansible-pull-run

# Watch the log
tail -f /var/log/ansible-pull.log

# See the schedule
sudo crontab -u ansible -l                  # Linux
sudo launchctl list | grep n8-ansible       # macOS

# Remove the local schedule (leaves the ansible user in place)
bash bin/join --uninstall
```

## How it differs from `bin/bootstrap`

`bin/bootstrap` is the full-featured onboarding flow (1Password, gum UI, SSH
setup, dry-run confirmation). `bin/join` is the deliberately minimal path: get a
machine pulling as fast as possible with the fewest moving parts. Use whichever
fits — they both end with the host on the same ansible-pull model.
