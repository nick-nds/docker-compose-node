FROM node:current-alpine3.19 as deps

# install packages
RUN apk add --update --no-cache libc6-compat bash git

COPY ./scripts/stop-servers.sh /usr/bin/stop-servers
RUN chmod +x /usr/bin/stop-servers


WORKDIR /app

RUN chown -R node:node /app

USER node

COPY --chown=node:node ./scripts/start-servers.sh /usr/bin/start-servers
RUN chmod +x /usr/bin/start-servers

CMD ["tail", "-f", "/dev/null"]
