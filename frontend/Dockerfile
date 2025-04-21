FROM instrumentisto/flutter:3.27.1

WORKDIR /app
COPY app/pubspec.yaml .
RUN flutter pub get

COPY . .

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    net-tools \
    curl \
    jq \
    python3 \
    && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]