# This is a placeholder Dockerfile
# Replace with actual OpenClaw application build
FROM ubuntu:24.04

WORKDIR /opt/openclaw

RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

COPY requirements.txt . 2>/dev/null || true
COPY src . 2>/dev/null || true

CMD ["echo", "OpenClaw placeholder - replace with actual application"]