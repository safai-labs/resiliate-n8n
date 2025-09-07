# SoTrust - Resiliate Trust-Based Access Control

## Overview

**SoTrust** (Resiliate Trust-Based Access Control) is a Security Orchestrator plugin that implements owner-centric, relationship-based access control within the Resiliate ecosystem. Unlike traditional label-based security systems, SoTrust focuses on trust relationships between owners (users and groups) to provide intuitive, organizationally-aligned access control that naturally maps to business hierarchies and collaborative workflows.

## Description

SoTrust revolutionizes enterprise security by implementing an owner-centric security model where access control decisions are based on trust relationships between data owners and requesters. The plugin uses relative trust rankings within organizational contexts, making security rules atomic, intuitive, and directly aligned with business relationships.

The system enables security administrators to define simple, natural rules like "Bob trusts Jill with files of secret sensitivity in engineering group" rather than complex, multi-step access control lists that are difficult to manage and understand.

## Trust-Based Security Model

SoTrust is built on four fundamental principles:

### 1. Owner-Centric Approach
- **Objects**: Data resources (files, directories, devices, network resources)
- **Subjects**: Processes and applications manipulating objects
- **Owners**: Users and groups that own objects and subjects
- **Trust Relationships**: Dynamic relationships between owners that determine access

### 2. Relative Trust Rankings
Trust relationships are expressed through numerical rankings (1-127) in two classes:

#### Secrecy Rankings
- **Write-up, Read-down** model similar to Bell-LaPadula
- Higher-ranked trustees can read lower-ranked data
- Higher-ranked trustees cannot create lower-ranked data
- Lower-ranked trustees cannot access higher-ranked data

#### Integrity Rankings  
- **Read-up, Write-down** model similar to Biba
- Data normally accessible for reading across integrity levels
- Immutable ownership maintains data integrity signatures
- Prevents contamination from lower integrity sources

### 3. Atomic Security Rules
Security policies are expressed as simple, atomic statements:
- **Traditional**: "For all files owned by Bob in Engineering where sensitivity is secret or less, create an ACL entry for Jill for Read access"
- **SoTrust**: "Bob trusts Jill with files of secret sensitivity in engineering group"

### 4. Organizational Context
Trust relationships operate within organizational contexts that mirror business structures:
- **Departments**: Engineering, Marketing, Finance, HR
- **Projects**: Project Alpha, Project Omega, Research Initiative  
- **Roles**: Manager, Lead, Contributor, Consultant
- **Locations**: Headquarters, Remote Office, Client Site

## Key Features

### Multi-Dimensional Trust Relationships
- **User-to-User**: Direct trust between individuals (asymmetric relationships)
- **User-to-Group**: Individual clearance within departments or projects
- **Group-to-User**: How much an individual trusts an entire group
- **Group-to-Group**: Inter-departmental or cross-functional information flow

### Dynamic Relationship Management
- **Temporal Trust**: Time-limited trust relationships for projects or contracts
- **Conditional Trust**: Context-dependent trust based on location, device, or time
- **Graduated Trust**: Multi-level trust with different permissions at each level
- **Delegated Trust**: Ability to delegate trust relationships to subordinates

### Organizational Integration
- **HR System Sync**: Automatic relationship updates based on organizational changes
- **Project Management**: Dynamic team-based access for project collaboration
- **Role-Based Inheritance**: Trust relationships inherited from organizational roles
- **External Partner Support**: Trust bridges for vendor and client relationships

### Advanced Security Features
- **Trust Decay**: Automatic reduction of trust levels over time without reinforcement
- **Trust Verification**: Periodic validation of trust relationships
- **Anomaly Detection**: Identification of unusual trust-based access patterns
- **Trust Audit Trails**: Comprehensive logging of trust relationship changes

## Trust Ranking System

### Ranking Levels
SoTrust uses a 1-127 ranking system with predefined organizational levels:

#### Standard Organizational Hierarchy
- **Executive (121-127)**: C-level executives, board members
- **Senior Management (101-120)**: VPs, directors, senior managers  
- **Management (81-100)**: Department managers, team leads
- **Senior Staff (61-80)**: Senior engineers, architects, specialists
- **Staff (41-60)**: Standard employees, contributors
- **Junior Staff (21-40)**: New employees, interns, contractors
- **External (1-20)**: Vendors, partners, temporary access

