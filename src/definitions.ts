export interface PurchasesUIPlugin {
  /**
   * Present the paywall UI with the provided configuration.
   * 
   * @param options Configuration options for the paywall
   */
  presentPaywall(options: PaywallOptions): Promise<PaywallResult>;

  /**
   * Present a footer paywall with the provided configuration.
   * 
   * @param options Configuration options for the footer paywall
   */
  presentFooterPaywall(options: PaywallOptions): Promise<PaywallResult>;

  /**
   * Close any currently displayed paywall.
   */
  closePaywall(): Promise<void>;
}

export interface PaywallOptions {
  /**
   * The offering identifier to display in the paywall.
   */
  offering?: string;

  /**
   * The display mode for the paywall.
   */
  displayMode?: 'fullScreen' | 'sheet';

  /**
   * Font family to use in the paywall.
   */
  fontFamily?: string;

  /**
   * Custom colors for theming the paywall.
   */
  colors?: {
    /**
     * Primary accent color.
     */
    accent?: string;

    /**
     * Text color.
     */
    text?: string;

    /**
     * Background color.
     */
    background?: string;

    /**
     * Secondary background color.
     */
    secondaryBackground?: string;
  };
}

export interface PaywallResult {
  /**
   * Whether a purchase was completed successfully.
   */
  didPurchase: boolean;

  /**
   * The product identifier that was purchased, if any.
   */
  productIdentifier?: string;
} 