FROM n8nio/n8n:latest


# Copy files
COPY --chown=node:node ./main_workflow.json /data/main_workflow.json
COPY --chown=node:node ./n8n_credentials.json /data/n8n_credentials.json
COPY --chown=node:node ./entrypoint.sh /entrypoint.sh

# run permissions
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/bin/sh","/entrypoint.sh"]