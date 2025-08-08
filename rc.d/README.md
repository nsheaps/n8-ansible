# rc.d - Run Commands Directory

This directory contains shell scripts that are automatically sourced when entering the project directory via direnv.

## How it works

1. When you `cd` into the project, direnv loads `.envrc`
2. `.envrc` sources all files in this `rc.d/` directory
3. Scripts are loaded in alphabetical order (hence the numeric prefixes)

## Files

- `05_add-bin-to-path.sh` - Adds the project's `bin/` directory to PATH

## Adding new scripts

1. Create a new `.sh` file with a numeric prefix (e.g., `20_my-script.sh`)
2. Make sure it's idempotent (can be run multiple times safely)
3. Use `set -euo pipefail` for safety
4. Access the project root via `${DIRENV_ROOT}`

## Benefits

- Changes to rc.d scripts don't require re-approving direnv (unlike changes to .envrc)
- Keeps .envrc simple and clean
- Makes environment setup modular and testable