#### Project-Specific Rankings
- **Project Owner (101-120)**: Project sponsors, executive stakeholders
- **Project Manager (81-100)**: Project leads, scrum masters
- **Core Team (61-80)**: Key contributors, technical leads
- **Team Members (41-60)**: Active project participants  
- **Contributors (21-40)**: Occasional contributors, consultants
- **Observers (1-20)**: Stakeholders with read-only access

### Trust Relationship Types

#### Bidirectional Trust
Both parties trust each other at specified levels:
```
trust bidirectional alice bob rank 75 in engineering group secrecy
trust bidirectional alice bob rank 60 in engineering group integrity
```

#### Unidirectional Trust
One-way trust relationship:
```
trust alice to bob rank 80 in finance group secrecy
trust bob to alice rank 40 in finance group integrity
```

#### Group Trust
Trust relationships involving entire groups:
```
trust user alice to group engineering rank 70 secrecy
trust group engineering to user alice rank 50 integrity
trust group engineering to group marketing rank 30 secrecy
```

## Use Cases

### Enterprise Collaboration
Organizations use SoTrust for:
- **Cross-functional projects**: Dynamic team formation with appropriate access levels
- **Hierarchical access**: Manager-subordinate information sharing
- **Peer collaboration**: Lateral trust relationships for team projects
- **Client engagement**: Controlled external partner access

### Government and Defense
Defense organizations benefit from:
- **Need-to-know compartmentalization**: Flexible compartment-based access
- **Coalition operations**: Inter-agency trust relationships
- **Contractor integration**: Controlled vendor access to classified information
- **Command hierarchy**: Military rank-based access control

### Healthcare Systems
Medical organizations use SoTrust for:
- **Care team coordination**: Doctor-nurse-specialist information sharing
- **Department collaboration**: Cross-department patient care
- **Research projects**: Controlled access to patient data for studies
- **External partnerships**: Trusted relationships with partner hospitals

### Financial Services
Banks and financial institutions implement SoTrust for:
- **Trading floor access**: Trader-analyst-manager information flow
- **Client relationship management**: Relationship banker access to client data
- **Regulatory compliance**: Audit trail of trust-based access decisions
- **Vendor management**: Controlled third-party access to financial systems

## Technical Implementation

### Trust Relationship Engine
```python
class TrustRelationshipEngine:
    def __init__(self):
        self.relationships = {}
        self.groups = {}
        self.contexts = {}
    
    def establish_trust(self, from_owner, to_owner, rank, context, trust_class):
        """Establish trust relationship between owners"""
        relationship = TrustRelationship(
            from_owner=from_owner,
            to_owner=to_owner,
            rank=rank,
            context=context,
            trust_class=trust_class,
            timestamp=current_time(),
            expires=None
        )
        
        self.relationships[f"{from_owner}:{to_owner}:{context}"] = relationship
        self.log_trust_change("ESTABLISH", relationship)
        return relationship
    
    def revoke_trust(self, from_owner, to_owner, context):
        """Revoke trust relationship"""
        key = f"{from_owner}:{to_owner}:{context}"
        if key in self.relationships:
            relationship = self.relationships[key]
            del self.relationships[key]
            self.log_trust_change("REVOKE", relationship)
            return True
        return False
    
    def evaluate_access(self, subject_owner, object_owner, operation, context):
        """Evaluate access based on trust relationships"""
        trust_rank = self.get_trust_rank(subject_owner, object_owner, context)
        required_rank = self.get_required_rank(object_owner, operation, context)
        
        if trust_rank >= required_rank:
            return AccessDecision.GRANTED
        else:
            return AccessDecision.DENIED
```

