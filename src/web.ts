import { WebPlugin } from '@capacitor/core';

import type { ASBPurchasesUIPlugin, ConfigureOptions, PaywallOptions, PaywallResult } from './definitions';

export class ASBPurchasesUIWeb extends WebPlugin implements ASBPurchasesUIPlugin {
  async configure(_opts: ConfigureOptions): Promise<void> {
    console.warn('RevenueCat Purchases UI is not available on web');
  }

  async presentPaywall(_opts: PaywallOptions): Promise<PaywallResult> {
    console.warn('RevenueCat Purchases UI is not available on web');
    return {
      status: 'error',
      code: 'not_supported',
      message: 'RevenueCat Purchases UI is not available on web'
    };
  }
}
