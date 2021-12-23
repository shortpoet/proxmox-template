#!/bin/bash

set -xe

# Extract "storage_account_name" and "token_expiry" arguments from the input into
# jq will ensure that the values are properly quoted
# and escaped for consumption by the shell.
eval "$(jq -r '@sh "KEY_VAULT_NAME=\(.key_vault_name) SECRET_NAME_APPID=\(.secret_name_appId) SECRET_NAME_PASSWORD=\(.secret_name_password)"')"

SECRET_VALUE_APPID=$(az keyvault secret show \
  --name "$SECRET_NAME_APPID" \
  --vault-name "$KEY_VAULT_NAME" \
  --output tsv \
  --query "value")

SECRET_VALUE_PASSWORD=$(az keyvault secret show \
  --name "$SECRET_NAME_PASSWORD" \
  --vault-name "$KEY_VAULT_NAME" \
  --output tsv \
  --query "value")

# Safely produce a JSON object containing the result value.
# jq will ensure that the value is properly quoted
# and escaped to produce a valid JSON string.
jq -n \
  --arg secret_value_appId "$SECRET_VALUE_APPID" \
  --arg secret_value_password "$SECRET_VALUE_PASSWORD" \
  '{"secret_value_appId":($secret_value_appId | sub("\r"; "")),"secret_value_password":($secret_value_password | sub("\r"; ""))}'

