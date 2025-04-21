FROM n8nio/n8n:latest


# Copiar archivos
COPY --chown=node:node ./main_workflow.json /data/main_workflow.json
COPY --chown=node:node ./n8n_credentials.json /data/n8n_credentials.json
COPY --chown=node:node ./entrypoint.sh /entrypoint.sh

# Permisos de ejecución
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/bin/sh","/entrypoint.sh"]