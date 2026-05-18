# 🔒 Safety and Privacy Documentation

## Core Safety Principles

### 1. Deterministic, Rule-Based NLU ✅

**Critical**: The core Natural Language Understanding system uses **100% rule-based logic**. No generative Large Language Models (LLMs) like GPT are used for game-critical responses.

**Why This Matters**:
- ✅ **Predictable**: Every response is deterministic
- ✅ **Safe**: No unpredictable or inappropriate content
- ✅ **Fast**: Rule matching is instantaneous
- ✅ **Editable**: Non-ML developers can modify rules in `nlu_rules.yaml`

**What This Means**:
- Child says "مش فاهم" → NLU checks rules → Returns predefined response
- No AI "thinking" or generation
- Responses come from human-edited YAML files

---

### 2. No External Generative AI

**For Core Game Logic**:
- ❌ No OpenAI GPT
- ❌ No Claude
- ❌ No any LLM API calls
- ✅ Only rule-based pattern matching

**For Non-Critical Features** (Optional, Future):
- Voice cloning training (local, with consent)
- Analytics summaries (parent dashboard, optional)
- **These never affect core game responses**

---

### 3. Content Filtering

**Safety Filters**:
- Inappropriate word detection
- Blocked phrases list
- Input sanitization

**Implementation**:
```python
# backend/app/services/nlu_service.py
safety_filters = [
    # List of inappropriate words (not shown here)
]

if any(filter_word in user_input for filter_word in safety_filters):
    return safe_default_response()
```

---

## Privacy Architecture

### Data Collection Policy

**What We Collect**:
- ✅ Game progress (local only)
- ✅ Interaction logs (local only, optional sync)
- ✅ Play time statistics
- ✅ Completed levels

**What We DON'T Collect**:
- ❌ Real audio recordings (unless explicit consent)
- ❌ Real images of drawings (unless explicit consent)
- ❌ Personal information (name, email, etc.)
- ❌ Location data
- ❌ Device identifiers (beyond app session)

### Data Storage

#### Client-Side (Flutter)

**Location**: `mobile_app` Hive database (local device)

**Data**:
- Game progress
- Interaction logs
- Settings

**Access**: Only by parent PIN or device owner

#### Server-Side

**Location**: `backend/logs/actions.log` (JSON logs)

**Data**:
- Action timestamps
- Game states
- Response keys (not actual audio)
- Metadata (no PII)

**Retention**: Configurable (default: 90 days)

---

## Parental Consent

### Voice Cloning Consent (If Used)

**Required Before**:
- Collecting voice samples for cloning
- Using personalized voice models
- Storing audio data

**Consent Process**:
1. Parent receives clear explanation
2. Parent explicitly opts-in via dashboard
3. Consent recorded and timestamped
4. Can revoke at any time

**Sample Consent Text**:
```
"By enabling Advanced Voice Features, you consent to:
- Local voice processing on your device
- Optional cloud-based voice cloning (if enabled)
- Storage of voice samples (encrypted, local-first)

You can disable this at any time in Parent Dashboard → Privacy Settings."
```

---

## Offline-First Privacy

### Default Behavior

- ✅ All data stored locally
- ✅ No network calls unless explicitly enabled
- ✅ Canned responses when offline
- ✅ Sync only with explicit parent consent

### Parental Controls

Parents can:
- Enable/disable cloud sync
- Delete all data
- Export data (JSON)
- Control which features use network

---

## Data Encryption

### Local Storage (Hive)

- Encrypted by default (Hive encryption)
- Key stored securely (device keychain/keystore)

### Network Transmission

- ✅ HTTPS only
- ✅ TLS 1.3
- ✅ Certificate pinning (optional)

### Server Storage

- Audit logs: Plain JSON (no sensitive data)
- If database used: Encrypted at rest

---

## GDPR/Privacy Compliance

### Right to Access

Parents can:
- View all collected data via dashboard
- Export data as JSON
- Request data deletion

### Right to Deletion

- One-click data deletion in dashboard
- Confirmation required
- Immediate deletion of local data
- Server logs purged (within 30 days)

### Data Portability

- Export all data as JSON
- Standard format
- Includes game progress, logs, settings

---

## Security Measures

### API Security

- Admin endpoints: API key required
- Rate limiting: Per IP, per endpoint
- Input validation: Pydantic schemas
- CORS: Restricted origins

### Authentication

- Parent dashboard: PIN protection
- Admin API: API key
- No user accounts (by design - privacy-first)

### Code Security

- No hardcoded secrets
- Environment variables only
- Regular dependency updates
- Security audits (recommended)

---

## Safety Checklist

Before deployment:

- [ ] All NLU rules reviewed by human
- [ ] Safety filters tested
- [ ] Content filtering enabled
- [ ] No LLM APIs in core logic
- [ ] Parent consent flows implemented
- [ ] Privacy policy published
- [ ] Data encryption verified
- [ ] Audit logging active
- [ ] Deletion flows tested
- [ ] Export flows tested

---

## Incident Response

### If Inappropriate Content Detected

1. **Immediate**: Block content via safety filter
2. **Log**: Record incident in audit log
3. **Alert**: Notify admins (if configured)
4. **Review**: Update NLU rules to prevent recurrence
5. **Notify**: Inform parents if necessary

### If Data Breach

1. **Contain**: Isolate affected systems
2. **Assess**: Determine scope
3. **Notify**: Inform affected parents (if required by law)
4. **Remediate**: Fix vulnerabilities
5. **Document**: Update security procedures

---

## Best Practices for Developers

### Adding New NLU Rules

1. ✅ Use clear, age-appropriate language
2. ✅ Test with sample inputs
3. ✅ Review with safety team
4. ✅ Document in `nlu_rules.yaml`
5. ❌ Never use external APIs for core responses

### Adding New Features

1. ✅ Privacy impact assessment
2. ✅ Parent consent if needed
3. ✅ Offline fallback
4. ✅ Audit logging
5. ❌ Don't collect unnecessary data

### Handling User Input

1. ✅ Always validate input
2. ✅ Check safety filters
3. ✅ Sanitize before processing
4. ✅ Log suspicious patterns
5. ❌ Never trust user input blindly

---

## Legal Compliance

### Children's Privacy Laws

- ✅ COPPA compliant (US)
- ✅ GDPR compliant (EU)
- ✅ No data collection without consent
- ✅ Clear privacy policy

### Voice Recording Laws

- ✅ Parental consent required
- ✅ Local storage preferred
- ✅ Clear disclosure of use
- ✅ Easy opt-out

---

## Contact for Privacy Concerns

**Privacy Officer**: privacy@whisperingwoods.app

**For Parents**:
- Email: parents@whisperingwoods.app
- In-app: Parent Dashboard → Contact Us

**For Legal**: legal@whisperingwoods.app

---

**Last Updated**: 2024
**Version**: 1.0.0

