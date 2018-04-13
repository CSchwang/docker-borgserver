############################################################
# Dockerfile to build borgbackup server images
# Based on Debian
############################################################
FROM alpine:latest

# Volume for SSH-Keys
VOLUME /sshkeys

# Volume for borg repositories
VOLUME /backup

RUN apk add --no-cache \
    openssh-server \
    openssh-server-pam \
    ca-certificates \
    wget
RUN /usr/bin/wget -O /usr/local/bin/borg https://github.com/borgbackup/borg/releases/download/1.1.5/borg-linux64
RUN addgroup borg && \
    adduser -D -s /bin/false -G borg borg && \
    mkdir /home/borg/.ssh && \
    chmod 700 /home/borg/.ssh && \
    chown borg: /home/borg/.ssh && \
    mkdir /run/sshd && \
    chmod +x /usr/local/bin/borg
RUN rm -f /etc/ssh/ssh_host*key* && \
    rm -rf /var/tmp/* /tmp/*

COPY ./data/run.sh /run.sh
COPY ./data/sshd_config /etc/ssh/sshd_config

ENTRYPOINT /bin/sh /run.sh

# Default SSH-Port for clients
EXPOSE 22
