export interface ASBPurchasesUIPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
}
