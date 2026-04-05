#!/bin/sh
set -e

if [ ! -f "/usr/local/bin/envconsul" ]; then
    echo "No envconsul found. Starting Caddy directly..."
    exec caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
fi

echo "Using envconsul to load cloudflare token"
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
fi

if [ ! -n "$VAULT_TOKEN" ]; then
    echo "ERROR: missing VAULT_TOKEN. Shutting down..."
    exit 1
fi

echo "VAULT_TOKEN found. Starting Caddy..."

if [ "$DEBUG" = "true" ]; then
    echo "--- Shell Environment Variables ---"
    env
    echo "-----------------------------------"

    # Use sh -c to execute env and then caddy, so we can see the env injected by envconsul
    exec envconsul -vault-addr="$VAULT_ADDR" -secret="$VAULT_PATH" -no-prefix -- sh -c '
        echo "--- Environment Variables inside Envconsul ---"
        env
        echo "----------------------------------------------"
        exec caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
    '
fi

# Normal startup without debug prints
exec envconsul -vault-addr="$VAULT_ADDR" -secret="$VAULT_PATH" -no-prefix -- caddy run --config /etc/caddy/Caddyfile --adapter caddyfile