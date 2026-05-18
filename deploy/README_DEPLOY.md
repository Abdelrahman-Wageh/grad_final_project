# 🚀 Deployment Guide - The Whispering Woods

## Overview

This guide explains how to deploy The Whispering Woods to production environments.

---

## Backend Deployment

### Option 1: Render

1. **Create Render Account**
   - Sign up at https://render.com

2. **Create Web Service**
   - New → Web Service
   - Connect your GitHub repository
   - Select `backend` folder as root

3. **Configure**
   ```yaml
   Build Command: pip install -r requirements.txt
   Start Command: uvicorn app.main:app --host 0.0.0.0 --port $PORT
   Environment: Python 3
   ```

4. **Environment Variables**
   ```env
   DRY_RUN=False
   SECRET_KEY=<generate-random>
   ADMIN_API_KEY=<generate-random>
   WHISPER_MODEL_PATH=models/stt/final_model
   TTS_MODEL_PATH=models/tts/final_model
   CV_MODEL_PATH=models/cv/final_model
   ```

5. **Deploy**
   - Render auto-deploys on git push
   - Check logs for errors

### Option 2: Heroku

1. **Install Heroku CLI**
   ```bash
   # https://devcenter.heroku.com/articles/heroku-cli
   ```

2. **Login**
   ```bash
   heroku login
   ```

3. **Create App**
   ```bash
   cd backend
   heroku create whispering-woods-backend
   ```

4. **Configure**
   ```bash
   heroku config:set DRY_RUN=False
   heroku config:set SECRET_KEY=$(openssl rand -hex 32)
   heroku config:set ADMIN_API_KEY=$(openssl rand -hex 32)
   ```

5. **Deploy**
   ```bash
   git push heroku main
   ```

### Option 3: AWS/Azure/GCP

See platform-specific documentation. Key points:
- Use container registry (ECR/ACR/GCR)
- Deploy as containerized service
- Configure environment variables
- Set up health checks
- Enable logging

---

## Website Deployment (Vercel)

1. **Install Vercel CLI**
   ```bash
   npm i -g vercel
   ```

2. **Login**
   ```bash
   vercel login
   ```

3. **Deploy**
   ```bash
   cd website
   vercel
   ```

4. **Configure**
   - Add environment variables in Vercel dashboard
   - Set API URL to backend URL
   - Configure custom domain (optional)

5. **Auto-Deploy**
   - Connect GitHub repository
   - Vercel auto-deploys on push

---

## Mobile App Deployment

### Android (Play Store)

1. **Build APK/AAB**
   ```bash
   cd mobile_app
   flutter build appbundle --release
   ```

2. **Sign App**
   - Use release keystore
   - Configure in `android/key.properties`

3. **Upload to Play Console**
   - Go to https://play.google.com/console
   - Create app listing
   - Upload AAB
   - Complete store listing
   - Submit for review

### iOS (App Store)

1. **Build**
   ```bash
   cd mobile_app
   flutter build ios --release
   ```

2. **Archive in Xcode**
   - Open `ios/Runner.xcworkspace`
   - Product → Archive
   - Distribute to App Store

3. **App Store Connect**
   - Upload build
   - Complete app information
   - Submit for review

---

## Docker Deployment

### Build Images

```bash
# Backend
docker build -t whispering-woods-backend ./backend

# Website
docker build -t whispering-woods-website ./website
```

### Run with Docker Compose

```bash
docker-compose up -d
```

### Update Deployment

```bash
# Pull latest code
git pull

# Rebuild and restart
docker-compose up -d --build
```

---

## Environment Variables Checklist

Before deploying, ensure these are set:

**Required**:
- `SECRET_KEY` - Random secret
- `ADMIN_API_KEY` - Admin API key
- `DRY_RUN` - False if models ready

**Optional** (if models trained):
- `WHISPER_MODEL_PATH`
- `TTS_MODEL_PATH`
- `CV_MODEL_PATH`

**Production**:
- `DEBUG=False`
- `ALLOWED_ORIGINS` - Your domain only
- `LOG_LEVEL=INFO`

---

## Post-Deployment Checklist

- [ ] Health check: `curl https://api.yourapp.com/api/health`
- [ ] Test API endpoint
- [ ] Verify logs are working
- [ ] Check error rate (should be low)
- [ ] Monitor performance
- [ ] Test mobile app connection
- [ ] Verify SSL/HTTPS
- [ ] Check CORS configuration

---

## Monitoring

### Health Checks

Set up monitoring for:
- `/api/health` endpoint
- Response time < 5 seconds
- Error rate < 1%

### Logs

- Backend: `backend/logs/`
- Monitor: `tail -f backend/logs/actions.log`
- Errors: `grep ERROR backend/logs/app.log`

---

## Troubleshooting

### Backend Won't Start
- Check environment variables
- Verify Python version (3.9+)
- Check port availability
- Review logs

### Mobile App Can't Connect
- Verify API URL in `app_constants.dart`
- Check CORS settings
- Verify SSL certificate
- Test with `curl` first

### High Error Rate
- Enable DRY_RUN mode
- Check model paths
- Review logs
- Verify dependencies

---

**See**: `docs/production-checklist.md` for complete checklist

