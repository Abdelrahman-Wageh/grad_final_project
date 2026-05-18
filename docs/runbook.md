# 📋 Operations Runbook - The Whispering Woods

## Quick Reference

### Emergency Contacts
- **On-Call Engineer**: [Your Contact]
- **Support Email**: support@whisperingwoods.app
- **GitHub Issues**: [Your Repo]/issues

### Service URLs
- **Backend API**: http://localhost:8000
- **API Docs**: http://localhost:8000/docs
- **Health Check**: http://localhost:8000/api/health

---

## Daily Operations

### Morning Checks

```bash
# 1. Check backend health
curl http://localhost:8000/api/health

# 2. Check recent errors
tail -n 50 backend/logs/error.log

# 3. Check disk space
df -h

# 4. Check service status (if Docker)
docker-compose ps
```

### Review Logs

```bash
# View latest interactions
tail -n 100 backend/logs/actions.log

# Search for errors
grep -i error backend/logs/actions.log | tail -20

# Count requests in last hour
grep "$(date -d '1 hour ago' +%Y-%m-%d)" backend/logs/actions.log | wc -l
```

---

## Common Tasks

### Restart Backend

```bash
# If using Docker
docker-compose restart backend

# If running directly
# Find process
ps aux | grep uvicorn

# Kill process
kill <PID>

# Restart
cd backend
source venv/bin/activate
uvicorn app.main:app --reload
```

### Clear Logs (Rotation)

```bash
# Keep last 10000 lines
tail -n 10000 backend/logs/actions.log > backend/logs/actions.log.tmp
mv backend/logs/actions.log.tmp backend/logs/actions.log

# Archive old logs
tar -czf logs_archive_$(date +%Y%m%d).tar.gz backend/logs/*.log
rm backend/logs/*.log
touch backend/logs/actions.log
```

### Check Database (if used)

```bash
# Connect to Postgres
psql $DATABASE_URL

# Check table sizes
SELECT 
  schemaname,
  tablename,
  pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;

# Check recent audit entries
SELECT COUNT(*) FROM audit_log 
WHERE timestamp > NOW() - INTERVAL '24 hours';
```

---

## Troubleshooting

### Backend Not Starting

**Symptoms**: Service won't start, 503 errors

**Diagnosis**:
```bash
# Check logs
docker-compose logs backend

# Check port availability
netstat -tulpn | grep 8000

# Check Python environment
cd backend
python --version
pip list | grep fastapi
```

**Solutions**:
1. Port conflict: Change PORT in .env or kill conflicting process
2. Missing dependencies: `pip install -r requirements.txt`
3. Python version: Ensure Python 3.9+
4. Permissions: Check file permissions

### High Error Rate

**Symptoms**: Many 500 errors in logs

**Diagnosis**:
```bash
# Count errors
grep "ERROR" backend/logs/app.log | wc -l

# See error patterns
grep "ERROR" backend/logs/app.log | sort | uniq -c | sort -rn
```

**Common Causes**:
- Model path incorrect (if models enabled)
- Missing dependencies
- Out of memory
- Database connection issues

**Solutions**:
1. Enable DRY_RUN mode: `DRY_RUN=True`
2. Check model paths in .env
3. Restart service
4. Check system resources: `htop` or `top`

### Slow Response Times

**Symptoms**: API responses > 5 seconds

**Diagnosis**:
```bash
# Check processing times in logs
grep "processing_time_ms" backend/logs/actions.log | \
  awk -F'"' '{print $4}' | \
  awk '{sum+=$1; count++} END {print sum/count "ms average"}'
```

**Solutions**:
1. Enable DRY_RUN (faster, no real models)
2. Optimize NLU rules (fewer pattern checks)
3. Scale backend (more workers)
4. Use GPU for models (if available)

---

## Database Operations

### Backup Database

```bash
# Postgres backup
pg_dump $DATABASE_URL > backup_$(date +%Y%m%d).sql

# Compress
gzip backup_*.sql
```

### Restore Database

```bash
# Uncompress
gunzip backup_20240115.sql.gz

# Restore
psql $DATABASE_URL < backup_20240115.sql
```

### Reset Database

```bash
# ⚠️ WARNING: This deletes all data!
psql $DATABASE_URL -c "DROP SCHEMA public CASCADE;"
psql $DATABASE_URL -c "CREATE SCHEMA public;"
# Then run migrations again
```

---

## Log Management

### View Logs

```bash
# Real-time tail
tail -f backend/logs/actions.log

# Search for player
grep "player_id_123" backend/logs/actions.log

# Search by date
grep "2024-01-15" backend/logs/actions.log

# Count by action type
grep -o '"action":"[^"]*"' backend/logs/actions.log | \
  sort | uniq -c | sort -rn
```

