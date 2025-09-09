import {
	IHookFunctions,
	IWebhookFunctions,
	IDataObject,
	INodeType,
	INodeTypeDescription,
	IWebhookResponseData,
	NodeConnectionType,
	INodePropertyOptions,
	ICredentialsDecrypted,
	ICredentialDataDecryptedObject,
} from 'n8n-workflow';
import { createHash } from 'crypto';
import { execSync } from 'child_process';
import * as os from 'os';

interface HostMetadata {
	hostname: string;
	timestamp: string;
	system: {
		platform: string;
		arch: string;
		release: string;
		uptime: number;
		loadAverage: number[];
	};
	memory: {
		total: number;
		free: number;
		used: number;
		usagePercent: number;
	};
	cpu: {
		cores: number;
		model: string;
		usage?: number;
	};
	disk?: {
		total: number;
		free: number;
		used: number;
		usagePercent: number;
	};
	network?: {
		interfaces: string[];
		activeConnections?: number;
	};
	processes?: {
		total: number;
		running: number;
	};
	resiliate?: {
		version?: string;
		status?: string;
		lastCheck?: string;
	};
}

interface SecurityMetadata {
	authenticationStatus: {
		method: string;
		isValid: boolean;
		lastValidated: string;
		organizationId?: string;
		projectId?: string;
		environment?: string;
	};
	securityModules: {
		[key: string]: {
			enabled: boolean;
			status: string;
			lastCheck?: string;
			threats?: number;
			errors?: string[];
		};
	};
	compliance: {
		enabled: boolean;
		standards: string[];
		lastAudit?: string;
		findings?: number;
	};
	encryption: {
		inTransit: boolean;
		certificateValidation: string;
		tlsVersion?: string;
	};
	auditTrail: {
		enabled: boolean;
		logLevel: string;
		includePayloads: boolean;
		sessionId: string;
	};
}

/**
 * Utility class for collecting host metadata
 */
class MetadataCollector {
	/**
	 * Executes a command safely and returns the result
	 */
	static safeExec(command: string, timeout: number = 5000): string {
		try {
			return execSync(command, { 
				timeout,
				encoding: 'utf8',
				windowsHide: true 
			}).toString().trim();
		} catch (error) {
			return '';
		}
	}

	/**
	 * Gets basic system metadata
	 */
	static getBasicMetadata(): Partial<HostMetadata> {
		return {
			hostname: os.hostname(),
			timestamp: new Date().toISOString(),
			system: {
				platform: os.platform(),
				arch: os.arch(),
				release: os.release(),
				uptime: os.uptime(),
				loadAverage: os.loadavg(),
			},
		};
	}

	/**
	 * Gets memory and CPU information
	 */
	static getStandardMetadata(): Partial<HostMetadata> {
		const basic = MetadataCollector.getBasicMetadata();
		const totalMem = os.totalmem();
		const freeMem = os.freemem();
		const usedMem = totalMem - freeMem;

		return {
			...basic,
			memory: {
				total: totalMem,
				free: freeMem,
				used: usedMem,
				usagePercent: Math.round((usedMem / totalMem) * 100),
			},
			cpu: {
				cores: os.cpus().length,
				model: os.cpus()[0]?.model || 'Unknown',
			},
		};
	}

