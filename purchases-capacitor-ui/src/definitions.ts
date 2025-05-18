export interface PaywallCallbacks {
  onPresented?: () => void;
  onDismissed?: () => void;
  onError?: (error: PaywallError) => void;
  onPurchaseStarted?: () => void;
  onPurchaseCompleted?: () => void;
  onPurchaseError?: (error: PaywallError) => void;
  onRestoreStarted?: () => void;
  onRestoreCompleted?: () => void;
  onRestoreError?: (error: PaywallError) => void;
}

export interface CustomerCenterCallbacks {
  onDismissed?: () => void;
  onRestoreStarted?: () => void;
  onRestoreCompleted?: () => void;
  onRestoreError?: (error: PaywallError) => void;
  onError?: (error: PaywallError) => void;
}

export interface PaywallError {
  code: string;
  message: string;
}

export interface PaywallResult {
  status: 'purchased' | 'restored' | 'cancelled' | 'error';
  transactionId?: string;
  error?: PaywallError;
}

export interface Overrides {
  // Font options
  fontFamily?: string;
  titleFontSize?: number;
  bodyFontSize?: number;
  captionFontSize?: number;
  
  // Colors
  backgroundColor?: string;
  primaryTextColor?: string;
  secondaryTextColor?: string;
  accentColor?: string;
  
  // Button options
  primaryButtonBackgroundColor?: string;
  primaryButtonTextColor?: string;
  secondaryButtonBackgroundColor?: string;
  secondaryButtonTextColor?: string;
  
  // Text overrides
  title?: string;
  subtitle?: string;
  callToAction?: string;
  restoreButtonText?: string;
  
  // Display options
  displayCloseButton?: boolean;
}

export interface PaywallArgs {
  offeringIdentifier?: string;
  requiredEntitlementIdentifier?: string;
  overrides?: Overrides;
  callbacks?: PaywallCallbacks;
}

export interface CustomerCenterArgs {
  callbacks?: CustomerCenterCallbacks;
}

export interface RevenueCatUIPlugin {
  /**
   * Always shows the configured paywall
   * @param args The optional configuration for the paywall
   * @returns Promise that resolves to a PaywallResult
   */
  presentPaywall(args?: PaywallArgs): Promise<PaywallResult>;

  /**
   * Shows the paywall only if the user doesn't own the required entitlement
   * @param args Configuration for the paywall including the required entitlement
   * @returns Promise that resolves to a PaywallResult or null if not presented
   */
  presentPaywallIfNeeded(args: PaywallArgs): Promise<PaywallResult | null>;

  /**
   * Opens the self-service Customer Center
   * @param args The optional configuration for the Customer Center
   * @returns Promise that resolves when the Customer Center is presented
   */
  presentCustomerCenter(args?: CustomerCenterArgs): Promise<void>;

  /**
   * Supply style / text overrides before launching any paywall
   * @param overrides The style and text overrides to apply
   * @returns Promise that resolves when the overrides are set
   */
  setPaywallOverrides(overrides: Overrides): Promise<void>;
} 