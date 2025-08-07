# n8-ansible

This is the home network setup for @nsheaps. This project is used to set up both Windows and Linux hosts on a home network. It is based on other upstream projects. This is specific to my setup and I would not recommend using it as-is, but I leave it public for reference by others.

> [!NOTE]
> In many cases, secrets are required for certain tasks, like those found in variables that need to be encrypted 

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

- Ansible (version 2.9 or later)
- Python (version 3.6 or later)

```bash
# macOS or linuxbrew
brew install ansible

# apt (debian, ubuntu, etc.)
sudo apt update
sudo apt install ansible
```

### Installation

1. Clone the repository:
    ```
    git clone https://github.com/nsheaps/n8-ansible.git
    ```
2. Navigate to the project directory:
    ```
    cd n8-ansible
    ```
3. Do a dry run:
    ```
    ansible-playbook ./playbooks/playbook.yml --inventory ./inventory/inventory.cfg --check
    ```

## Running Locally

To run the Ansible playbooks locally, use the following command:

## Dry Run

To perform a "dry run" (i.e., simulate the playbook run without making any changes), use the `--check` flag:

`ansible-playbook ./playbooks/site.yml --inventory ./inventory/n8house --check`

## Configuring New Hosts
TBD UPDATE
> [!IMPORTANT]
> Don't forget to add the new host to the inventory and if necessary, set up a static DHCP reservation on the network gateway.

#### set up a new host using ansible pull
**NOTE:** Host must already be defined.

```sh
# -U: the https url of the repo
# -C: needed only if using certain branhc (omit, if using the branch defined in the config)
sudo ansible-pull -U https://github.com/nsheaps/n8-ansible.git -C main
```


### Linux
TBD UPDATE
Quick run for new node, see [`./bin/bootstrap`](./bin/bootstrap) for more details

### Windows
TBD UPDATE
See also: [Ansible documentation](https://docs.ansible.com/ansible/latest/user_guide/windows_setup.html)

1. Install Windows Remote Management (WinRM) on the new host.
2. Create a new user for Ansible to use.
3. Add the Ansible user to the Administrators group.
4. Configure WinRM to allow connections from the control node. You can use the `ConfigureRemotingForAnsible.ps1` script provided in the Ansible GitHub repository.
5. Test the setup by running `ansible -m win_ping <new-host-ip>` from the control node.

### Windows Subsystem for Linux (WSL)

1. Install WSL on the new host.
2. Install Ansible within WSL using the same steps as for Linux.
3. Follow the same steps as for Linux to create a new user, copy the SSH key, and test the setup.
4. Forward the port used by SSH (tbd) because WSL uses NAT instead of bridged networking.

Remember to update the inventory file (`inventory/production`) with the details of the new host.

# Personal Ansible Desktop Configs

This is a repository utilising `ansible-pull` to configure Linux desktop and server envionments. 
It is based on the awsome [LearnLinuxTV/personal_ansible_desktop_configs](https://github.com/LearnLinuxTV/personal_ansible_desktop_configs), however it has been heavily modified, to reflect my needs.

## Disclaimer
This repository contains a copy of the Ansible configuration that I use for laptops, desktops as well as servers.
Please don't directly use this against your own machines, as it is something I developed for myself and may not translate to your use-case. It even configures OpenSSH, so if you run it you may get locked out. 

## How does it work?
As mentioned above, it uses Ansible pull, so some familiarity with that is required.

The folder structure breaks down like this:

**local.yml**: This is the Playbook that Ansible expects to find by default in pull-mode, think of it as an "index" of sorts that pulls other Playbooks in.


**ansible.cfg**: Configuration settings for Ansible goes here.


**group_vars/**: This directory is where I can place variables that will be applied on every system.


**host_vars/**: Each laptop/desktop/server gets a host_vars file in this folder, named after its hostname. Sets variables specific to that computer.


**hosts**: This is the inventory file. Even in pull-mode, an inventory file can be used. This is how Ansible knows what group to put a machine in.


**playbooks**: Additional playbooks that I may want to run, or have triggered.


**roles/**: This directory contains my base, workstation, and server roles (and future roles I am adding as-and-when). Every host gets the base role. Then either 'workstation' or 'server', depending on what it is.

**roles/base**: This role is for every host, regardles of the type of device it is. This role contains things that are intended to be on every host, such as default configs, users, etc.

**roles/workstation**: After the base role runs on a host, this role runs only on hosts that are designated to be workstations. GUI-specific things, such as GUI apps (Firefox, etc), Flatpaks, wallpaper, etc. Has a folder for the GNOME and MATE desktops.

**roles/server**: After the base role runs on a host, this role runs only on hosts designated as servers. Monitoring plugins, unattended-updates, server firewall rules, and other server-related things are configured here.

After it's run for the first time manually, this Ansible config creates its own Cronjob for itself on that machine so you never have to run it manually again going forward, and it will track all future commits and run them against all your machines as soon as you commit a change. You can find the playbook for Cron in the base role.
