# Resiliate Events n8n Node - Metadata Collector

## Overview

The enhanced Resiliate Events node now includes a comprehensive metadata collection system that gathers system information from both local and remote hosts. This functionality provides rich context data alongside webhook events to enable better monitoring, alerting, and decision-making in your n8n workflows.

## Features

### 🏠 Local Host Metadata Collection
- **Basic**: Hostname, timestamp, platform, architecture, system release, uptime, and load averages
- **Standard**: Basic + memory usage, CPU information, and core count
- **Detailed**: Standard + disk usage, network interfaces, active connections, and process counts

### 🌐 Remote Host Metadata Collection
- SSH-based metadata collection from multiple remote hosts
- Configurable collection depth per host
- Parallel execution for faster collection
- Automatic error handling and graceful degradation

### 🛡️ Resiliate-Specific Information
- Resiliate service version detection
- Service status monitoring
- Last check timestamp retrieval
- Custom Resiliate configuration detection

## Configuration Options

### Enable Metadata Collection
**Type**: Boolean  
**Default**: `true`  
**Description**: Master switch to enable/disable all metadata collection functionality.

### Collection Depth
**Type**: Options (`basic`, `standard`, `detailed`)  
**Default**: `standard`  
**Description**: Controls how much information is collected:

- **Basic**: Essential system identification
- **Standard**: Recommended for most use cases
- **Detailed**: Comprehensive system profiling (may impact performance)

### Additional Hosts
**Type**: String (comma-separated)  
**Default**: Empty  
**Example**: `server1.example.com,192.168.1.100,db-server.local`  
**Description**: List of remote hosts to collect metadata from. Requires SSH key authentication.

### SSH User
**Type**: String  
**Default**: `root`  
**Description**: Username for SSH connections to remote hosts. Ensure this user has appropriate permissions.

### Include Resiliate Status
**Type**: Boolean  
**Default**: `true`  
**Description**: Whether to include Resiliate-specific monitoring information.

## Data Structure

### Webhook Response Format
```json
{
  "event": { /* Original webhook payload */ },
  "receivedAt": "2025-09-09T18:09:08.744Z",
  "metadata": {
    "collectionTime": "2025-09-09T18:09:08.747Z",
    "collectionDepth": "detailed",
    "localhost": {
      "hostname": "production-server",
      "timestamp": "2025-09-09T18:09:08.747Z",
      "system": {
        "platform": "linux",
        "arch": "x64",
        "release": "6.8.0-60-generic",
        "uptime": 775.23,
        "loadAverage": [1.09, 0.75, 0.37]
      },
      "memory": {
        "total": 117826580480,
        "free": 114453581824,
        "used": 3372998656,
        "usagePercent": 3
      },
      "cpu": {
        "cores": 20,
        "model": "Intel(R) Core(TM) i9-7900X CPU @ 3.30GHz"
      },
      "disk": {
        "total": 489564151808,
        "used": 107449606144,
        "free": 357170810880,
        "usagePercent": 24
      },
      "network": {
        "interfaces": ["lo", "eno1", "br-a4f4c54cd547"],
        "activeConnections": 3
      },
      "processes": {
        "total": 489,
        "running": 1
      },
      "resiliate": {
        "version": "2.1.0",
        "status": "active",
        "lastCheck": "2025-09-09T18:05:00.000Z"
      }
    },
    "remoteHosts": [
      { /* Similar structure for each remote host */ }
    ]
  }
}
```

## Use Cases

### 🚨 Alert Enrichment
Enhance alerts with system context to understand the state of affected systems:
```javascript
// In your n8n workflow
if (metadata.localhost.memory.usagePercent > 90) {
  // Trigger high memory alert
  // Include disk and CPU information for context
}
```

### 📊 System Health Monitoring
Create comprehensive dashboards by collecting metadata periodically:
```javascript
// Aggregate data from multiple hosts
const hostsSummary = metadata.remoteHosts.map(host => ({
  hostname: host.hostname,
  memoryUsage: host.memory.usagePercent,
  diskUsage: host.disk?.usagePercent,
  loadAverage: host.system.loadAverage[0]
}));
```

### 🔍 Incident Investigation
Capture system state at the time of incidents for forensic analysis:
```javascript
// Store metadata alongside incident reports
const incidentContext = {
  timestamp: metadata.collectionTime,
  affectedSystems: metadata.remoteHosts.filter(host => 
    host.resiliate?.status !== 'active'
  )
};
```

## Security Considerations

### SSH Configuration
- Use SSH key authentication (no password authentication)
- Configure `BatchMode=yes` to prevent interactive prompts
- Set connection timeouts to prevent hanging connections
- Use dedicated monitoring user accounts with minimal permissions

### Network Security
- Ensure SSH access is properly firewalled
- Consider using SSH jump hosts for accessing internal systems
- Monitor SSH connection logs for suspicious activity

### Data Privacy
- Metadata may contain sensitive system information
- Consider filtering sensitive data before storing or forwarding
- Implement proper access controls for workflows using this data

## Performance Considerations

### Local Collection
- **Basic**: ~1ms overhead
- **Standard**: ~5ms overhead  
- **Detailed**: ~50ms overhead (due to disk/network commands)

### Remote Collection
- Parallel execution across hosts
- 10-second SSH connection timeout
- 15-second total command timeout
- Graceful degradation if hosts are unreachable

### Optimization Tips
1. Use `basic` collection for high-frequency webhooks
2. Limit the number of remote hosts for better performance
3. Cache SSH connections where possible
4. Monitor n8n system resources when using `detailed` collection

## Troubleshooting

### Common Issues

**Remote hosts not appearing in results**
- Check SSH key authentication
- Verify network connectivity
- Ensure target hosts have required commands (`hostname`, `uptime`, `free`, etc.)

**High latency or timeouts**
- Reduce collection depth
- Check network connectivity to remote hosts
- Verify SSH configuration

**Missing Resiliate status**
- Ensure Resiliate is properly installed
- Check service permissions
- Verify log file locations

### Debug Mode
Enable debug logging by setting the collection depth to `detailed` and checking the n8n logs for detailed error messages.

## Testing

Use the included test script to verify metadata collection:
```bash
node test_metadata_collection.js
```

This will demonstrate all three collection levels and help identify any system-specific issues.

---

**Note**: This metadata collector is designed for Linux/Unix systems. Windows support may require additional configuration and testing.
