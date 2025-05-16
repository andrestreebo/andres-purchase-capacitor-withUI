import { WebPlugin } from '@capacitor/core';

import type { ASBPurchasesUIPlugin } from './definitions';

export class ASBPurchasesUIWeb extends WebPlugin implements ASBPurchasesUIPlugin {
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }
}
