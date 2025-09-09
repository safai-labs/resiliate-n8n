# Resiliate Events n8n Node - Security & Authentication

## Overview

The Resiliate Events n8n node now includes comprehensive authentication and security metadata collection capabilities. This enhancement provides proper credential management, security module monitoring, and detailed security context for all webhook events.

## 🔐 Authentication Methods

### Supported Authentication Types

#### 1. **API Key Authentication** (Default)
- **API Key**: Your Resiliate platform API key
- **API Secret**: Corresponding API secret for enhanced security
- **Format**: `res_api_key_xxxxxxxxxxxxxxxx`

#### 2. **OAuth 2.0 Authentication**
- **Client ID**: OAuth 2.0 application client identifier
- **Client Secret**: OAuth 2.0 application secret
- **Token Endpoint**: OAuth token endpoint URL
- **Default Endpoint**: `https://auth.saf.ai/oauth/token`

#### 3. **JWT Token Authentication**
- **JWT Token**: Pre-issued JSON Web Token
- **JWT Secret/Public Key**: Key for token verification
- **Supports**: HS256, RS256, ES256 algorithms

#### 4. **Client Certificate Authentication**
- **Client Certificate**: X.509 certificate for mutual TLS
- **Private Key**: Corresponding private key
- **Supports**: PEM and DER formats

## ⚙️ Platform Configuration

### Environment Settings
- **Production**: Live production environment
- **Staging**: Pre-production testing environment  
- **Development**: Development and testing environment
- **On-Premises**: Self-hosted deployment

### Organization & Project Settings
- **Base URL**: API endpoint base URL (`https://api.saf.ai/resiliate`)
- **Organization ID**: Your organization identifier (`org_xxxxxxxxxxxxxxxx`)
- **Project ID**: Project-specific identifier (`proj_xxxxxxxxxxxxxxxx`)

## 🛡️ Security Modules Configuration

### Available Security Modules

#### Core Protection Modules
1. **Ransomware Protection** ✅ (Default: Enabled)
   - Real-time ransomware detection
   - Behavioral analysis of file operations
   - Automatic threat response

2. **File Integrity Monitoring** ✅ (Default: Enabled)
   - Critical file change detection
   - Hash-based verification
   - Configuration drift monitoring

3. **Incident Response** ✅ (Default: Enabled)
   - Automated incident handling
   - Alert escalation workflows
   - Response coordination

#### Advanced Security Modules
4. **Data Loss Prevention** (Optional)
   - Sensitive data identification
   - Exfiltration detection
   - Policy enforcement

5. **Network Security Monitoring** (Optional)
   - Traffic analysis
   - Intrusion detection
   - Anomaly identification

6. **Behavioral Analytics** (Optional)
   - User behavior analysis
   - Anomaly detection
   - Risk scoring

7. **Zero-Day Protection** (Optional)
   - Advanced threat detection
   - ML-based analysis
   - Signature-less detection

8. **Compliance Monitoring** (Optional)
   - Regulatory compliance (GDPR, HIPAA, SOC2)
   - Policy adherence
   - Audit trail generation

## 🔒 Advanced Security Settings

### Encryption & Transport Security
- **Encryption in Transit**: TLS encryption for all communications (Default: Enabled)
- **Certificate Validation**: 
  - **Strict**: Full certificate chain validation (Recommended)
  - **Standard**: Basic certificate validation
  - **Relaxed**: Allow self-signed certificates (Not recommended for production)

### Rate Limiting
- **Enable Rate Limiting**: Protect against abuse (Default: Enabled)
- **Max Requests per Minute**: Default 100 requests/minute
- **Burst Limit**: Allow up to 10 burst requests

### Audit Logging
- **Enable Audit Logging**: Comprehensive logging (Default: Enabled)
- **Log Levels**: Debug, Info, Warning, Error
- **Include Payloads**: Log request/response bodies (Default: Disabled for security)

## 📊 Security Metadata Collection

### Authentication Status
```json
{
  "authenticationStatus": {
    "method": "apiKey",
    "isValid": true,
    "lastValidated": "2025-09-09T18:21:25Z",
    "organizationId": "org_example123",
    "projectId": "proj_resiliate456",
    "environment": "production"
  }
}
```

