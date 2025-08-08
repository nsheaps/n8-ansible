# n8-ansible Command Line Tools

This directory contains command-line utilities for managing and testing the n8-ansible project.

## Available Commands

### ansible-test

Test runner for the n8-ansible project. Provides a convenient way to run all tests or specific test suites.

**Usage:**
```bash
ansible-test [OPTIONS] [TEST_NAME]  # With direnv
./bin/ansible-test [OPTIONS] [TEST_NAME]  # Without direnv
```

**Options:**
- `-h, --help` - Show help message
- `-v, --verbose` - Run with verbose output
- `-l, --list` - List available tests without running them

**Test Names:**
- `inheritance` - Test user inheritance system
- `users` - Test user configuration
- `syntax` - Test playbook syntax
- `all` - Run all tests (default)

**Examples:**
```bash
# Run all tests
ansible-test

# Run specific test
ansible-test inheritance

# Run with verbose output
ansible-test -v users

# List available tests
ansible-test --list
```

## Adding New Commands

When adding new commands to this directory:

1. Create an executable script with a descriptive name
2. Add a shebang line (`#!/bin/bash` or `#!/usr/bin/env python3`)
3. Include help text accessible via `-h` or `--help`
4. Document the command in this README
5. Make it executable: `chmod +x bin/your-command`

## Best Practices

- Keep commands simple and focused on a single task
- Use clear, descriptive names
- Always include help documentation
- Handle errors gracefully
- Use exit codes appropriately (0 for success, non-zero for failure)
- Add color output for better readability when appropriate