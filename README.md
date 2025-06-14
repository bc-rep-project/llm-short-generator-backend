# 🎬 AI Video Repurposing Pipeline

Transform your long-form videos into viral short clips automatically using AI. This project replicates the functionality of tools like Opus.pro with a custom n8n workflow and modern web interface.

## ✨ Features

- **🧠 AI-Powered Analysis**: GPT-4 analyzes video transcripts to identify viral-worthy moments
- **📝 Auto Subtitles**: Generates word-level captions with professional styling
- **📱 Mobile Optimized**: Automatically crops to 9:16 aspect ratio for TikTok/Reels
- **⚡ Batch Processing**: Processes multiple clips from a single video
- **🎨 Modern UI**: Beautiful, responsive frontend interface
- **🐳 Docker Ready**: Easy deployment with Docker containers

## 🏗️ Architecture

```
Frontend (Next.js) ↔ n8n API ↔ n8n Workflow Engine
     ↓                  ↓            ↓
 Vercel/Netlify    Reverse Proxy   Docker Container
                   (Nginx)         (VPS/Cloud)
```

## 🚀 Quick Start

### Prerequisites

- Docker & Docker Compose
- OpenAI API key
- Node.js 18+ (for frontend development)

### 1. Backend Deployment (n8n)

```bash
# Clone the repository
git clone <your-repo-url>
cd n8n-cursor

# Make deployment script executable
chmod +x deploy.sh

# Run deployment script
./deploy.sh
```

The script will guide you through:
- Setting up environment variables
- Building Docker containers
- Starting the n8n service
- Validating the deployment

### 2. Frontend Deployment

```bash
# Navigate to frontend directory
cd frontend

# Install dependencies
npm install

# Configure environment variables
cp .env.local.example .env.local
# Edit .env.local with your n8n API details

# Build and deploy to Vercel
npm run build
npx vercel --prod
```

## 🌐 Hosting Options

### Backend (n8n) Hosting

#### Option 1: DigitalOcean Droplet
```bash
# Create a droplet with Docker pre-installed
# SSH into your droplet
ssh root@your-server-ip

# Clone your repository
git clone <your-repo-url>
cd n8n-cursor

# Set up SSL certificates (Let's Encrypt)
sudo apt install certbot
sudo certbot certonly --standalone -d your-domain.com

# Copy certificates to SSL directory
sudo cp /etc/letsencrypt/live/your-domain.com/fullchain.pem ssl/cert.pem
sudo cp /etc/letsencrypt/live/your-domain.com/privkey.pem ssl/key.pem

# Deploy
./deploy.sh
```

#### Option 2: AWS EC2
```bash
# Launch EC2 instance with Docker
# Configure security groups (ports 80, 443, 5678)
# Set up Elastic IP
# Follow similar steps as DigitalOcean
```

#### Option 3: Google Cloud Run
```bash
# Build and push to Google Container Registry
docker build -t gcr.io/your-project/n8n-video-repurposing .
docker push gcr.io/your-project/n8n-video-repurposing

# Deploy to Cloud Run
gcloud run deploy n8n-video-repurposing \
  --image gcr.io/your-project/n8n-video-repurposing \
  --platform managed \
  --allow-unauthenticated
```

### Frontend Hosting

#### Option 1: Vercel (Recommended)
```bash
cd frontend
npx vercel --prod
```

#### Option 2: Netlify
```bash
cd frontend
npm run build
npx netlify deploy --prod --dir=.next
```

#### Option 3: AWS Amplify
```bash
# Connect your GitHub repository to AWS Amplify
# Configure build settings for Next.js
```

## ⚙️ Configuration

### Environment Variables

#### Backend (.env)
```bash
# n8n Configuration
N8N_USER=admin
N8N_PASSWORD=your-secure-password
N8N_ENCRYPTION_KEY=your-very-long-encryption-key
WEBHOOK_URL=https://your-domain.com
TIMEZONE=UTC

# OpenAI API
OPENAI_API_KEY=your-openai-api-key

# Domain (for SSL)
DOMAIN=your-domain.com
EMAIL=your-email@domain.com
```

#### Frontend (.env.local)
```bash
NEXT_PUBLIC_N8N_API_URL=https://your-n8n-domain.com/api/v1
NEXT_PUBLIC_WORKFLOW_ID=your-workflow-id
NEXT_PUBLIC_N8N_API_KEY=your-api-key
```

### n8n Workflow Setup

1. Access n8n interface at `https://your-domain.com`
2. Import the workflow from `name_AI_Video_Repurposing_2.json`
3. Configure OpenAI credentials in nodes 5 & 6
4. Test the workflow with a sample YouTube URL
5. Note the workflow ID for frontend configuration

## 🔒 Security Considerations

### Production Security Checklist

- [ ] Use strong passwords for n8n authentication
- [ ] Enable HTTPS with valid SSL certificates
- [ ] Restrict API access with proper authentication
- [ ] Use environment variables for all secrets
- [ ] Enable firewall rules (only ports 80, 443)
- [ ] Regular security updates for Docker images
- [ ] Monitor logs for suspicious activity

### API Security
```bash
# Enable API key authentication in n8n
N8N_API_KEY_PRIVATE=your-private-api-key
N8N_API_KEY_PUBLIC=your-public-api-key
```

## 📊 Monitoring & Maintenance

### Health Checks
```bash
# Check n8n status
curl -f https://your-domain.com/healthz

# Monitor Docker containers
docker-compose ps
docker-compose logs -f n8n
```

### Backup Strategy
```bash
# Backup n8n data
docker-compose exec n8n tar -czf /tmp/n8n-backup.tar.gz /home/node/.n8n

# Backup video files
docker-compose exec n8n tar -czf /tmp/videos-backup.tar.gz /home/node/n8n_video_files
```

### Updates
```bash
# Update Docker images
docker-compose pull
docker-compose up -d --build

# Update frontend
cd frontend
npm update
npm run build
npx vercel --prod
```

## 🐛 Troubleshooting

### Common Issues

#### n8n Won't Start
```bash
# Check logs
docker-compose logs n8n

# Common fixes
docker-compose down
docker system prune -f
docker-compose up -d --build
```

#### SSL Certificate Issues
```bash
# Renew Let's Encrypt certificates
sudo certbot renew
sudo cp /etc/letsencrypt/live/your-domain.com/* ssl/
docker-compose restart nginx
```

#### Video Processing Failures
```bash
# Check disk space
df -h

# Check ffmpeg/yt-dlp installation
docker-compose exec n8n ffmpeg -version
docker-compose exec n8n yt-dlp --version
```

### Performance Optimization

#### Scaling Options
- Use separate containers for CPU-intensive tasks
- Implement Redis for workflow data caching
- Use cloud storage (S3) for video files
- Set up load balancer for multiple n8n instances

## 📈 Usage Analytics

### Frontend Analytics
```bash
# Add Vercel Analytics
npm install @vercel/analytics
```

### Backend Monitoring
```bash
# Add Prometheus metrics to n8n
# Set up Grafana dashboards
# Monitor execution success rates
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

MIT License - see LICENSE file for details

## 🆘 Support

- Create an issue for bugs or feature requests
- Check the troubleshooting section
- Review n8n documentation: https://docs.n8n.io/

---

**Happy video repurposing! 🎬✨** 