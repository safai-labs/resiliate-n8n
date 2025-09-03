import {
	IHookFunctions,
	IWebhookFunctions,
	IDataObject,
	INodeType,
	INodeTypeDescription,
	IWebhookResponseData,
	NodeConnectionType,
} from 'n8n-workflow';

export class ResiliateEvents implements INodeType {
	description: INodeTypeDescription = {
		displayName: 'Resiliate Events',
		name: 'resiliateEvents',
		icon: 'file:ninja-icon.png',
		group: ['trigger'],
		version: 1,
		description: 'Starts a workflow when a Resiliate event is received.',
		defaults: {
			name: 'Resiliate Events',
		},
		inputs: [],
		outputs: [NodeConnectionType.Main],
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

	async webhook(this: IWebhookFunctions): Promise<IWebhookResponseData> {
		const body = this.getBodyData();

		return {
			workflowData: [this.helpers.returnJsonArray([body as IDataObject])],
		};
	}
}
