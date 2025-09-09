#!/usr/bin/env node

// Simple test script to demonstrate the metadata collection functionality
const { execSync } = require('child_process');
const os = require('os');

class MetadataCollector {
    static safeExec(command, timeout = 5000) {
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

    static getBasicMetadata() {
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

    static getStandardMetadata() {
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

    static getDetailedMetadata() {
        const standard = MetadataCollector.getStandardMetadata();

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
}

console.log('=== Resiliate n8n Node - Metadata Collection Test ===\n');

console.log('1. Basic Metadata:');
console.log(JSON.stringify(MetadataCollector.getBasicMetadata(), null, 2));
console.log('\n');

console.log('2. Standard Metadata:');
console.log(JSON.stringify(MetadataCollector.getStandardMetadata(), null, 2));
console.log('\n');

console.log('3. Detailed Metadata:');
console.log(JSON.stringify(MetadataCollector.getDetailedMetadata(), null, 2));
console.log('\n');

console.log('=== Test completed successfully! ===');