### Log Rotation

**Automatic** (cron job):
```bash
# Add to crontab
0 0 * * * /path/to/rotate_logs.sh
```

**Manual**:
```bash
# See "Clear Logs" section above
```

---

## Webhook Operations

### Replay Stripe Webhook

```bash
# Using Stripe CLI
stripe events resend evt_1234567890

# Manual webhook send
curl -X POST http://localhost:8000/api/billing/webhook \
  -H "Content-Type: application/json" \
  -H "Stripe-Signature: test" \
  -d @webhook_sample.json
```

### Test Webhook Locally

```bash
# Install Stripe CLI
stripe login

# Forward webhooks to local
stripe listen --forward-to http://localhost:8000/api/billing/webhook
```

---

## Secrets Management

### Check for Exposed Secrets

```bash
# Search for common patterns
grep -r "sk_live\|sk_test" .
grep -r "password\|secret" .env*

# Check git history
git log --all --full-history --source -- .env
```

### Rotate Secrets

1. Generate new secret:
   ```bash
   openssl rand -hex 32
   ```

2. Update .env:
   ```env
   SECRET_KEY=new-secret-here
   ADMIN_API_KEY=new-admin-key-here
   ```

3. Restart services:
   ```bash
   docker-compose restart
   ```

4. Update any scripts/configs using old secrets

---

## Performance Monitoring

### Check API Response Times

```bash
# Average response time
grep "processing_time_ms" backend/logs/actions.log | \
  jq '.metadata.processing_time_ms' | \
  awk '{sum+=$1; count++} END {print "Average: " sum/count "ms"}'
```

### Check Error Rate

```bash
# Errors in last hour
grep "$(date -d '1 hour ago' +%Y-%m-%dT%H)" backend/logs/actions.log | \
  grep -i error | wc -l
```

### Monitor Resources

```bash
# CPU and Memory
htop

# Disk usage
df -h
du -sh backend/logs/

# Network
iftop
```

---

## Deployment Operations

### Update Backend

```bash
# Pull latest code
git pull origin main

# Install new dependencies
cd backend
pip install -r requirements.txt

# Restart service
docker-compose restart backend
# OR
# Kill old process and start new one
```

### Rollback

```bash
# Revert to previous commit
git checkout <previous-commit-hash>

# Restart services
docker-compose restart
```

---

## Emergency Procedures

### Service Down

1. **Check Health**: `curl http://localhost:8000/api/health`
2. **Check Logs**: `docker-compose logs backend` or `tail -n 100 backend/logs/app.log`
3. **Restart**: `docker-compose restart backend`
4. **If still down**: Enable DRY_RUN mode
5. **Escalate**: Contact on-call engineer

### Data Loss

1. **Stop all writes** (if possible)
2. **Check backups**: `ls -lh backups/`
3. **Restore from backup**: See "Restore Database" above
4. **Verify**: Check data integrity
5. **Investigate**: Review logs for cause

### Security Incident

1. **Isolate**: Disable affected services
2. **Assess**: Determine scope
3. **Contain**: Rotate all secrets
4. **Notify**: Alert security team
5. **Document**: Record incident details

---

## Useful Commands Cheat Sheet

```bash
# Health check
curl http://localhost:8000/api/health | jq

# Get stats
curl -X POST http://localhost:8000/api/admin/stats \
  -H "X-Admin-Api-Key: $ADMIN_API_KEY" | jq

# View audit log
curl http://localhost:8000/api/admin/audit_log?limit=10 \
  -H "X-Admin-Api-Key: $ADMIN_API_KEY" | jq

# Test adventure speech (with sample audio)
curl -X POST http://localhost:8000/api/adventure_speech \
  -H "Content-Type: application/json" \
  -d @test_request.json

# Count errors today
grep "$(date +%Y-%m-%d)" backend/logs/actions.log | grep -i error | wc -l

# Disk cleanup
find backend/logs/ -name "*.log" -mtime +30 -delete
```

---

## Maintenance Windows

### Weekly

- [ ] Review error logs
- [ ] Check disk space
- [ ] Review audit logs for anomalies
- [ ] Backup database (if used)

### Monthly

- [ ] Rotate logs
- [ ] Update dependencies
- [ ] Security audit
- [ ] Performance review

### Quarterly

- [ ] Full system backup
- [ ] Dependency security scan
- [ ] Documentation update
- [ ] Disaster recovery test

---

**Last Updated**: 2024
**For Questions**: See `README_FOR_ADMIN_BEGINNERS.md` or contact support

