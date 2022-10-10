set shell       := ["bash", "-c"]
set dotenv-load := true
# Source of deno scripts. When developing we need to switch this
export DENO_SOURCE := env_var_or_default("DENO_SOURCE", "https://deno.land/x/metapages@v0.0.15")
bold                               := '\033[1m'
normal                             := '\033[0m'
green                              := "\\e[32m"


@_help:
    just --list --unsorted --list-heading $'Commands:\n\n'

# builds (versioned) production docker images
@publish: _check_deno
    deno run --unstable --allow-read=/.dockerenv {{DENO_SOURCE}}/commands/publish.ts

# Run all build/unit tests
@build:
    docker build -t test .

# Prints install link if deno is not found
@_check_deno:
    if ! command -v deno &> /dev/null; \
    then \
        echo -e "💥 deno required: 👉🔗 {{green}}https://deno.land/manual@v1.26.1/getting_started/installation{{normal}}"; \
        exit 1; \
    fi
