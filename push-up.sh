#!/bin/bash

# Clone the repository
git clone https://github.com/pre-commit/pre-commit-hooks.git
cd pre-commit-hooks

# Loop through the repositories and hooks
for repo in "${repos[@]}"; do
    git clone "${repo['repo']}"
    cd "$(basename "${repo['repo']}")"
    git checkout "${repo['rev']}"

    # Loop through the hooks
    for hook in "${repo['hooks']}"; do
        # Check if it's a local hook
        if [ "${hook['repo']}" = "local" ]; then
            # Run the local hook
            eval "${hook['entry']}"
        else
            # Install the hook
            pre-commit install --hook-type "${hook['id']}"

            # Run the hook
            pre-commit run --hook-type "${hook['id']}"
        fi

        # Check if it's the check-date-format hook
        if [ "${hook['id']}" = "check-date-format" ]; then
            # Run the date format check
            eval "${hook['entry']}"
        fi
    done

    # Clean up the repository
    cd ..
    rm -rf "$(basename "${repo['repo']}")"
done

# Clean up the pre-commit-hooks repository
cd ..
rm -rf pre-commit-hooks
