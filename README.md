# @revenuecat/purchases-capacitor-ui

RevenueCat UI SDK for Capacitor applications. This plugin provides a simple way to display RevenueCat paywalls and customer center in your Capacitor app.

## Installation

```bash
npm install @revenuecat/purchases-capacitor-ui
npx cap sync
```

## Requirements

- Capacitor 5.0.0+
- iOS 13.0+
- Android API level 24+ (Android 7.0+)

For iOS, make sure to install PurchasesHybridCommonUI via CocoaPods by adding the following to your Podfile:

```ruby
pod 'PurchasesHybridCommonUI', '~> 13.32'
```

## Usage

First, make sure you've configured the core RevenueCat SDK in your app. Then you can use the UI plugin as follows:

### Showing a Paywall

```typescript
import { RevenueCatUI } from '@revenuecat/purchases-capacitor-ui';

// Present the default paywall
await RevenueCatUI.presentPaywall();

// Present a specific offering's paywall
await RevenueCatUI.presentPaywall({
  offeringIdentifier: 'premium'
});

// Present a paywall with callbacks
await RevenueCatUI.presentPaywall({
  offeringIdentifier: 'premium',
  callbacks: {
    onDismissed: () => {
      console.log('Paywall dismissed');
    },
    onPurchaseCompleted: () => {
      console.log('Purchase completed');
    }
  }
});
```

### Showing a Paywall Only if Needed

```typescript
import { RevenueCatUI } from '@revenuecat/purchases-capacitor-ui';

// Present a paywall only if the user doesn't have the 'premium' entitlement
const result = await RevenueCatUI.presentPaywallIfNeeded({
  requiredEntitlementIdentifier: 'premium'
});

// If result is null, the user already has the entitlement
if (result === null) {
  console.log('User already has the required entitlement');
} else {
  console.log('Paywall was presented with result:', result);
}
```

### Showing the Customer Center

```typescript
import { RevenueCatUI } from '@revenuecat/purchases-capacitor-ui';

// Present the customer center
await RevenueCatUI.presentCustomerCenter();

// Present with callbacks
await RevenueCatUI.presentCustomerCenter({
  callbacks: {
    onDismissed: () => {
      console.log('Customer center dismissed');
    },
    onRestoreCompleted: () => {
      console.log('Purchases restored');
    }
  }
});
```

### Customizing Paywalls

You can customize the appearance of paywalls by setting overrides:

```typescript
import { RevenueCatUI } from '@revenuecat/purchases-capacitor-ui';

// Set global overrides that apply to all paywalls
await RevenueCatUI.setPaywallOverrides({
  // Colors
  backgroundColor: '#FFFFFF',
  primaryTextColor: '#000000',
  accentColor: '#FF0000',
  
  // Font options
  fontFamily: 'Helvetica',
  
  // Text overrides
  title: 'Custom Title',
  callToAction: 'Subscribe Now',
  
  // Display options
  displayCloseButton: true
});

// Or set overrides for a specific paywall
await RevenueCatUI.presentPaywall({
  offeringIdentifier: 'premium',
  overrides: {
    backgroundColor: '#000000',
    primaryTextColor: '#FFFFFF',
    displayCloseButton: true
  }
});
```

## API

### RevenueCatUI

#### Methods

| Method | Description |
| ------ | ----------- |
| `presentPaywall(args?: PaywallArgs): Promise<PaywallResult>` | Presents a paywall modally. |
| `presentPaywallIfNeeded(args: PaywallArgs): Promise<PaywallResult \| null>` | Presents a paywall only if the user doesn't have the required entitlement. |
| `presentCustomerCenter(args?: CustomerCenterArgs): Promise<void>` | Presents the customer center modally. |
| `setPaywallOverrides(overrides: Overrides): Promise<void>` | Sets global overrides for all paywalls. |

#### Types

```typescript
interface PaywallArgs {
  offeringIdentifier?: string;
  requiredEntitlementIdentifier?: string;
  overrides?: Overrides;
  callbacks?: PaywallCallbacks;
}

interface CustomerCenterArgs {
  callbacks?: CustomerCenterCallbacks;
}

interface PaywallResult {
  status: 'purchased' | 'restored' | 'cancelled' | 'error';
  transactionId?: string;
  error?: PaywallError;
}

interface PaywallError {
  code: string;
  message: string;
}
```

For a complete list of available options and callbacks, refer to the TypeScript definitions.

## Contributing

See the [contributing guide](CONTRIBUTING.md).

## License

MIT 