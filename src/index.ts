import { registerPlugin } from '@capacitor/core';

import type { PurchasesUIPlugin } from './definitions';

const PurchasesUI = registerPlugin<PurchasesUIPlugin>('PurchasesUI', {
  web: () => import('./web').then(m => new m.PurchasesUIWeb()),
});

export * from './definitions';
export { PurchasesUI }; 