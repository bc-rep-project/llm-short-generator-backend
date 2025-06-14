FROM n8nio/n8n:latest

USER root

# Install system dependencies
RUN apk add --no-cache \
    ffmpeg \
    python3 \
    py3-pip \
    curl \
    wget \
    bash \
    ca-certificates

# Install yt-dlp with --break-system-packages flag to bypass PEP 668
RUN pip3 install --no-cache-dir --break-system-packages yt-dlp

# Create directories for video processing and ensure proper permissions
RUN mkdir -p /home/node/n8n_video_files && \
    mkdir -p /home/node/.n8n && \
    chown -R node:node /home/node/n8n_video_files && \
    chown -R node:node /home/node/.n8n

# Switch back to node user
USER node

# Set environment variables for Render
ENV N8N_HOST=0.0.0.0
ENV N8N_PORT=5678
ENV N8N_PROTOCOL=https
ENV GENERIC_TIMEZONE=UTC
ENV NODE_ENV=production
ENV N8N_METRICS=true
ENV N8N_LOG_LEVEL=info

# Copy workflow files if they exist
COPY --chown=node:node workflows/ /opt/n8n/workflows/

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:5678/healthz || exit 1

EXPOSE 5678

# Let the original n8n image handle the startup command