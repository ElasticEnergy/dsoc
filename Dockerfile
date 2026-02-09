# https://github.com/anomalyco/opencode/blob/dev/packages/opencode/Dockerfile
FROM ghcr.io/anomalyco/opencode AS opencode-source

# notes
# - Using `run` instead of `exec` because `exec` didn't seem to have access to the host filesystem.
# - The Claude Code option `--dangerously-skip-permissions` is passed through when executing `run`.
# - Uses a script wrapper to bypass the option and launches tmux for oh-my-opencode integration.
# - Bundled necessary runtime libraries with the OpenCode binary for compatibility with the Ubuntu-based template.

RUN mkdir -p /tmp/opencode && \
    cp /usr/local/bin/opencode /tmp/opencode && \
    # cp /lib/ld-musl-x86_64.so.1 /tmp/opencode && \
    # cp /lib/libc.musl-x86_64.so.1 /tmp/opencode && \
    cp /usr/lib/libstdc++.so.6 /tmp/opencode && \
    cp /usr/lib/libgcc_s.so.1 /tmp/opencode && \
    apk add --no-cache patchelf && \
    patchelf \
        --force-rpath \
        --set-rpath '$ORIGIN/opencode-lib' \
        /tmp/opencode/opencode

# -----------------------------------------------------------------------------
# https://docs.docker.com/ai/sandboxes/templates/
FROM docker/sandbox-templates:claude-code

USER root

# Disable the runtime transpiler cache by default inside Docker containers.
# On ephemeral containers, the cache is not useful
ARG BUN_RUNTIME_TRANSPILER_CACHE_PATH=0
ENV BUN_RUNTIME_TRANSPILER_CACHE_PATH=${BUN_RUNTIME_TRANSPILER_CACHE_PATH}

RUN apt-get update && apt-get install -y --no-install-recommends \
    musl \
    xdg-utils \
    ripgrep \
    tmux \
    && rm -rf /var/lib/apt/lists/*

COPY --from=opencode-source /tmp/opencode/ /home/agent/.local/bin/opencode-lib/
RUN mv /home/agent/.local/bin/opencode-lib/opencode /home/agent/.local/bin/opencode && \
    ln -s /lib/ld-musl-x86_64.so.1 /home/agent/.local/bin/opencode-lib/libc.musl-x86_64.so.1

RUN rm -f /home/agent/.local/bin/claude && \
    cat << 'EOF' > /home/agent/.local/bin/claude
#!/bin/bash
exec tmux -u new -s dev
EOF
RUN chmod +x /home/agent/.local/bin/claude

USER agent

RUN mkdir -p /home/agent/.config/tmux && \
    cat << EOF > /home/agent/.config/tmux/tmux.conf
set -g default-terminal "tmux-256color"
set -as terminal-overrides ",*:RGB"
EOF