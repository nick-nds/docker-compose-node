FROM nginx:stable-alpine3.17

# install bash
RUN apk add --no-cache bash


# install mkcert for self-signed certificates
RUN curl -JLO "https://dl.filippo.io/mkcert/latest?for=linux/amd64" && \
    chmod +x mkcert-v*-linux-amd64 && \
    mv mkcert-v*-linux-amd64 /usr/local/bin/mkcert
RUN mkcert -install

RUN mkdir -p /etc/nginx/ssl
RUN mkdir -p /etc/nginx/sites-available
RUN mkdir -p /etc/nginx/sites-enabled

COPY ./servers/setup-servers.sh /etc/nginx/ssl/setup-servers.sh
COPY ./servers/domains /etc/nginx/ssl/domains

ADD ./nginx.conf /etc/nginx/nginx.conf
ADD ./proxy.conf /etc/nginx/proxy.conf

RUN chmod +x /etc/nginx/ssl/setup-servers.sh && \
    cd /etc/nginx/ssl && \
    ./setup-servers.sh

# create user and group with uid and gid 1000 to match host user
RUN addgroup -g 1000 -S app && \
    adduser -u 1000 -S app -G app

RUN mkdir -p /domains
RUN chown -R app:app /domains

USER app

COPY ./servers/domains /domains/domains

USER root

# CMD ["nginx"]
# CMD ["tail", "-f", "/dev/null"]
