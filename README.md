# n8-ansible

This is the home network setup for @nsheaps. This project is used to set up both Windows and Linux hosts on a home network.

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

### Linux

#### Install ssh server

This will be needed for Ansible to connect to the host.

```bash
sudo apt update
sudo apt install openssh-server
sudo systemctl status ssh
```

**Configure SSH to only accept connections from the local network

```bash
sudo nano /etc/ssh/sshd_config

# add the following lines:
# ListenAddress
# PermitRootLogin no
# PasswordAuthentication no
# PubkeyAuthentication yes
# AllowUsers <username>
# AllowGroups <groupname>
# AllowTcpForwarding no
# X11Forwarding no
# AllowAgentForwarding no
# PermitTunnel no
# AllowStreamLocalForwarding no
# GatewayPorts no
# PermitEmptyPasswords no
# ChallengeResponseAuthentication no
# UsePAM no
# UseDNS no
# LogLevel VERBOSE


```

#### Install Ansible

1. Install Ansible on the new host. On Ubuntu, you can do this with `sudo apt install ansible`.
2. Create a new user for Ansible to use. For example, `sudo adduser ansible`.
3. Add the Ansible user to the `sudo` group: `sudo usermod -aG sudo ansible`.
4. On your control node, generate an SSH key pair with `ssh-keygen`.
5. Copy the public key to the new host with `ssh-copy-id ansible@<new-host-ip>`.
6. Test the setup by running `ansible -m ping <new-host-ip>` from the control node.

Quick run:

```bash
sudo apt update
sudo apt install ansible
# make a user group for passwordless sudo
sudo groupadd super-sudo
# add /etc/sudoers.d/super-sudo
echo "%super-sudo ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/super-sudo

sudo adduser ansible # asks for password
sudo usermod -aG sudo ansible
# add ansible to super-sudo group
sudo usermod -aG super-sudo ansible

# first time, run ssh-keygen to generate
sudo su ansible # swap to the ansible account
ssh-keygen # generate ssh key pair

# get the Private Key onto other hosts
# for you to login as
ssh-copy-id -i ~/.ssh/id_rsa <new-user>@<new-host-ip>

# for you to make the ansible user the same across hosts
ssh-copy-id -i ~/.ssh/id_rsa ansible@<new-host-ip>

# for a brand new host to act as ansible, regardless of users
echo "${{ secrets.ANSIBLE_SSH_KEY }}" > ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa
ssh-add ~/.ssh/id_rsa # if you do this, the current user can use to auth as ansible. -d will remove in case you permit different users


# FINALLY
# copy over known_hosts file if known
echo "${{ secrets.SSH_KNOWN_HOSTS }}" > ~/.ssh/known_hosts
# create authorized_keys file to allow the key to ssh to the host
ssh-copy-id ansible@localhost 


echo "DON'T FORGET TO SET A DHCP RESERVATION FOR $HOSTNAME:$HOST_IP"
```

### Windows

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

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
