# ASB Purchases UI Capacitor

A Capacitor plugin that wraps the RevenueCat UI SDKs for iOS and Android.

## Features

- Present paywalls to users directly from RevenueCat Offerings
- Conditionally present paywalls based on user's entitlements 
- Support for placement IDs and offering IDs
- Customization options for fonts and display settings
- Customer Center UI for subscription management

## Requirements

⚠️ **Important Version Requirements**:

- **iOS**: 
  - Base SDK: 13.0+
  - **Paywalls and Customer Center**: iOS 15.0+ only
  - Earlier iOS versions will receive appropriate error messages
- **Android**: API level 24+ (Android 7.0+)
- **Capacitor**: 5.0+

## Installation

```bash
npm install asb-purchases-ui-capacitor
npx cap sync
```

## Usage

### Configuration

First, configure the plugin with your RevenueCat API key:

```typescript
import { ASBPurchasesUI } from 'asb-purchases-ui-capacitor';

// Initialize the plugin
await ASBPurchasesUI.configure({
  apiKey: 'your_revenuecat_api_key'
});
```

### Presenting a Paywall

You can present a paywall using either an offering ID or a placement ID:

```typescript
import { ASBPurchasesUI } from 'asb-purchases-ui-capacitor';

// On iOS, check if the device meets the version requirements
// For production apps, you should provide a fallback UI for iOS < 15
try {
  // Present paywall with an offering ID
  const result = await ASBPurchasesUI.presentPaywall({
    offeringId: 'premium',
    displayCloseButton: true, // optional, defaults to true
    fontFamily: 'Arial' // optional
  });

  // Handle the result
  switch (result.status) {
    case 'purchased':
      console.log('Purchase successful!', result.transactionId);
      break;
    case 'restored':
      console.log('Purchase restored!');
      break;
    case 'cancelled':
      console.log('User cancelled the purchase');
      break;
    case 'error':
      console.error('Error:', result.message);
      break;
  }
} catch (error) {
  console.error('Failed to present paywall:', error);
  // Show your own fallback UI on older iOS versions
}
```

### Conditional Paywall Presentation

You can conditionally present a paywall if the user doesn't have a specific entitlement:

```typescript
import { ASBPurchasesUI } from 'asb-purchases-ui-capacitor';

try {
  const result = await ASBPurchasesUI.presentPaywallIfNeeded({
    requiredEntitlementId: 'premium',
    offeringId: 'premium_offering', // optional
    placementId: 'home_screen', // optional
    displayCloseButton: true, // optional, defaults to true
    fontFamily: 'Arial' // optional
  });

  // If the user already has the entitlement, result.status will be 'restored'
  // Otherwise, the paywall will be presented and result will match the user's action
} catch (error) {
  console.error('Failed to present paywall:', error);
  // Show your own fallback UI on older iOS versions
}
```

### Customer Center

Present the Customer Center for users to manage their subscriptions (iOS 15.0+ and Android):

```typescript
import { ASBPurchasesUI } from 'asb-purchases-ui-capacitor';

try {
  await ASBPurchasesUI.presentCustomerCenter({
    displayCloseButton: true, // optional, defaults to true
    fontFamily: 'Arial' // optional
  });
} catch (error) {
  console.error('Failed to present Customer Center:', error);
  // Show your own fallback UI on older iOS versions
}
```

## RevenueCat UI Configuration

To use this plugin effectively, you'll need to configure paywalls and customer center in the RevenueCat dashboard. Visit the [RevenueCat Documentation](https://www.revenuecat.com/docs/tools/paywalls) for more information.

## Troubleshooting

### iOS Version Compatibility

- **"PaywallViewController is only available on iOS 15.0+"**: This error occurs on devices running iOS versions below 15.0. You should provide a fallback UI for these devices.

- **Property not found**: If you see warnings about missing properties, ensure you're using the latest version of RevenueCat SDK (4.31.0+).

### Android Issues

- If you encounter issues with placements on Android, the plugin will automatically fall back to using offering IDs or the default offering.

### RevenueCat SDK Version

This plugin requires:
- RevenueCat SDK 4.31.0+ 
- RevenueCatUI 4.31.0+

To update your RevenueCat SDK version:

**iOS (in podfile):**
```ruby
pod 'RevenueCat', '~> 4.31.0'
pod 'RevenueCatUI', '~> 4.31.0'
```

**Android (in build.gradle):**
```gradle
implementation 'com.revenuecat.purchases:purchases:6.0.0'
implementation 'com.revenuecat.purchases:purchases-ui:6.0.0'
```

## API Documentation

### configure(options)

Configure the RevenueCat SDK with your API key.

```typescript
configure(opts: ConfigureOptions): Promise<void>
```

**Parameters:**
- `opts: ConfigureOptions` - Configuration options containing:
  - `apiKey: string` - Your RevenueCat API key

### presentPaywall(options)

Present a paywall to the user. (iOS 15.0+ required)

```typescript
presentPaywall(opts?: PaywallOptions): Promise<PaywallResult>
```

**Parameters:**
- `opts: PaywallOptions` (optional) - Paywall options containing:
  - `offeringId?: string` - The offering ID to present (optional)
  - `placementId?: string` - The placement ID to present (optional)
  - `displayCloseButton?: boolean` - Whether to display a close button (defaults to true)
  - `fontFamily?: string` - Custom font family to use (optional)

**Returns:**
- `Promise<PaywallResult>` - Result of the paywall presentation

### presentPaywallIfNeeded(options)

Present a paywall only if the user doesn't have the required entitlement. (iOS 15.0+ required)

```typescript
presentPaywallIfNeeded(opts: PaywallOptions & { requiredEntitlementId: string }): Promise<PaywallResult>
```

**Parameters:**
- `opts: PaywallOptions & { requiredEntitlementId: string }` - Options containing:
  - `requiredEntitlementId: string` - The entitlement ID to check
  - `offeringId?: string` - The offering ID to present (optional)
  - `placementId?: string` - The placement ID to present (optional)
  - `displayCloseButton?: boolean` - Whether to display a close button (defaults to true)
  - `fontFamily?: string` - Custom font family to use (optional)

**Returns:**
- `Promise<PaywallResult>` - Result of the paywall presentation

### presentCustomerCenter(options)

Present the Customer Center for subscription management. (iOS 15.0+ required)

```typescript
presentCustomerCenter(opts?: CustomerCenterOptions): Promise<void>
```

**Parameters:**
- `opts: CustomerCenterOptions` (optional) - Options containing:
  - `displayCloseButton?: boolean` - Whether to display a close button (defaults to true)
  - `fontFamily?: string` - Custom font family to use (optional)

## Types

### PaywallResult

Result of a paywall presentation:

```typescript
type PaywallResult =
  | { status: 'purchased'; transactionId: string }
  | { status: 'restored'; transactionId?: string }
  | { status: 'cancelled' }
  | { status: 'error'; code: string; message: string }
```

## License

MIT