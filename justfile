set shell       := ["bash", "-c"]
set dotenv-load := true
normal          := '\033[0m'
green           := "\\e[32m"

@_help:
    just --list --unsorted --list-heading $'Commands:\n'

# Bump the version and push a git tag (triggers pushing new docker image). inc=major|minor|patch
@publish inc="patch": _ensureGitPorcelain _check_deno
    # deno run --unstable  --allow-all https://deno.land/x/metapages@v0.0.17/commands/publish.ts --increment={{inc}}
    echo -e "Images published by github actions ${green}https://github.com/metapages/cellblender/actions${normal}:"
    echo -e "    👉 ${green}$(git config --get remote.origin.url | sd 'git@github.com:' 'ghcr.io/' | sd '.git' ''):latest${normal}"
    echo -e "    👉 ${green}$(git config --get remote.origin.url | sd 'git@github.com:' 'ghcr.io/' | sd '.git' ''):$( git describe --tags  $(git rev-list --tags --max-count=1))${normal}"

#10 naming to ghcr.io/metapages/cellblender:latest


# builds (versioned) production docker images
@build:
    docker build -t test .

# Prints install link if deno is not found
@_check_deno:
    if ! command -v deno &> /dev/null; \
    then \
        echo -e "💥 deno required: 👉🔗{{green}} https://deno.land/manual@v1.26.1/getting_started/installation {{normal}}"; \
        exit 1; \
    fi

@_ensureGitPorcelain: _check_deno
    deno run --allow-all --unstable https://deno.land/x/metapages@v0.0.17/git/git-fail-if-uncommitted-files.ts
