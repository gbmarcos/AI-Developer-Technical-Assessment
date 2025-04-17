#!/bin/bash
sleep 5
n8n import:workflow --input=/data/n8n_workflow.json
exec n8n "$@"