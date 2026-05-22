set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

default:
    @just --list

RUN := "runsc"

init name:
    @docker_socket="/var/run/docker.sock"; \
    docker_gid="$(stat -c %g "${docker_socket}" 2>/dev/null || printf '0')"; \
    kvm_gid="$(stat -c %g /dev/kvm 2>/dev/null || printf '0')"; \
    printf '%s\n' \
        "DOCKER_AGENT_PROJECT=\"{{name}}\"" \
        "DOCKER_AGENT_BASE_IMAGE=\"debian:13\"" \
        "DOCKER_AGENT_UID=\"$(id -u)\"" \
        "DOCKER_AGENT_GID=\"$(id -g)\"" \
        "DOCKER_AGENT_NAME=\"{{name}}\"" \
        "DOCKER_AGENT_IMAGE=\"{{name}}:latest\"" \
        "DOCKER_AGENT_SOCKET=\"${docker_socket}\"" \
        "DOCKER_AGENT_DOCKER_GID=\"${docker_gid}\"" \
        "DOCKER_AGENT_KVM_GID=\"${kvm_gid}\"" \
        "DOCKER_AGENT_NETWORK_MODE=\"bridge\"" \
        "DOCKER_AGENT_HINDSIGHT_BASE_URL=\"http://host.docker.internal:8888\"" \
        "DOCKER_AGENT_HOST_GATEWAY=\"host-gateway\"" \
        "DOCKER_AGENT_RUNTIME=\"{{RUN}}\"" \
        > .env
