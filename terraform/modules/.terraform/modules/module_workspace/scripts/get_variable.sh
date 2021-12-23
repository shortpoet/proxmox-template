#!/bin/bash
STG_WORKSPACE_ID='ws-1B6UBHsbcqtkAPCi'
DEV_WORKSPACE_ID='ws-HuwkFWh6pkLM8Nu5'
PRD_WORKSPACE_ID='ws-qP7RZSvtwh3tg5PM'

curl \
  --header "Authorization: Bearer $TFE_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
"https://app.terraform.io/api/v2/workspaces/$STG_WORKSPACE_ID/vars"