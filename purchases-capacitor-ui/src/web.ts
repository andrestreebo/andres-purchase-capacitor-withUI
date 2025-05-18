import { WebPlugin } from '@capacitor/core';

import type { 
  RevenueCatUIPlugin, 
  PaywallArgs, 
  PaywallResult, 
  CustomerCenterArgs, 
  Overrides
} from './definitions';

export class RevenueCatUIWeb extends WebPlugin implements RevenueCatUIPlugin {
  async presentPaywall(args?: PaywallArgs): Promise<PaywallResult> {
    console.warn('RevenueCatUI.presentPaywall is not implemented on web');
    return {
      status: 'error',
      error: {
        code: 'not_implemented',
        message: 'RevenueCatUI.presentPaywall is not implemented on web',
      }
    };
  }

  async presentPaywallIfNeeded(args: PaywallArgs): Promise<PaywallResult | null> {
    console.warn('RevenueCatUI.presentPaywallIfNeeded is not implemented on web');
    return {
      status: 'error',
      error: {
        code: 'not_implemented',
        message: 'RevenueCatUI.presentPaywallIfNeeded is not implemented on web',
      }
    };
  }

  async presentCustomerCenter(args?: CustomerCenterArgs): Promise<void> {
    console.warn('RevenueCatUI.presentCustomerCenter is not implemented on web');
  }

  async setPaywallOverrides(overrides: Overrides): Promise<void> {
    console.warn('RevenueCatUI.setPaywallOverrides is not implemented on web');
  }
} 