	/**
	 * Gets detailed system information including disk and network
	 */
	static getDetailedMetadata(): HostMetadata {
		const standard = MetadataCollector.getStandardMetadata() as HostMetadata;

		// Disk usage (Linux/macOS)
		const diskUsage = MetadataCollector.safeExec("df / | tail -1 | awk '{print $2,$3,$4,$5}'");
		if (diskUsage) {
			const [total, used, free, percent] = diskUsage.split(' ');
			standard.disk = {
				total: parseInt(total) * 1024 || 0,
				used: parseInt(used) * 1024 || 0,
				free: parseInt(free) * 1024 || 0,
				usagePercent: parseInt(percent.replace('%', '')) || 0,
			};
		}

		// Network interfaces
		const networkInterfaces = os.networkInterfaces();
		standard.network = {
			interfaces: Object.keys(networkInterfaces),
			activeConnections: parseInt(MetadataCollector.safeExec("ss -t | wc -l")) - 1 || 0,
		};

		// Process information
		const processCount = MetadataCollector.safeExec("ps aux | wc -l");
		const runningCount = MetadataCollector.safeExec("ps aux | grep -E '^[^ ]+ +[^ ]+ +[^ ]+ +[^ ]+ +[^ ]+ +R' | wc -l");
		standard.processes = {
			total: parseInt(processCount) - 1 || 0,
			running: parseInt(runningCount) || 0,
		};

		return standard;
	}

	/**
	 * Gets Resiliate-specific status information
	 */
	static getResiliateStatus(): Partial<HostMetadata>['resiliate'] {
		const resiliate: Partial<HostMetadata>['resiliate'] = {};

		// Try to get Resiliate version
		resiliate.version = MetadataCollector.safeExec("resiliate --version 2>/dev/null || echo 'not installed'");
		
		// Check if Resiliate service is running
		const serviceStatus = MetadataCollector.safeExec("systemctl is-active resiliate 2>/dev/null || service resiliate status 2>/dev/null | grep -q running && echo 'active' || echo 'inactive'");
		resiliate.status = serviceStatus || 'unknown';

		// Get last check timestamp if available
		resiliate.lastCheck = MetadataCollector.safeExec("cat /var/log/resiliate/last-check 2>/dev/null || echo 'unknown'");

		return resiliate;
	}

	/**
	 * Collects metadata from a remote host via SSH
	 */
	static async getRemoteHostMetadata(host: string, sshUser: string, depth: string): Promise<HostMetadata | null> {
		try {
			const commands = {
				basic: `hostname; date -Iseconds; uname -srm; uptime`,
				standard: `hostname; date -Iseconds; uname -srm; uptime; free -b; nproc; cat /proc/cpuinfo | grep 'model name' | head -1`,
				detailed: `hostname; date -Iseconds; uname -srm; uptime; free -b; nproc; cat /proc/cpuinfo | grep 'model name' | head -1; df /; ss -t | wc -l; ps aux | wc -l`,
			};

			const command = `ssh -o ConnectTimeout=10 -o BatchMode=yes ${sshUser}@${host} "${commands[depth as keyof typeof commands]}"`;
			const result = MetadataCollector.safeExec(command, 15000);

			if (!result) return null;

			const lines = result.split('\n');
			const metadata: HostMetadata = {
				hostname: lines[0] || host,
				timestamp: lines[1] || new Date().toISOString(),
				system: {
					platform: lines[2]?.split(' ')[0] || 'unknown',
					arch: lines[2]?.split(' ')[2] || 'unknown',
					release: lines[2]?.split(' ')[1] || 'unknown',
					uptime: 0,
					loadAverage: [],
				},
				memory: { total: 0, free: 0, used: 0, usagePercent: 0 },
				cpu: { cores: 0, model: 'Unknown' },
			};

			// Parse uptime and load average from line 3
			const uptimeMatch = lines[3]?.match(/up\s+(.+?),\s+load average:\s+(.+)/);
			if (uptimeMatch) {
				metadata.system.loadAverage = uptimeMatch[2].split(',').map(x => parseFloat(x.trim()));
			}

			if (depth !== 'basic' && lines[4]) {
				// Parse memory info
				const memoryMatch = lines[4].match(/(\d+)/g);
				if (memoryMatch && memoryMatch.length >= 3) {
					metadata.memory.total = parseInt(memoryMatch[0]);
					metadata.memory.used = parseInt(memoryMatch[1]);
					metadata.memory.free = parseInt(memoryMatch[2]);
					metadata.memory.usagePercent = Math.round((metadata.memory.used / metadata.memory.total) * 100);
				}

				// Parse CPU info
				metadata.cpu.cores = parseInt(lines[5]) || 0;
				metadata.cpu.model = lines[6]?.split(':')[1]?.trim() || 'Unknown';
			}

			return metadata;
		} catch (error) {
			console.error(`Failed to collect metadata from ${host}:`, error);
			return null;
		}
	}

