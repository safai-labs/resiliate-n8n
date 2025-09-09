import { ICredentialType, INodeProperties } from 'n8n-workflow';

export class ResiliateEventsApi implements ICredentialType {
	name = 'resiliateEventsApi';
	displayName = 'Resiliate Events API';
	documentationUrl = 'https://saf.ai/resiliate/n8n/';
// icon = "file:ninja-icon.png";
	properties: INodeProperties[] = [
		// ================================
		// Authentication Configuration
		// ================================
		{
			displayName: 'Authentication Method',
			name: 'authType',
			type: 'options',
			options: [
				{
					name: 'API Key',
					value: 'apiKey',
					description: 'Use API key authentication',
				},
				{
					name: 'OAuth 2.0',
					value: 'oauth2',
					description: 'Use OAuth 2.0 authentication',
				},
				{
					name: 'JWT Token',
					value: 'jwt',
					description: 'Use JSON Web Token authentication',
				},
				{
					name: 'Client Certificate',
					value: 'certificate',
					description: 'Use client certificate authentication',
				},
			],
			default: 'apiKey',
			description: 'The authentication method to use for Resiliate API',
		},
		
		// API Key Authentication
		{
			displayName: 'API Key',
			name: 'apiKey',
			type: 'string',
			typeOptions: {
				password: true,
			},
			default: '',
			placeholder: 'res_api_key_xxxxxxxxxxxxxxxx',
			displayOptions: {
				show: {
					authType: ['apiKey'],
				},
			},
			description: 'The API key for Resiliate platform authentication',
		},
		{
			displayName: 'API Secret',
			name: 'apiSecret',
			type: 'string',
			typeOptions: {
				password: true,
			},
			default: '',
			displayOptions: {
				show: {
					authType: ['apiKey'],
				},
			},
			description: 'The API secret for Resiliate platform authentication',
		},

		// OAuth 2.0 Authentication
		{
			displayName: 'Client ID',
			name: 'clientId',
			type: 'string',
			default: '',
			displayOptions: {
				show: {
					authType: ['oauth2'],
				},
			},
			description: 'OAuth 2.0 Client ID',
		},
		{
			displayName: 'Client Secret',
			name: 'clientSecret',
			type: 'string',
			typeOptions: {
				password: true,
			},
			default: '',
			displayOptions: {
				show: {
					authType: ['oauth2'],
				},
			},
			description: 'OAuth 2.0 Client Secret',
		},
		{
			displayName: 'Token Endpoint',
			name: 'tokenEndpoint',
			type: 'string',
			default: 'https://auth.saf.ai/oauth/token',
			displayOptions: {
				show: {
					authType: ['oauth2'],
				},
			},
			description: 'OAuth 2.0 token endpoint URL',
		},

		// JWT Authentication
		{
			displayName: 'JWT Token',
			name: 'jwtToken',
			type: 'string',
			typeOptions: {
				password: true,
			},
			default: '',
			displayOptions: {
				show: {
					authType: ['jwt'],
				},
			},
			description: 'JSON Web Token for authentication',
		},
		{
			displayName: 'JWT Secret/Public Key',
			name: 'jwtSecret',
			type: 'string',
			typeOptions: {
				password: true,
			},
			default: '',
			displayOptions: {
				show: {
					authType: ['jwt'],
				},
			},
			description: 'Secret key or public key for JWT verification',
		},

		// Certificate Authentication
		{
			displayName: 'Client Certificate',
			name: 'clientCert',
			type: 'string',
			typeOptions: {
				rows: 10,
			},
			default: '',
			placeholder: '-----BEGIN CERTIFICATE-----\n...\n-----END CERTIFICATE-----',
			displayOptions: {
				show: {
					authType: ['certificate'],
				},
			},
			description: 'Client certificate for mutual TLS authentication',
		},
		{
			displayName: 'Private Key',
			name: 'privateKey',
			type: 'string',
			typeOptions: {
				password: true,
				rows: 10,
			},
			default: '',
			placeholder: '-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----',
			displayOptions: {
				show: {
					authType: ['certificate'],
				},
			},
			description: 'Private key for client certificate authentication',
		},

		// ================================
		// Resiliate Platform Configuration
		// ================================
		{
			displayName: 'Platform Configuration',
			name: 'platformConfig',
			type: 'collection',
			default: {},
			options: [
				{
					displayName: 'Environment',
					name: 'environment',
					type: 'options',
					options: [
						{
							name: 'Production',
							value: 'production',
							description: 'Production environment',
						},
						{
							name: 'Staging',
							value: 'staging',
							description: 'Staging environment',
						},
						{
							name: 'Development',
							value: 'development',
							description: 'Development environment',
						},
						{
							name: 'On-Premises',
							value: 'onpremises',
							description: 'On-premises deployment',
						},
					],
					default: 'production',
					description: 'Target environment for Resiliate platform',
				},
				{
					displayName: 'Base URL',
					name: 'baseUrl',
					type: 'string',
					default: 'https://api.saf.ai/resiliate',
					description: 'Base URL for Resiliate API endpoints',
				},
				{
					displayName: 'Organization ID',
					name: 'organizationId',
					type: 'string',
					default: '',
					placeholder: 'org_xxxxxxxxxxxxxxxx',
					description: 'Your organization identifier in Resiliate',
				},
				{
					displayName: 'Project ID',
					name: 'projectId',
					type: 'string',
					default: '',
					placeholder: 'proj_xxxxxxxxxxxxxxxx',
					description: 'Project identifier for this integration',
				},
			],
			description: 'Platform-specific configuration parameters',
		},

		// ================================
		// Security Modules Configuration
		// ================================
		{
			displayName: 'Security Modules',
			name: 'securityModules',
			type: 'collection',
			default: {},
			options: [
				{
					displayName: 'Ransomware Protection',
					name: 'ransomwareProtection',
					type: 'boolean',
					default: true,
					description: 'Enable ransomware detection and protection monitoring',
				},
				{
					displayName: 'File Integrity Monitoring',
					name: 'fileIntegrityMonitoring',
					type: 'boolean',
					default: true,
					description: 'Enable file integrity monitoring and change detection',
				},
				{
					displayName: 'Data Loss Prevention',
					name: 'dataLossPrevention',
					type: 'boolean',
					default: false,
					description: 'Enable data loss prevention monitoring',
				},
				{
					displayName: 'Network Security Monitoring',
					name: 'networkSecurityMonitoring',
					type: 'boolean',
					default: false,
					description: 'Enable network traffic and security monitoring',
				},
				{
					displayName: 'Behavioral Analytics',
					name: 'behavioralAnalytics',
					type: 'boolean',
					default: false,
					description: 'Enable user and system behavioral analysis',
				},
				{
					displayName: 'Zero-Day Protection',
					name: 'zeroDayProtection',
					type: 'boolean',
					default: false,
					description: 'Enable advanced zero-day threat detection',
				},
				{
					displayName: 'Compliance Monitoring',
					name: 'complianceMonitoring',
					type: 'boolean',
					default: false,
					description: 'Enable regulatory compliance monitoring (GDPR, HIPAA, etc.)',
				},
				{
					displayName: 'Incident Response',
					name: 'incidentResponse',
					type: 'boolean',
					default: true,
					description: 'Enable automated incident response capabilities',
				},
			],
			description: 'Configure which Resiliate security modules are active',
		},

		// ================================
		// Advanced Security Settings
		// ================================
		{
			displayName: 'Advanced Security',
			name: 'advancedSecurity',
			type: 'collection',
			default: {},
			options: [
				{
					displayName: 'Enable Encryption in Transit',
					name: 'encryptionInTransit',
					type: 'boolean',
					default: true,
					description: 'Enforce TLS encryption for all API communications',
				},
				{
					displayName: 'Certificate Validation',
					name: 'certificateValidation',
					type: 'options',
					options: [
						{
							name: 'Strict',
							value: 'strict',
							description: 'Full certificate chain validation',
						},
						{
							name: 'Standard',
							value: 'standard',
							description: 'Standard certificate validation',
						},
						{
							name: 'Relaxed',
							value: 'relaxed',
							description: 'Allow self-signed certificates (not recommended for production)',
						},
					],
					default: 'strict',
					description: 'Level of TLS certificate validation',
				},
				{
					displayName: 'Rate Limiting',
					name: 'rateLimiting',
					type: 'collection',
					default: {},
					options: [
						{
							displayName: 'Enable Rate Limiting',
							name: 'enabled',
							type: 'boolean',
							default: true,
							description: 'Enable API rate limiting protection',
						},
						{
							displayName: 'Max Requests per Minute',
							name: 'maxRequestsPerMinute',
							type: 'number',
							default: 100,
							description: 'Maximum API requests per minute',
						},
						{
							displayName: 'Burst Limit',
							name: 'burstLimit',
							type: 'number',
							default: 10,
							description: 'Maximum burst requests allowed',
						},
					],
				},
				{
					displayName: 'Audit Logging',
					name: 'auditLogging',
					type: 'collection',
					default: {},
					options: [
						{
							displayName: 'Enable Audit Logging',
							name: 'enabled',
							type: 'boolean',
							default: true,
							description: 'Enable comprehensive audit logging',
						},
						{
							displayName: 'Log Level',
							name: 'logLevel',
							type: 'options',
							options: [
								{
									name: 'Debug',
									value: 'debug',
									description: 'Detailed debug information',
								},
								{
									name: 'Info',
									value: 'info',
									description: 'General information messages',
								},
								{
									name: 'Warning',
									value: 'warning',
									description: 'Warning messages only',
								},
								{
									name: 'Error',
									value: 'error',
									description: 'Error messages only',
								},
							],
							default: 'info',
							description: 'Audit log verbosity level',
						},
						{
							displayName: 'Include Request/Response Bodies',
							name: 'includePayloads',
							type: 'boolean',
							default: false,
							description: 'Include full request/response payloads in audit logs (may contain sensitive data)',
						},
					],
				},
			],
			description: 'Advanced security configuration options',
		},
	];
}
