"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ResiliateEvents = void 0;
class ResiliateEvents {
    constructor() {
        this.description = {
            displayName: 'Resiliate Events',
            name: 'resiliateEvents',
            group: ['trigger'],
            version: 1,
            description: 'Starts a workflow when a Resiliate event is received.',
            defaults: {
                name: 'Resiliate Events',
            },
            inputs: [],
            outputs: ["main" /* NodeConnectionType.Main */],
            webhooks: [
                {
                    name: 'default',
                    httpMethod: 'POST',
                    responseMode: 'onReceived',
                    path: 'webhook',
                },
            ],
            properties: [],
        };
    }
    async webhook() {
        const body = this.getBodyData();
        return {
            workflowData: [this.helpers.returnJsonArray([body])],
        };
    }
}
exports.ResiliateEvents = ResiliateEvents;
