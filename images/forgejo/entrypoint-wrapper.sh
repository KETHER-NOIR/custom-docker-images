#!/bin/sh
set -e

if [ -f "/usr/local/bin/rst-render.py" ]; then
    echo "Loading rst render related environment variables..."
    set -- env FORGEJO__markup.rst__ENABLED="true" \
               FORGEJO__markup.rst__FILE_EXTENSIONS=".rst" \
               FORGEJO__markup.rst__RENDER_COMMAND="/usr/local/bin/rst-render.py" \
               FORGEJO__markup.rst__IS_INPUT_FILE="true" \
               "$@"
fi

if [ -f "/usr/local/bin/envconsul" ]; then
    echo "Starting envconsul procedure..."

    echo "Server connection environment variables precheck..."
    if [ ! -n "$VAULT_ADDR" ]; then
        echo "VAULT_ADDR not set: address of the vault server, e.g. http://vault:8200"
        exit 1
    elif [ ! -n "$VAULT_PATH" ]; then 
        echo "VAULT_PATH not set: path to the secret in vault, e.g. secret/data/forgejo"
        exit 1
    fi
    echo "Server connection environment variables precheck passed"

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
    
    echo "VAULT_TOKEN found. Starting Forgejo..."
    exec envconsul -vault-addr="$VAULT_ADDR" -secret="$VAULT_PATH" -- "$@"
        
else 
    exec "$@"
fi