	/**
	 * Main metadata collection orchestrator
	 */
	static async collectAllMetadata(
		depth: string,
		additionalHosts: string,
		sshUser: string,
		includeResiliate: boolean
	): Promise<{ localhost: HostMetadata; remoteHosts: HostMetadata[] }> {
		// Collect localhost metadata
		let localhost: HostMetadata;
		switch (depth) {
			case 'basic':
				localhost = MetadataCollector.getBasicMetadata() as HostMetadata;
				break;
			case 'detailed':
				localhost = MetadataCollector.getDetailedMetadata();
				break;
			default:
				localhost = MetadataCollector.getStandardMetadata() as HostMetadata;
		}

		// Add Resiliate status if requested
		if (includeResiliate) {
			localhost.resiliate = MetadataCollector.getResiliateStatus();
		}

		// Collect remote hosts metadata
		const remoteHosts: HostMetadata[] = [];
		if (additionalHosts) {
			const hosts = additionalHosts.split(',').map(h => h.trim()).filter(h => h);
			
			const promises = hosts.map(host => 
				MetadataCollector.getRemoteHostMetadata(host, sshUser, depth)
			);

			const results = await Promise.all(promises);
			remoteHosts.push(...results.filter(r => r !== null) as HostMetadata[]);
		}

		return { localhost, remoteHosts };
	}
}

/**
 * Security metadata collector
 */
class SecurityCollector {
	/**
	 * Collects security module status from the system
	 */
	static getSecurityModuleStatus(moduleName: string): any {
		const status = {
			enabled: false,
			status: 'unknown',
			lastCheck: new Date().toISOString(),
			threats: 0,
			errors: [],
		};

		try {
			switch (moduleName) {
				case 'ransomwareProtection':
					status.enabled = MetadataCollector.safeExec("ps aux | grep -v grep | grep -q resiliate-ransomware && echo 'true' || echo 'false'") === 'true';
					status.status = status.enabled ? 'active' : 'inactive';
					status.threats = parseInt(MetadataCollector.safeExec("cat /var/log/resiliate/ransomware/threats.count 2>/dev/null || echo '0'")) || 0;
					break;

				case 'fileIntegrityMonitoring':
					status.enabled = MetadataCollector.safeExec("ps aux | grep -v grep | grep -q resiliate-fim && echo 'true' || echo 'false'") === 'true';
					status.status = status.enabled ? 'active' : 'inactive';
					break;

				case 'dataLossPrevention':
					status.enabled = MetadataCollector.safeExec("systemctl is-enabled resiliate-dlp 2>/dev/null | grep -q enabled && echo 'true' || echo 'false'") === 'true';
					status.status = status.enabled ? 'active' : 'inactive';
					break;

				case 'networkSecurityMonitoring':
					status.enabled = MetadataCollector.safeExec("netstat -tulpn | grep -q :9200 && echo 'true' || echo 'false'") === 'true';
					status.status = status.enabled ? 'active' : 'inactive';
					break;

				case 'behavioralAnalytics':
					status.enabled = MetadataCollector.safeExec("ps aux | grep -v grep | grep -q resiliate-ba && echo 'true' || echo 'false'") === 'true';
					status.status = status.enabled ? 'active' : 'inactive';
					break;

				case 'zeroDayProtection':
					status.enabled = MetadataCollector.safeExec("ls /etc/resiliate/modules/ | grep -q zerosday && echo 'true' || echo 'false'") === 'true';
					status.status = status.enabled ? 'active' : 'inactive';
					break;

				case 'complianceMonitoring':
					status.enabled = MetadataCollector.safeExec("systemctl is-active resiliate-compliance 2>/dev/null | grep -q active && echo 'true' || echo 'false'") === 'true';
					status.status = status.enabled ? 'active' : 'inactive';
					break;

				case 'incidentResponse':
					status.enabled = MetadataCollector.safeExec("ps aux | grep -v grep | grep -q resiliate-ir && echo 'true' || echo 'false'") === 'true';
					status.status = status.enabled ? 'active' : 'inactive';
					break;
			}
		} catch (error) {
			(status.errors as any[]).push(`Failed to check ${moduleName}: ${error}`);
		}

		return status;
	}

