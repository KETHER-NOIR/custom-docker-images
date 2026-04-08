#!/bin/sh
set -e

if [ ! -f "/usr/local/bin/envconsul" ]; then
    echo "No envconsul found. Starting Caddy directly..."
    exec "$@"
fi

env_init() {
    echo "Server connection environment variables precheck..."
    if [ ! -n "$VAULT_ADDR" ]; then
        echo "VAULT_ADDR not set: address of the vault server, e.g. http://vault:8200"
        exit 1
    elif [ ! -n "$VAULT_PATH" ]; then 
        echo "VAULT_PATH not set: path to the secret in vault, e.g. secret/data/forgejo"
        exit 1
    fi

    echo "Checking authentication information..."
    if [ -n "$VAULT_ROLE_ID" ] && [ -n "$VAULT_SECRET_ID" ]; then
        echo "Authenticating with AppRole..."
        VAULT_TOKEN=$(curl -s --request POST \
            --data "{\"role_id\":\"$VAULT_ROLE_ID\",\"secret_id\":\"$VAULT_SECRET_ID\"}" \
            "$VAULT_ADDR/v1/auth/approle/login" | jq -r .auth.client_token)

        echo "AppRole Authentication successful, writing token to environment variable.."
        export VAULT_TOKEN
        if [ "$DEBUG" = "true" ]; then echo "Token: $VAULT_TOKEN"; fi
    fi

    if [ ! -n "$VAULT_TOKEN" ]; then
        env
        echo "ERROR: missing VAULT_TOKEN. Shutting down..."
        exit 1
    fi
    echo "VAULT_TOKEN found. Starting..."
}

debug() {
    echo "--- Shell Environment Variables ---"
    env
    echo "--- Envconsul Environment Variables ---"

    envconsul -vault-addr="$VAULT_ADDR" -secret="$VAULT_PATH" -no-prefix -once env
    echo "---------------------------------------"

    exec envconsul -vault-addr="$VAULT_ADDR" -secret="$VAULT_PATH" -no-prefix -- "$@"
}

env_init

if [ "$DEBUG" = "true" ]; then
    debug "$@"
else
    exec envconsul -vault-addr="$VAULT_ADDR" -secret="$VAULT_PATH" -no-prefix -- "$@"
fi