import { WebPlugin } from '@capacitor/core';

import type { PaywallOptions, PaywallResult, PurchasesUIPlugin } from './definitions';

export class PurchasesUIWeb extends WebPlugin implements PurchasesUIPlugin {
  async presentPaywall(options: PaywallOptions): Promise<PaywallResult> {
    console.warn('PurchasesUI is not implemented on web. Purchase result will simulate a declined purchase.');
    return {
      didPurchase: false,
    };
  }

  async presentFooterPaywall(options: PaywallOptions): Promise<PaywallResult> {
    console.warn('PurchasesUI is not implemented on web. Purchase result will simulate a declined purchase.');
    return {
      didPurchase: false,
    };
  }

  async closePaywall(): Promise<void> {
    console.warn('PurchasesUI is not implemented on web.');
  }
} 