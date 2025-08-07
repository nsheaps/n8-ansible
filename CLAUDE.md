# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an Ansible project for automated configuration of home network hosts (both Linux workstations and servers). It uses `ansible-pull` for self-provisioning and supports multiple Linux distributions (Ubuntu, Debian, Fedora, Arch, Pop!_OS, etc.).

## Agent instructions

**CRITICAL:** You are expected to update CLAUDE.md frequently with things that you learn or feedback given to you. You should always try to be improving yourself.
**CRITICAL:** The user may also use other AI tools like cursor. Make sure those rules are in sync with these.
**CRITICAL:** Documentation helps both you and the user understand what's going on. Make sure any change is accompanied by appropriate documentation updates. Don't try to shove all documentation into the readme. Information in this claude.md may conflict or have info not in README.md or other documentation. Ask if you need clarification

## Core Architecture

This project merges in https://github.com/fabricesemti80/home.ansible.linux-config-with-ansible-pull to n8-ansible. Some references may still reference the upstream home.ansible.linux-config-with-ansible-pull original configuration.

Originally, this project used github actions to connect to openvpn and then run ansible against hosts when changes are made.

The new intended design is to use ansible-pull for hosts to continuously check for updates and apply changes from this repository in an eventually-consistent model. There may still be cases where we want to push some changes (such as devices where ansible can't run directly on it, like network devices, API calls, or cloud services)

Desired features (checked is completed):
- [ ] Support for linux
  - [ ] Proxmox role
  - [ ] User syncing and creation
- [ ] Support for mac
- [ ] Support for Windows
- [ ] Support for Windows/WSL
- [ ] Secret storage using 1pass
- [ ] Bootstrap script
  - [ ] Installs `gum`
  - [ ] Installs `1pass` (previously lastpass)
  - [ ] Installs `ansible`
  - [ ] Installs `brew` (including on linux hosts, though brew should only be used for specific cases)
  - [ ] installs `gh`
  - [ ] installs `ca-certificates`
  - [ ] installs `git`
  - [ ] installs `curl`
  - Sets up SSH
    - [ ] for mac
    - [ ] for linux
    - [ ] for wsl
    - [ ] for windows?
  - [ ] Logs into 1pass (to fetch secrets)
  - [ ] Uses gum to prompt for information needed to run the next step
  - [ ] Runs the bootstrap ansible playbook
    - [ ] Updates this repo to include a host_vars file for this new host
    - [ ] Does a dry run of the local playbook and exits
  - [ ] confirms that the dry run looks correct
  - [ ] If all looks good, runs the first ansible-pull for that host
  - When the ansible playbook for that host is run (either by the initial ansible pull or the cron), it does:
    - [ ] Creates the `ansible` user
    - [ ] Syncs known hosts to the host
    - [ ] Checks for new known hosts on the host and opens a PR to add them
    - [ ] Sets up the cron for running ansible-pull on a 30 minute schedule[^1]
<!-- TODO: UPDATE THIS LIST! -->

[^1]: This is currently called "provision" but we should come up with a better name

### Playbook Structure
- **local.yml**: Main playbook that ansible-pull executes by default. Orchestrates role execution:
  1. Pre-tasks: Updates package cache based on distribution
  2. Applies `base` role to all hosts
  3. Applies `workstation` or `server` role based on host group
  4. Post-tasks: Cleanup and sends completion/failure alerts

### Role Organization
- **base/**: Applied to all hosts - users, SSH, packages, system configuration
- **workstation/**: Desktop environment configuration (GNOME/MATE), GUI apps, development tools
- **server/**: Server-specific configuration - monitoring, unattended upgrades, firewall

### Variable Hierarchy
- **group_vars/**: Variables applied to all systems
- **host_vars/**: Host-specific variables (named by hostname)
- **roles/*/vars/**: Distribution-specific variables (e.g., Ubuntu.yml, Archlinux.yml)

### Inventory
- **hosts**: Defines host groups (server, workstation)
- **ansible.cfg**: Sets default inventory location and logging

## Common Development Commands

```bash
# Run playbook locally (dry run)
ansible-playbook local.yml --check

# Run playbook locally (apply changes)
sudo ansible-playbook local.yml

# Run specific tags only
ansible-playbook local.yml --tags "base,packages"

# Run against specific host
ansible-playbook local.yml --limit hostname

# Test ansible-pull locally
sudo ansible-pull -U https://github.com/nsheaps/n8-ansible.git -C main

# Check syntax
ansible-playbook local.yml --syntax-check

# List all tasks that would run
ansible-playbook local.yml --list-tasks

# List all available tags
ansible-playbook local.yml --list-tags
```

## Key Implementation Details

### Automation
- Cron job configured to run ansible-pull every 30 minutes (configurable via `ansible_cron_minute`)
- Healthchecks.io integration for monitoring successful runs
- Automatic cleanup of ansible cache on reboot


## Important Files

- **local.yml**: Main entry point for ansible-pull
- **roles/base/templates/provision.sh.j2**: Template for the provision script
- **roles/base/tasks/system_setup/cron.yml**: Sets up automated provisioning
- **playbooks/send_completion_alert.yml**: Healthchecks.io notification
