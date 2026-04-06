#!/bin/bash
set -e

if [ ! -f "/usr/local/bin/envconsul" ]; then
    echo "No envconsul found. Starting Tailscale directly..."
    exec bash -c "sleep 5; tailscale web --listen 0.0.0.0:$PORT_TAILSCALE_UI &
            exec /usr/local/bin/containerboot"
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

echo "VAULT_TOKEN found. Starting..."

if [ "$DEBUG" = "true" ]; then
    echo "--- Shell Environment Variables ---"
    env
    echo "---Subprocess Environment Variables ---"

    exec envconsul -vault-addr="$VAULT_ADDR" -secret="$VAULT_PATH" -no-prefix -- bash -c "
        env
        sleep 5; tailscale web --listen 0.0.0.0:$PORT_TAILSCALE_UI &
        exec /usr/local/bin/containerboot
    "
    
fi

exec envconsul -vault-addr="$VAULT_ADDR" -secret="$VAULT_PATH" -no-prefix -- bash -c "sleep 5; tailscale web --listen 0.0.0.0:$PORT_TAILSCALE_UI &
            exec /usr/local/bin/containerboot"