import { WebPlugin } from '@capacitor/core';

import type { 
  ASBPurchasesUIPlugin, 
  ConfigureOptions, 
  PaywallOptions, 
  PaywallResult,
  CustomerCenterOptions 
} from './definitions';

export class ASBPurchasesUIWeb extends WebPlugin implements ASBPurchasesUIPlugin {
  async configure(_opts: ConfigureOptions): Promise<void> {
    console.warn('RevenueCat Purchases UI is not available on web');
  }

  async presentPaywall(_opts?: PaywallOptions): Promise<PaywallResult> {
    console.warn('RevenueCat Purchases UI is not available on web');
    return {
      status: 'error',
      code: 'not_supported',
      message: 'RevenueCat Purchases UI is not available on web'
    };
  }
  
  async presentPaywallIfNeeded(_opts: PaywallOptions & { requiredEntitlementId: string }): Promise<PaywallResult> {
    console.warn('RevenueCat Purchases UI is not available on web');
    return {
      status: 'error',
      code: 'not_supported',
      message: 'RevenueCat Purchases UI is not available on web'
    };
  }
  
  async presentCustomerCenter(_opts?: CustomerCenterOptions): Promise<void> {
    console.warn('RevenueCat Customer Center UI is not available on web');
  }
}