### Access Control Decision Logic
```python
def trust_based_access_control(subject, object_resource, operation):
    subject_owner = get_owner(subject)
    object_owner = get_owner(object_resource)
    context = get_context(object_resource)
    
    # Direct trust relationship check
    direct_trust = get_trust_rank(subject_owner, object_owner, context)
    if direct_trust and direct_trust.sufficient_for_operation(operation):
        return grant_access("DIRECT_TRUST", direct_trust)
    
    # Group-based trust check
    group_trust = get_group_trust(subject_owner, object_owner, context)
    if group_trust and group_trust.sufficient_for_operation(operation):
        return grant_access("GROUP_TRUST", group_trust)
    
    # Inherited trust check (role-based)
    inherited_trust = get_inherited_trust(subject_owner, object_owner, context)
    if inherited_trust and inherited_trust.sufficient_for_operation(operation):
        return grant_access("INHERITED_TRUST", inherited_trust)
    
    # Delegated trust check
    delegated_trust = get_delegated_trust(subject_owner, object_owner, context)
    if delegated_trust and delegated_trust.sufficient_for_operation(operation):
        return grant_access("DELEGATED_TRUST", delegated_trust)
    
    return deny_access("INSUFFICIENT_TRUST")
```

### Trust Decay and Maintenance
```python
class TrustMaintenanceEngine:
    def __init__(self):
        self.decay_rates = {
            'user_to_user': 0.95,      # 5% decay per period
            'user_to_group': 0.98,     # 2% decay per period
            'group_to_group': 0.99     # 1% decay per period
        }
    
    def apply_trust_decay(self):
        """Apply time-based trust decay"""
        for relationship in self.get_all_relationships():
            if relationship.has_decay_enabled():
                decay_rate = self.decay_rates[relationship.type]
                relationship.rank *= decay_rate
                
                if relationship.rank < relationship.minimum_threshold:
                    self.revoke_relationship(relationship)
                else:
                    self.log_trust_decay(relationship)
    
    def verify_trust_relationships(self):
        """Periodic verification of trust relationships"""
        for relationship in self.get_all_relationships():
            if relationship.requires_verification():
                verification_result = self.verify_relationship(relationship)
                if not verification_result.valid:
                    self.flag_for_review(relationship)
```

## Configuration

### Basic Configuration
```yaml
security_orchestrator:
  plugins:
    - name: SoTrust
      enabled: true
      config:
        owner_centric_mode: true
        relationship_management: enabled
        trust_decay: enabled
        organizational_integration: true
```

### Advanced Configuration
```yaml
sotrust:
  trust_rankings:
    max_rank: 127
    min_rank: 1
    default_rank: 50
    executive_range: [121, 127]
    management_range: [81, 120]
    staff_range: [41, 80]
    external_range: [1, 40]
  
  relationship_types:
    user_to_user:
      enabled: true
      asymmetric: true
      max_relationships_per_user: 100
    user_to_group:
      enabled: true
      inheritance: true
      auto_sync_with_hr: true
    group_to_group:
      enabled: true
      cross_department: true
      approval_required: true
  
  trust_decay:
    enabled: true
    decay_period: 30  # days
    decay_rates:
      user_to_user: 0.05    # 5% decay per period
      user_to_group: 0.02   # 2% decay per period
      group_to_group: 0.01  # 1% decay per period
    minimum_threshold: 10
  
  contexts:
    organizational:
      departments: [engineering, marketing, finance, hr, legal]
      projects: [alpha, omega, research, client_engagement]
      locations: [headquarters, remote, client_site]
    
    temporal:
      business_hours: "09:00-17:00"
      extended_hours: "07:00-20:00" 
      emergency_access: "24x7"
    
    conditional:
      secure_network_required: true
      mfa_required_above_rank: 80
      device_trust_required: true

  integration:
    hr_system:
      enabled: true
      sync_frequency: "daily"
      auto_create_relationships: true
      hierarchy_mapping: true
    
    project_management:
      enabled: true
      tools: [jira, asana, monday]
      auto_team_access: true
      project_completion_cleanup: true
    
    identity_provider:
      ldap_integration: true
      group_sync: true
      role_mapping: enabled
```

