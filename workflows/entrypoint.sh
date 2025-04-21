#!/bin/bash
sleep 5

n8n import:credentials --input=/data/n8n_credentials.json
n8n import:workflow --input=/data/main_workflow.json
n8n update:workflow --id=M5s4CzI6hwYqSf01 --active=true
n8n start