	/**
	 * Generates comprehensive security metadata from credentials
	 */
	static generateSecurityMetadata(credentials: ICredentialDataDecryptedObject): SecurityMetadata {
		const sessionId = createHash('sha256')
			.update(`${Date.now()}-${Math.random()}-${os.hostname()}`)
			.digest('hex')
			.substring(0, 16);

		const platformConfig = credentials.platformConfig as any || {};
		const securityModules = credentials.securityModules as any || {};
		const advancedSecurity = credentials.advancedSecurity as any || {};

		// Authentication status
		const authStatus = {
			method: credentials.authType as string || 'apiKey',
			isValid: !!credentials.apiKey || !!credentials.jwtToken || !!credentials.clientCert,
			lastValidated: new Date().toISOString(),
			organizationId: platformConfig.organizationId,
			projectId: platformConfig.projectId,
			environment: platformConfig.environment || 'production',
		};

		// Security modules status
		const moduleStatus: any = {};
		Object.keys(securityModules).forEach(module => {
			if (securityModules[module] === true) {
				moduleStatus[module] = SecurityCollector.getSecurityModuleStatus(module);
			} else {
				moduleStatus[module] = {
					enabled: false,
					status: 'disabled',
					lastCheck: new Date().toISOString(),
				};
			}
		});

		// Compliance information
		const compliance = {
			enabled: securityModules.complianceMonitoring || false,
			standards: ['ISO27001', 'SOC2', 'GDPR'],
			lastAudit: MetadataCollector.safeExec("cat /var/log/resiliate/compliance/last-audit 2>/dev/null || echo 'never'"),
			findings: parseInt(MetadataCollector.safeExec("cat /var/log/resiliate/compliance/findings.count 2>/dev/null || echo '0'")) || 0,
		};

		// Encryption and security settings
		const auditLogging = advancedSecurity.auditLogging || {};
		const encryption = {
			inTransit: advancedSecurity.encryptionInTransit !== false,
			certificateValidation: advancedSecurity.certificateValidation || 'strict',
			tlsVersion: MetadataCollector.safeExec("openssl s_client -connect localhost:443 -servername localhost 2>/dev/null | grep 'Protocol' | awk '{print $3}' 2>/dev/null || echo 'unknown'"),
		};

		const auditTrail = {
			enabled: auditLogging.enabled !== false,
			logLevel: auditLogging.logLevel || 'info',
			includePayloads: auditLogging.includePayloads === true,
			sessionId,
		};

		return {
			authenticationStatus: authStatus,
			securityModules: moduleStatus,
			compliance,
			encryption,
			auditTrail,
		};
	}
}

