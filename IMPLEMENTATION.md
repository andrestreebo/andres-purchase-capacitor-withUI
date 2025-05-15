# RevenueCat Purchases UI for Capacitor - Implementation Overview

This document provides an overview of the implementation of the RevenueCat Purchases UI SDK for Capacitor.

## Architecture

The plugin follows the standard Capacitor plugin architecture, with the following components:

1. **TypeScript Interface** (`src/definitions.ts`): Defines the plugin interface and data types.
2. **Web Fallback** (`src/web.ts`): Provides a fallback implementation for web platforms (non-native).
3. **Android Native** (`android/`): Java implementation that wraps the RevenueCat Purchases UI for Android.
4. **iOS Native** (`ios/`): Swift implementation that wraps the RevenueCat Purchases UI for iOS.
5. **Plugin Registration** (`src/index.ts`): Registers the plugin with Capacitor.

## Plugin Features

The plugin provides the following features:

1. **Present Paywall**: Display a full-screen or sheet-style paywall with the provided configuration.
2. **Present Footer Paywall**: Display a footer-style paywall with the provided configuration.
3. **Close Paywall**: Programmatically close any currently displayed paywall.
4. **Theming**: Customize the paywall appearance with fonts and colors.

## Native Implementation Details

### Android

The Android implementation uses the RevenueCat Purchases UI SDK for Android, which is included as a dependency in the `build.gradle` file. The implementation is in Java and uses the Android-specific UI components from the RevenueCat SDK.

Key classes:
- `PaywallDialog`: For full-screen and sheet paywalls
- `PaywallFooterDialog`: For footer paywalls
- `PaywallDialogOptions`: For configuring paywall appearance

### iOS

The iOS implementation uses the RevenueCat Purchases UI SDK for iOS, which is included as a dependency in the podspec file. The implementation is in Swift and uses the iOS-specific UI components from the RevenueCat SDK.

Key classes:
- `PaywallViewController`: For full-screen and sheet paywalls
- `PaywallFooterViewController`: For footer paywalls
- `PaywallOptions`: For configuring paywall appearance

## Building and Testing

To build the plugin:

1. Install dependencies: `npm install`
2. Build the TypeScript code: `npm run build`

To test the plugin in an Android or iOS project:

1. Link the plugin to your Capacitor project
2. Follow the README.md for usage instructions

## Dependencies

- `@capacitor/core`: Core Capacitor library
- `@revenuecat/purchases-capacitor`: Main RevenueCat SDK for Capacitor
- RevenueCat native SDKs:
  - Android: `com.revenuecat.purchases:purchases-ui`
  - iOS: `RevenueCatUI` 