### Trust Relationship Definitions
```yaml
trust_relationships:
  engineering_department:
    - trust: alice to bob rank 75 secrecy in engineering
    - trust: bob to alice rank 70 integrity in engineering
    - trust: group senior_engineers to group engineers rank 90 secrecy
    - trust: user alice to group engineering rank 85 secrecy
  
  project_alpha:
    temporal: 
      start: "2024-01-01"
      end: "2024-12-31"
    relationships:
      - trust: project_manager to team_leads rank 100 secrecy in project_alpha
      - trust: team_leads to developers rank 80 secrecy in project_alpha  
      - trust: developers to testers rank 60 integrity in project_alpha
    
  external_partners:
    vendor_acme:
      - trust: user alice to group acme_contractors rank 40 secrecy in vendor_engagement
      - trust: group acme_contractors to user alice rank 20 integrity in vendor_engagement
    
    client_beta:
      conditional:
        location: client_site
        time_range: business_hours
        device_type: managed
      relationships:
        - trust: account_manager to client_liaison rank 60 secrecy in client_beta
```

## Integration with Other Modules

### Security Orchestrator Integration
- **SoBLPMAC**: Trust relationships can map to classification compartments
- **SoBibaMIC**: Integrity rankings complement Biba integrity levels
- **SoDynTBAC**: Trust scores can influence dynamic trust credit calculations
- **SoDAC**: Discretionary access control within trust relationship bounds
- **SoNFSv4ACL**: ACL generation based on trust relationship evaluation

### Cybernetic Engram Integration  
- **CeCore**: File ownership and access pattern analysis for trust relationships
- **CeAudit**: Comprehensive audit logging of trust-based access decisions
- **CeDynTBAC**: Trust relationship strength influences dynamic trust calculations
- **CeAnomaly**: Anomaly detection for unusual trust relationship patterns

### External System Integration
- **HR Systems**: Automatic organizational structure synchronization
- **Identity Providers**: LDAP/Active Directory group and role mapping
- **Project Management**: Dynamic team access based on project assignments
- **SIEM Systems**: Trust-based security event correlation and analysis

## Monitoring and Compliance

### Trust Relationship Monitoring
```python
def monitor_trust_relationships():
    violations = []
    
    # Check for trust relationship abuse
    excessive_relationships = detect_excessive_relationships()
    violations.extend(excessive_relationships)
    
    # Check for trust escalation attempts
    escalation_attempts = detect_trust_escalation()
    violations.extend(escalation_attempts)
    
    # Check for circular trust relationships
    circular_trusts = detect_circular_relationships()
    violations.extend(circular_trusts)
    
    # Check for orphaned relationships
    orphaned_relationships = detect_orphaned_relationships()
    violations.extend(orphaned_relationships)
    
    return violations
```

### Compliance Reporting
- **Trust Relationship Audit**: Complete history of trust relationship changes
- **Access Pattern Analysis**: Trust-based access patterns and trends
- **Organizational Alignment**: Verification that trust relationships match business structure  
- **Risk Assessment**: Analysis of trust concentration and potential abuse

### Real-Time Alerting
- **Relationship Changes**: Immediate notification of trust relationship modifications
- **Anomalous Access**: Alerts for unusual trust-based access patterns
- **Trust Violations**: Real-time detection of insufficient trust access attempts
- **Compliance Deviations**: Notifications when trust relationships violate policies

## Performance Optimization

### Caching Strategies
- **Relationship Cache**: Fast lookup of active trust relationships
- **Decision Cache**: Caching of recent access control decisions  
- **Group Membership Cache**: Quick resolution of group-based relationships
- **Context Cache**: Cached organizational context information

### Optimization Techniques
```python
class TrustPerformanceOptimizer:
    def __init__(self):
        self.relationship_cache = LRUCache(maxsize=10000)
        self.decision_cache = TTLCache(maxsize=5000, ttl=300)
        self.group_cache = TTLCache(maxsize=1000, ttl=3600)
    
    def optimize_trust_check(self, subject_owner, object_owner, context):
        # Check decision cache first
        cache_key = f"{subject_owner}:{object_owner}:{context}"
        cached_decision = self.decision_cache.get(cache_key)
        if cached_decision:
            return cached_decision
        
        # Perform trust relationship evaluation
        decision = self.evaluate_trust_relationship(subject_owner, object_owner, context)
        
        # Cache the decision
        self.decision_cache[cache_key] = decision
        
        return decision
    
    def preload_common_relationships(self):
        """Preload frequently accessed trust relationships"""
        common_relationships = self.get_common_relationships()
        for relationship in common_relationships:
            self.relationship_cache[relationship.key] = relationship
```

## Troubleshooting

