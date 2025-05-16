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

/**
 * ASB Purchases UI Plugin interface
 * 
 * Note: Paywall and Customer Center features require iOS 15.0+ on Apple devices.
 * Android requires API level 24+ (Android 7.0+)
 */
export interface ASBPurchasesUIPlugin {
  /**
   * Configure RevenueCat SDK with your API key
   */
  configure(opts: ConfigureOptions): Promise<void>;
  
  /**
   * Present a paywall to the user
   * 
   * Note: Requires iOS 15.0+ on Apple devices
   */
  presentPaywall(opts?: PaywallOptions): Promise<PaywallResult>;
  
  /**
   * Present a paywall only if the user doesn't have the required entitlement
   * 
   * Note: Requires iOS 15.0+ on Apple devices
   */
  presentPaywallIfNeeded(opts: PaywallOptions & { requiredEntitlementId: string }): Promise<PaywallResult>;
  
  /**
   * Present the Customer Center for subscription management
   * 
   * Note: Requires iOS 15.0+ on Apple devices
   */
  presentCustomerCenter(opts?: CustomerCenterOptions): Promise<void>;
}
