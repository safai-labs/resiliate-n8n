# SoDAC - Resiliate Discretionary Access Control

## Overview

**SoDAC** (Resiliate Discretionary Access Control) is a Security Orchestrator plugin that provides discretionary access control protection across all file-types within the Resiliate ecosystem. This plugin extends traditional access control mechanisms to environments that typically lack such capabilities, particularly embedded systems.

## Description

SoDAC provides graceful downgrades to systems based on administrator-set credentials and enables device-level UID to global network GUID mappings when embedded devices are storing data across network connections. While DAC (Discretionary Access Control) is built into most multi-user operating systems like Windows and Linux, embedded systems traditionally do not have concepts of access controls.

## Key Features

### Cross-Platform Access Control
- **Multi-OS Support**: Works across Windows, Linux, and embedded systems
- **File-Type Agnostic**: Provides access control for all file types regardless of format
- **Network Integration**: Maps local device UIDs to global network GUIDs

### Embedded System Support
- **Graceful Degradation**: Automatically adapts access control mechanisms for systems with limited capabilities
- **Administrator Credentials**: Uses admin-configured credentials for systems without native user management
- **Network-Wide Consistency**: Maintains consistent access control across diverse device ecosystems

## Use Cases

### IoT Device Manufacturer
A company specializing in smart home devices can use SoDAC to:
- **Secure Legacy Devices**: Implement access controls on devices that traditionally lack such features
- **Unified Security**: Maintain consistent security policies across all IoT devices
- **Network Integration**: Seamlessly integrate device-level security with enterprise networks

### Embedded Systems Environment
Organizations deploying embedded systems can leverage SoDAC for:
- **Industrial Control Systems**: Secure access to critical control systems
- **Medical Devices**: Implement access controls on medical equipment
- **Automotive Systems**: Control access to vehicle control systems and data

### Mixed Environment Deployments
Enterprises with diverse technology stacks benefit from:
- **Heterogeneous Security**: Consistent access control across different platforms
- **Legacy System Support**: Extend modern security to older systems
- **Centralized Management**: Single point of control for diverse access policies

## Technical Specifications

### Compatibility
- **Operating Systems**: Windows, Linux, embedded platforms
- **File Systems**: All supported Resiliate storage orchestrators
- **Network Protocols**: TCP/IP, custom embedded protocols

### Security Model
- **Type**: Discretionary Access Control (DAC)
- **Granularity**: File-level access control
- **Inheritance**: Configurable permission inheritance
- **Override**: Administrator override capabilities

### Performance Characteristics
- **Latency**: Low-latency access control decisions
- **Scalability**: Supports large-scale embedded deployments
- **Resource Usage**: Minimal memory and CPU footprint for embedded systems

## Configuration

### Basic Setup
```yaml
security_orchestrator:
  plugins:
    - name: SoDAC
      enabled: true
      config:
        embedded_support: true
        network_guid_mapping: true
        admin_override: true
```

### Advanced Configuration
```yaml
sodac:
  access_control:
    default_permissions: read
    inheritance: enabled
    override_timeout: 300
  network:
    guid_mapping: automatic
    device_registration: required
  embedded:
    graceful_degradation: true
    minimum_security_level: basic
```

## Integration with Other Modules

### Cybernetic Engram Plugins
- **CeCore**: Leverages file-type categorization for appropriate access control
- **CeAudit**: Works with audit logging for access control decisions
- **CeDynTBAC**: Can be combined with dynamic trust-based controls

### Storage Orchestrators
- **StCellFS**: Provides access control for CellFS-backed storage
- **StCeph**: Integrates with Ceph distributed storage access
- **StZFS**: Works with ZFS permission systems

### Other Security Orchestrators
- **Complementary**: Works alongside other security modules
- **Non-Conflicting**: Designed to coexist with mandatory access controls
- **Layered Security**: Provides additional security layer in multi-plugin deployments

## Monitoring and Troubleshooting

### Logging
- Access control decisions are logged through CeAudit
- Failed access attempts are recorded with context
- Performance metrics available through Control Plane

### Common Issues
- **Embedded System Compatibility**: Ensure proper GUID mapping configuration
- **Network Connectivity**: Verify network accessibility for distributed deployments
- **Permission Conflicts**: Check for conflicts with OS-level permissions

## Best Practices

1. **Regular Review**: Periodically review access control policies
2. **Least Privilege**: Implement minimum necessary permissions
3. **Monitoring**: Actively monitor access patterns and violations
4. **Documentation**: Maintain clear documentation of access policies
5. **Testing**: Regular testing of access control mechanisms

## Related Documentation

- [SoDynTBAC.md](SoDynTBAC.md) - Dynamic Trust-Based Access Control
- [SoNFSv4ACL.md](SoNFSv4ACL.md) - NFSv4 Access Control Lists
- [Control-Plane.md](Control-Plane.md) - System monitoring and management
- [CeAudit.md](CeAudit.md) - Audit logging integration