### Security Module Status
```json
{
  "securityModules": {
    "ransomwareProtection": {
      "enabled": true,
      "status": "active",
      "lastCheck": "2025-09-09T18:21:25Z",
      "threats": 0,
      "errors": []
    },
    "fileIntegrityMonitoring": {
      "enabled": true,
      "status": "active", 
      "lastCheck": "2025-09-09T18:21:25Z"
    }
  }
}
```

### Compliance Information
```json
{
  "compliance": {
    "enabled": true,
    "standards": ["ISO27001", "SOC2", "GDPR"],
    "lastAudit": "2025-09-01T00:00:00Z",
    "findings": 2
  }
}
```

### Encryption & Security Settings
```json
{
  "encryption": {
    "inTransit": true,
    "certificateValidation": "strict",
    "tlsVersion": "TLSv1.3"
  },
  "auditTrail": {
    "enabled": true,
    "logLevel": "info",
    "includePayloads": false,
    "sessionId": "abc123def456"
  }
}
```

## 📋 Complete Webhook Response Structure

With both system and security metadata enabled:

```json
{
  "event": {
    // Original webhook payload
  },
  "receivedAt": "2025-09-09T18:21:25Z",
  "securityMetadata": {
    "authenticationStatus": { /* Auth info */ },
    "securityModules": { /* Module statuses */ },
    "compliance": { /* Compliance info */ },
    "encryption": { /* Security settings */ },
    "auditTrail": { /* Audit info */ }
  },
  "systemMetadata": {
    "collectionTime": "2025-09-09T18:21:25Z",
    "collectionDepth": "standard",
    "localhost": { /* Host information */ },
    "remoteHosts": [ /* Remote host data */ ]
  }
}
```

## 🚀 Setup Instructions

### 1. Configure Credentials
1. Open n8n and go to **Settings** → **Credentials**
2. Click **Add credential** and select **Resiliate Events API**
3. Choose your authentication method
4. Fill in the required fields
5. Configure platform settings
6. Enable desired security modules
7. Configure advanced security settings
8. Test and save credentials

### 2. Configure Node
1. Add **Resiliate Events** trigger node to workflow
2. Select your configured credentials
3. Enable **Security Metadata Collection**
4. Configure system metadata collection as needed
5. Save and activate workflow

## 🔍 Monitoring & Troubleshooting

### Security Module Status Checks
The node performs real-time checks for:
- Process status (`ps aux | grep resiliate-*`)
- Service status (`systemctl is-active`)
- Log file analysis (`/var/log/resiliate/`)
- Configuration validation

### Common Issues

#### Authentication Failures
- **Invalid API Key**: Check key format and permissions
- **OAuth Token Expired**: Verify token endpoint and credentials
- **Certificate Issues**: Ensure proper PEM format and matching private key

#### Security Module Issues
- **Module Not Active**: Check if service is installed and running
- **Permission Denied**: Ensure proper file/directory permissions
- **Log Files Missing**: Verify log directories exist and are writable

#### Network/Connection Issues
- **TLS Errors**: Check certificate validation settings
- **Rate Limiting**: Monitor request frequency and adjust limits
- **Firewall Issues**: Ensure proper network connectivity

## 🔐 Security Best Practices

### Credential Management
- Use strong API keys with appropriate expiration
- Rotate credentials regularly
- Store credentials securely in n8n's encrypted storage
- Use least-privilege access principles

### Environment Security
- Use strict certificate validation in production
- Enable all relevant security modules
- Monitor audit logs regularly
- Implement proper network segmentation

### Compliance
- Enable compliance monitoring for regulated environments
- Regular security audits and reviews
- Document security configurations
- Maintain audit trails

## 📚 Advanced Configuration

### Custom Security Modules
Future versions will support custom security module integration through:
- Plugin architecture
- Custom status check scripts
- API-based module registration

### Enterprise Features
- SAML/OIDC integration
- Advanced audit logging to SIEM
- Custom compliance frameworks
- Multi-tenant organization support

---

**Security Note**: This node handles sensitive security information. Ensure proper access controls are in place for your n8n instance and regularly review security configurations.
