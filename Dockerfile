FROM debian:bookworm-slim

# Install Node.js 20 LTS
RUN apt-get update && \
    apt-get install -y curl gnupg && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs build-essential python3 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create app user
RUN useradd -m -s /bin/bash kbuser

# Application directory
WORKDIR /app

# Install dependencies first (cache layer)
COPY package*.json ./
RUN npm ci --production --legacy-peer-deps

# Copy application code
COPY . .

# Create data directory
RUN mkdir -p /data && chown kbuser:kbuser /data

# Switch to non-root user
USER kbuser

# Persistent data volume
VOLUME /data

# Configuration via environment
ENV KB_DATA_DIR=/data
ENV KB_PORT=3838
ENV NODE_ENV=production

EXPOSE 3838

# Health check
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
    CMD curl -f http://localhost:3838/api/v1/search?q=health || exit 1

CMD ["node", "bin/kb.js", "start"]