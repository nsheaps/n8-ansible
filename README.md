# n8-ansible

This is the home network setup for @nsheaps. This project is used to set up both Windows and Linux hosts on a home network.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

- Ansible (version 2.9 or later)
- Python (version 3.6 or later)

### Installation

1. Clone the repository:
    ```
    git clone https://github.com/nsheaps/n8-ansible.git
    ```
2. Navigate to the project directory:
    ```
    cd n8-ansible
    ```
3. Install the required Python packages:
    ```
    pip install -r requirements.txt
    ```

## Running Locally

To run the Ansible playbooks locally, use the following command:

## Dry Run

To perform a "dry run" (i.e., simulate the playbook run without making any changes), use the `--check` flag:


## Adding a New Host

To add a new host to the Ansible inventory:

1. Add the host's details to the appropriate inventory file (e.g., `inventory/production` or `inventory/staging`).
2. If necessary, add any host-specific variables to a new file in the `host_vars` directory.

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details