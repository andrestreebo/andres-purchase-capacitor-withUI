import { registerPlugin } from '@capacitor/core';

import type { ASBPurchasesUIPlugin } from './definitions';

const ASBPurchasesUI = registerPlugin<ASBPurchasesUIPlugin>('ASBPurchasesUI', {
  web: () => import('./web').then((m) => new m.ASBPurchasesUIWeb()),
});

export * from './definitions';
export { ASBPurchasesUI };
