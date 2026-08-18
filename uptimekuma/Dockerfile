ARG BUILD_FROM
FROM ${BUILD_FROM}

ARG BUILD_ARCH
ARG UPTIME_KUMA_VERSION="2.5.0"
ARG CLOUDFLARED_VERSION="2026.6.0"

WORKDIR /opt

COPY requirements.txt /opt/

RUN \
    apk add --no-cache --virtual .build-dependencies \
        build-base \
        py3-pip \
    && apk add --no-cache \
        curl \
        iputils \
        nodejs \
        npm \
        python3 \
        setpriv \
    && mkdir -p /opt/uptime-kuma \
    && curl -fsSL "https://github.com/louislam/uptime-kuma/archive/refs/tags/${UPTIME_KUMA_VERSION}.tar.gz" \
        | tar -xzf - --strip-components=1 -C /opt/uptime-kuma \
    && cd /opt/uptime-kuma \
    && pip install --no-cache-dir -r /opt/requirements.txt \
    && npm ci --no-audit --no-fund --no-update-notifier --omit=dev \
    && npm run download-dist \
    && case "${BUILD_ARCH}" in \
        aarch64) CLOUDFLARED_ARCH="arm64" ;; \
        amd64) CLOUDFLARED_ARCH="amd64" ;; \
        *) echo "Unsupported architecture: ${BUILD_ARCH}" >&2; exit 1 ;; \
       esac \
    && curl -fsSL -o /usr/bin/cloudflared \
        "https://github.com/cloudflare/cloudflared/releases/download/${CLOUDFLARED_VERSION}/cloudflared-linux-${CLOUDFLARED_ARCH}" \
    && chmod +x /usr/bin/cloudflared \
    && npm cache clean --force \
    && apk del --no-cache .build-dependencies \
    && rm -rf /root/.cache /root/.npm /root/.npmrc

COPY run.sh /
RUN chmod a+x /run.sh

LABEL \
    io.hass.name="Uptime Kuma" \
    io.hass.description="Self-hosted uptime monitoring with a web interface" \
    io.hass.type="addon"

CMD ["/run.sh"]