export class ResiliateEvents implements INodeType {
	description: INodeTypeDescription = {
		displayName: 'Resiliate Events',
		name: 'resiliateEvents',
		icon: 'file:ninja-icon.png',
		group: ['trigger'],
		version: 1,
		description: "Starts a workflow when a Resiliate™ event is received. Part of the sāf.ai data resiliency platform.",
		defaults: {
			name: 'Resiliate Events',
		},
		inputs: [],
		outputs: [NodeConnectionType.Main],
		credentials: [
			{
				name: 'resiliateEventsApi',
				required: true,
			},
		],
		webhooks: [
			{
				name: 'default',
				httpMethod: 'POST',
				responseMode: 'onReceived',
				path: 'webhook',
			},
		],
		properties: [
			{
				displayName: 'Enable Metadata Collection',
				name: 'collectMetadata',
				type: 'boolean',
				default: true,
				description: 'Whether to collect and include host metadata with webhook events',
			},
			{
				displayName: 'Collection Depth',
				name: 'collectionDepth',
				type: 'options',
				options: [
					{
						name: 'Basic',
						value: 'basic',
						description: 'Hostname, timestamp, and basic system info',
					},
					{
						name: 'Standard',
						value: 'standard',
						description: 'Basic + memory, CPU, and load information',
					},
					{
						name: 'Detailed',
						value: 'detailed',
						description: 'Standard + disk usage, network, and process information',
					},
				],
				default: 'standard',
				displayOptions: {
					show: {
						collectMetadata: [true],
					},
				},
				description: 'How much metadata to collect from the host system',
			},
			{
				displayName: 'Additional Hosts',
				name: 'additionalHosts',
				type: 'string',
				default: '',
				placeholder: 'host1.example.com,192.168.1.100,server.local',
				displayOptions: {
					show: {
						collectMetadata: [true],
					},
				},
				description: 'Comma-separated list of additional hosts to collect metadata from (requires SSH access)',
			},
			{
				displayName: 'SSH User',
				name: 'sshUser',
				type: 'string',
				default: 'root',
				displayOptions: {
					show: {
						collectMetadata: [true],
					},
				},
				description: 'SSH username for connecting to additional hosts',
			},
			{
				displayName: 'Include Resiliate Status',
				name: 'includeResiliateStatus',
				type: 'boolean',
				default: true,
				displayOptions: {
					show: {
						collectMetadata: [true],
					},
				},
				description: 'Whether to include Resiliate-specific status information',
			},
			{
				displayName: 'Enable Security Metadata',
				name: 'collectSecurityMetadata',
				type: 'boolean',
				default: true,
				description: 'Whether to collect and include security module metadata based on configured credentials',
			},
		],
	};

	async webhook(this: IWebhookFunctions): Promise<IWebhookResponseData> {
		const body = this.getBodyData();
		const collectMetadata = this.getNodeParameter('collectMetadata') as boolean;
		const collectSecurityMetadata = this.getNodeParameter('collectSecurityMetadata') as boolean;
		
		let enrichedData: IDataObject = {
			event: body,
			receivedAt: new Date().toISOString(),
		};

		// Get credentials for security metadata
		let credentials: ICredentialDataDecryptedObject = {};
		try {
			const credentialsData = await this.getCredentials('resiliateEventsApi');
			credentials = credentialsData as ICredentialDataDecryptedObject;
		} catch (error) {
			console.warn('Failed to load credentials for security metadata:', error);
		}

		// Collect security metadata if enabled and credentials available
		if (collectSecurityMetadata && Object.keys(credentials).length > 0) {
			try {
				enrichedData.securityMetadata = SecurityCollector.generateSecurityMetadata(credentials);
			} catch (error) {
				console.error('Failed to collect security metadata:', error);
				enrichedData.securityMetadataError = 'Failed to collect security metadata';
			}
		}

		// Collect system metadata if enabled
		if (collectMetadata) {
			const depth = this.getNodeParameter('collectionDepth', 'standard') as string;
			const additionalHosts = this.getNodeParameter('additionalHosts', '') as string;
			const sshUser = this.getNodeParameter('sshUser', 'root') as string;
			const includeResiliate = this.getNodeParameter('includeResiliateStatus', true) as boolean;

			try {
				const metadata = await MetadataCollector.collectAllMetadata(depth, additionalHosts, sshUser, includeResiliate);
				enrichedData.systemMetadata = {
					collectionTime: new Date().toISOString(),
					collectionDepth: depth,
					...metadata,
				};
			} catch (error) {
				console.error('Failed to collect system metadata:', error);
				enrichedData.systemMetadataError = 'Failed to collect system metadata';
			}
		}

		return {
			workflowData: [this.helpers.returnJsonArray([enrichedData])],
		};
	}
}
