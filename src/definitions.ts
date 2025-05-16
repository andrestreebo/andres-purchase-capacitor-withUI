export interface ConfigureOptions { apiKey: string }
export interface PaywallOptions { 
  offeringId?: string;
  placementId?: string;
  displayCloseButton?: boolean;
  fontFamily?: string;
}

export interface CustomerCenterOptions {
  displayCloseButton?: boolean;
  fontFamily?: string;
}

export type PaywallResult =
  | { status: 'purchased'; transactionId: string }
  | { status: 'restored'; transactionId?: string }
  | { status: 'cancelled' }
  | { status: 'error'; code: string; message: string }

export interface ASBPurchasesUIPlugin {
  configure(opts: ConfigureOptions): Promise<void>;
  presentPaywall(opts?: PaywallOptions): Promise<PaywallResult>;
  presentPaywallIfNeeded(opts: PaywallOptions & { requiredEntitlementId: string }): Promise<PaywallResult>;
  presentCustomerCenter(opts?: CustomerCenterOptions): Promise<void>;
}
