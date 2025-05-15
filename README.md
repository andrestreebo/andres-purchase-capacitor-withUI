# RevenueCat Purchases UI for Capacitor

A Capacitor plugin that provides access to RevenueCat's UI components for displaying paywalls and managing in-app purchases.

## Installation

```bash
npm install @revenuecat/purchases-ui-capacitor
npx cap sync
```

### iOS Setup

Add the following to your `ios/App/App/Info.plist` file inside the outermost `<dict>`:

```xml
<key>SKAdNetworkItems</key>
<array>
  <dict>
    <key>SKAdNetworkIdentifier</key>
    <string>2u9pt9hc89.skadnetwork</string>
  </dict>
</array>
```

## Requirements

This plugin requires:

- Capacitor 5.0.0 or higher
- iOS 13.0 or higher
- Android API level 21 or higher
- @revenuecat/purchases-capacitor 10.0.0 or higher

## Usage

First, make sure you have initialized the main Purchases SDK:

```typescript
import { Purchases } from '@revenuecat/purchases-capacitor';

// Configure the main Purchases SDK
Purchases.configure({
  apiKey: 'your_api_key',
  appUserID: 'user_id', // Optional
});
```

Then you can use the UI components:

```typescript
import { PurchasesUI } from '@revenuecat/purchases-ui-capacitor';

// Present a paywall
async function showPaywall() {
  const result = await PurchasesUI.presentPaywall({
    offering: 'default', // Optional
    displayMode: 'fullScreen', // 'fullScreen' or 'sheet'
    fontFamily: 'Avenir', // Optional
    colors: {
      accent: '#FF0000',
      text: '#000000',
      background: '#FFFFFF',
      secondaryBackground: '#F5F5F5'
    }
  });
  
  if (result.didPurchase) {
    console.log(`User purchased product: ${result.productIdentifier}`);
  }
}

// Present a footer paywall
async function showFooterPaywall() {
  const result = await PurchasesUI.presentFooterPaywall({
    offering: 'default' // Optional
  });
  
  if (result.didPurchase) {
    console.log(`User purchased product: ${result.productIdentifier}`);
  }
}

// Close any currently displayed paywall
async function closePaywall() {
  await PurchasesUI.closePaywall();
}
```

## API Documentation

### PurchasesUI

#### presentPaywall(options: PaywallOptions): Promise<PaywallResult>

Presents a paywall UI with the provided configuration.

#### presentFooterPaywall(options: PaywallOptions): Promise<PaywallResult>

Presents a footer paywall UI with the provided configuration.

#### closePaywall(): Promise<void>

Closes any currently displayed paywall.

### PaywallOptions

| Property | Type | Description |
| --- | --- | --- |
| offering | string | (Optional) The offering identifier to display in the paywall. |
| displayMode | 'fullScreen' \| 'sheet' | (Optional) The display mode for the paywall. |
| fontFamily | string | (Optional) Font family to use in the paywall. |
| colors | object | (Optional) Custom colors for theming the paywall. |

#### colors object

| Property | Type | Description |
| --- | --- | --- |
| accent | string | (Optional) Primary accent color in hexadecimal format. |
| text | string | (Optional) Text color in hexadecimal format. |
| background | string | (Optional) Background color in hexadecimal format. |
| secondaryBackground | string | (Optional) Secondary background color in hexadecimal format. |

### PaywallResult

| Property | Type | Description |
| --- | --- | --- |
| didPurchase | boolean | Whether a purchase was completed successfully. |
| productIdentifier | string | (Optional) The product identifier that was purchased, if any. |

## License

MIT 