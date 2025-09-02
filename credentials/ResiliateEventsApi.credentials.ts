import { ICredentialType, INodeProperties } from 'n8n-workflow';

export class ResiliateEventsApi implements ICredentialType {
	name = 'resiliateEventsApi';
	displayName = 'Resiliate Events API';
	properties: INodeProperties[] = [];
}
