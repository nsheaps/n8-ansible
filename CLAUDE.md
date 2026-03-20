# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Personal home-network IaC project using Ansible (via `ansible-pull`) to configure Linux, macOS, and WSL hosts. Each host pulls config from this repo on a schedule and applies it.

## Agent instructions

**CRITICAL:** You are expected to update CLAUDE.md frequently with things that you learn or feedback given to you. You should always try to be improving yourself.
**CRITICAL:** The user may also use other AI tools like cursor. Make sure those rules are in sync with these.
**CRITICAL:** Documentation helps both you and the user understand what's going on. Make sure any change is accompanied by appropriate documentation updates. Don't try to shove all documentation into the readme. Information in this claude.md may conflict or have info not in README.md or other documentation. Ask if you need clarification

### Continuous Improvement Philosophy

**ALWAYS leave code better than you found it.** This means:
- Create proper test infrastructure instead of ad-hoc test files
- Organize temporary work into appropriate directories (e.g., `tests/`, `.claude/tmp/`)
- Document new patterns and learnings for future reference
- Refactor and improve existing code when you encounter issues
- Add helpful comments and documentation where clarity is needed
- Create reusable components instead of one-off solutions
- Clean up after yourself but preserve useful artifacts in organized locations

## Core Architecture

Uses `ansible-pull` for hosts to continuously check for updates and apply changes in an eventually-consistent model.

### Hosts

| Hostname | OS | Groups |
|---|---|---|
| n8laptop | Linux | laptop, linux |
| n8htpc | Linux | htpc, linux |
| n8htpc-wsl | WSL (on n8htpc) | htpc, wsl |
| n8work | macOS (Nathans-64GB-MBP) | workstation, macos |

### Inventory Groups

Hosts are in **both** purpose and OS groups:
- **Purpose**: `laptop`, `htpc`, `workstation`
- **OS family**: `linux`, `macos`, `wsl`

### Playbook Structure

- **local.yml**: Main playbook for `ansible-pull`. Applies `ansible-pull` role to all hosts, then runs `update-notifier` as a post-task.
- **playbooks/bootstrap.yml**: Initial host setup.

### Role Organization

- **ansible-pull/**: Sets up the ansible user, cron schedule, and provision script
- **update-notifier/**: Sends a system notification after updates (version tag or SHA, with compare link). Supports Linux, macOS, and WSL.
- **bootstrap/**: Initial host bootstrapping
- **always-on-if-plugged-in/**: Keeps laptops awake when lid is closed and plugged in
- **_empty/**: Template for new roles

Host-specific roles can be added and applied per host or group. The architecture supports different roles for different hosts via inventory groups.

### Variable Hierarchy

- **group_vars/**: Variables applied to all systems
- **host_vars/**: Host-specific variables (named by hostname)
- **roles/*/vars/**: OS/distribution-specific variables

### Inventory

- **hosts**: Defines host groups (by purpose and OS family)
- **ansible.cfg**: Sets default inventory location

## Common Development Commands

```bash
# Run playbook locally (dry run)
ansible-playbook local.yml --check

# Run playbook locally (apply changes)
sudo ansible-playbook local.yml

# Run against specific host
ansible-playbook local.yml --limit hostname

# Test ansible-pull locally
sudo ansible-pull -U https://github.com/nsheaps/n8-ansible.git -C main

# Check syntax
ansible-playbook local.yml --syntax-check
```

## Testing

```bash
# Validate playbook syntax
ansible-playbook tests/playbooks/test_syntax.yml

# Run all tests
for test in tests/playbooks/*.yml; do
    ansible-playbook "$test"
done
```

## Important Files

- **local.yml**: Main entry point for ansible-pull
- **hosts**: Inventory with purpose and OS groups
- **bin/bootstrap**: Interactive bootstrap script for new hosts
- **roles/ansible-pull/**: Automated pull setup
- **roles/update-notifier/**: Post-update notification system
