FROM ubuntu:22.04

LABEL org.opencontainers.image.source="https://github.com/vevc/ubuntu"

ENV TZ=Asia/Shanghai \
    SSH_USER=konyan \
    SSH_PASSWORD=Nyan2212@

# Copy scripts + supervisor configs
COPY entrypoint.sh /entrypoint.sh
COPY reboot.sh /usr/local/sbin/reboot
COPY supervisor/*.conf /etc/supervisor/conf.d/

RUN export DEBIAN_FRONTEND=noninteractive; \
    apt-get update; \
    apt-get install -y \
        tzdata openssh-server sudo curl ca-certificates wget vim \
        net-tools supervisor unzip git iproute2 iputils-ping python3 --no-install-recommends; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*; \
    mkdir -p /var/run/sshd /var/log/supervisor; \
    wget https://github.com/playit-cloud/playit-agent/releases/latest/download/playit-linux-amd64 -O /usr/local/bin/playit; \
    chmod +x /entrypoint.sh /usr/local/sbin/reboot /usr/local/bin/playit; \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime; \
    echo $TZ > /etc/timezone

# Render expects a web service, so we expose both ports
EXPOSE 50000 10000

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-n"]
