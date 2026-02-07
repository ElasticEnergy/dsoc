# https://github.com/anomalyco/opencode/blob/dev/packages/opencode/Dockerfile
FROM ghcr.io/anomalyco/opencode AS opencode-source

# https://docs.docker.com/ai/sandboxes/templates/
FROM docker/sandbox-templates:claude-code

USER root

# Disable the runtime transpiler cache by default inside Docker containers.
# On ephemeral containers, the cache is not useful
ARG BUN_RUNTIME_TRANSPILER_CACHE_PATH=0
ENV BUN_RUNTIME_TRANSPILER_CACHE_PATH=${BUN_RUNTIME_TRANSPILER_CACHE_PATH}

RUN apt-get update && apt-get install -y \
    ripgrep \
    && rm -rf /var/lib/apt/lists/*

COPY --from=opencode-source /usr/local/bin/opencode /home/agent/.local/bin/opencode
COPY --from=opencode-source /lib/ld-musl-x86_64.so.1 /lib/ld-musl-x86_64.so.1
COPY --from=opencode-source /lib/libc.musl-x86_64.so.1 /lib/libc.musl-x86_64.so.1
COPY --from=opencode-source /usr/lib/libstdc++.so.6 /usr/lib/libstdc++.so.6
COPY --from=opencode-source /usr/lib/libgcc_s.so.1 /usr/lib/libgcc_s.so.1

USER agent