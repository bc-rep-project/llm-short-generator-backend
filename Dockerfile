FROM n8nio/n8n:latest

USER root

# Install system dependencies
RUN apk add --no-cache \
    ffmpeg \
    python3 \
    py3-pip \
    curl \
    wget

# Install yt-dlp
RUN pip3 install yt-dlp

# Create directories for video processing
RUN mkdir -p /home/node/n8n_video_files && \
    chown -R node:node /home/node/n8n_video_files

USER node

# Set environment variables
ENV N8N_HOST=0.0.0.0
ENV N8N_PORT=5678
ENV N8N_PROTOCOL=http
ENV WEBHOOK_URL=http://localhost:5678
ENV GENERIC_TIMEZONE=UTC

EXPOSE 5678 