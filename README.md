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

> [!IMPORTANT]
> Don't forget to add the new host to the inventory and if necessary, set up a static DHCP reservation on the network gateway.

### Linux

Quick run for new node, see [`./bin/bootstrap`](./bin/bootstrap) for more details

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
