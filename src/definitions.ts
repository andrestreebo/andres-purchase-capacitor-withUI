export interface ConfigureOptions { apiKey: string }
export interface PaywallOptions  { offeringId: string }

export type PaywallResult =
  | { status: 'purchased'; transactionId: string }
  | { status: 'cancelled' }
  | { status: 'error'; code: string; message: string }

export interface ASBPurchasesUIPlugin {
  configure(opts: ConfigureOptions): Promise<void>;
  presentPaywall(opts: PaywallOptions): Promise<PaywallResult>;
}