### Common Issues
- **Relationship Conflicts**: Resolving contradictory trust relationships
- **Performance Issues**: Optimizing trust evaluation for large organizations
- **Synchronization Problems**: Managing updates from external systems
- **Trust Escalation**: Preventing unauthorized trust relationship elevation

### Diagnostic Tools
```bash
# Check trust relationship status
resiliate-trust --check-relationship --from alice --to bob --context engineering

# Validate organizational structure sync
resiliate-trust --validate-org-sync --source hr_system

# Test trust-based access decision
resiliate-trust --test-access --subject alice --object /secure/project_alpha/design.doc

# Generate trust relationship report  
resiliate-trust --report --type relationships --format json --output /tmp/trust_report.json
```

### Debug Commands
```bash  
# Enable trust debugging
resiliate-trust --debug --level verbose --duration 3600

# Trace trust relationship evaluation
resiliate-trust --trace-evaluation --subject alice --duration 1800

# Validate trust configuration
resiliate-trust --validate-config --config /etc/resiliate/trust.conf
```

## Security Considerations

### Trust Relationship Protection
- **Relationship Integrity**: Cryptographic protection of trust relationship data
- **Modification Auditing**: Complete audit trail of all relationship changes
- **Access Control**: Strict controls on who can modify trust relationships
- **Verification**: Periodic verification of trust relationship validity

### Attack Prevention
- **Trust Manipulation**: Detection and prevention of unauthorized relationship changes
- **Circular Relationships**: Prevention of circular trust chains that could be exploited
- **Trust Escalation**: Monitoring for attempts to gain unauthorized access through trust
- **Social Engineering**: Awareness and detection of relationship manipulation attacks

### Privacy Protection
- **Relationship Anonymization**: Privacy protection for sensitive trust relationships
- **Data Minimization**: Limiting stored relationship data to necessary information
- **Consent Management**: Explicit consent for trust relationship establishment
- **Right to Revoke**: User ability to revoke trust relationships

## Best Practices

1. **Start Small**: Begin with simple user-to-user relationships before implementing complex group structures
2. **Align with Organization**: Map trust relationships to actual business relationships and hierarchies
3. **Regular Auditing**: Conduct regular audits of trust relationships to ensure they remain appropriate
4. **Clear Policies**: Establish clear policies for trust relationship establishment and maintenance
5. **Training Programs**: Provide comprehensive training on trust-based security concepts
6. **Gradual Migration**: Implement trust-based access control gradually alongside existing systems
7. **Monitor Performance**: Continuously monitor system performance and optimize trust evaluation
8. **External Integration**: Integrate with HR and identity systems for automatic relationship management

## Compliance Frameworks

### Enterprise Standards
- **ISO 27001**: International security management standard compliance
- **SOC 2**: Service Organization Control 2 trust-based access logging
- **NIST Cybersecurity Framework**: Alignment with identity and access management controls

### Government and Defense  
- **NIST SP 800-53**: Federal information security controls for trust relationships
- **CNSSI-1253**: Committee on National Security Systems trust-based controls
- **DoD 8500 Series**: Department of Defense information assurance for trust systems

### Industry Specific
- **HIPAA**: Healthcare trust relationships with patient data protection
- **PCI DSS**: Payment card industry trust-based access to sensitive data  
- **SOX**: Sarbanes-Oxley financial controls with trust-based segregation
- **GDPR**: European privacy regulation compliance for trust relationship data

## Related Documentation

- [SoBLPMAC.md](SoBLPMAC.md) - Bell-LaPadula Mandatory Access Control integration
- [SoBibaMIC.md](SoBibaMIC.md) - Biba Mandatory Integrity Control complementary features  
- [SoDynTBAC.md](SoDynTBAC.md) - Dynamic Trust-Based Access Control synergy
- [SoDAC.md](SoDAC.md) - Discretionary Access Control within trust boundaries
- [SoNFSv4ACL.md](SoNFSv4ACL.md) - NFSv4 ACL generation from trust relationships
- [Control-Plane.md](Control-Plane.md) - System monitoring and trust relationship management
- [Security-Architecture.md](Security-Architecture.md) - Overall security framework integration
- [Organizational-Integration.md](Organizational-Integration.md) - HR and identity system integration guide
