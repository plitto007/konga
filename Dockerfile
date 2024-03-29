FROM node:12.16.1
COPY . /app

WORKDIR /app

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
        bash \
        git \
        ca-certificates \
        python-is-python3 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*



# Install global npm package
RUN npm install -g bower

COPY package.json package-lock.json ./
RUN npm --unsafe-perm --production install

# Remove unnecessary packages and directories
RUN apt-get purge -y git \
    && rm -rf /var/cache/apk/* \
            /app/.git \
            /app/screenshots \
            /app/test

# Create user and directories
RUN adduser -H -S -g "Konga service owner" -D -u 1200 -s /sbin/nologin konga \
    && mkdir /app/kongadata /app/.tmp \
    && chown -R 1200:1200 /app/views /app/kongadata /app/.tmp

USER konga

EXPOSE 1337

VOLUME /app/kongadata

ENTRYPOINT ["/app/start.sh"]
