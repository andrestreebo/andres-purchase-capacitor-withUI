# asb-purchases-ui-capacitor

Vibe coding the Purchase UI plugin to use Revenuecat Paywalls and Customer Center

## Install

```bash
npm install asb-purchases-ui-capacitor
npx cap sync
```

## API

<docgen-index>

* [`configure(...)`](#configure)
* [`presentPaywall(...)`](#presentpaywall)
* [Interfaces](#interfaces)
* [Type Aliases](#type-aliases)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### configure(...)

```typescript
configure(opts: ConfigureOptions) => Promise<void>
```

| Param      | Type                                                          |
| ---------- | ------------------------------------------------------------- |
| **`opts`** | <code><a href="#configureoptions">ConfigureOptions</a></code> |

--------------------


### presentPaywall(...)

```typescript
presentPaywall(opts: PaywallOptions) => Promise<PaywallResult>
```

| Param      | Type                                                      |
| ---------- | --------------------------------------------------------- |
| **`opts`** | <code><a href="#paywalloptions">PaywallOptions</a></code> |

**Returns:** <code>Promise&lt;<a href="#paywallresult">PaywallResult</a>&gt;</code>

--------------------


### Interfaces


#### ConfigureOptions

| Prop         | Type                |
| ------------ | ------------------- |
| **`apiKey`** | <code>string</code> |


#### PaywallOptions

| Prop             | Type                |
| ---------------- | ------------------- |
| **`offeringId`** | <code>string</code> |


### Type Aliases


#### PaywallResult

<code>{ status: 'purchased'; transactionId: string } | { status: 'cancelled' } | { status: 'error'; code: string; message: string }</code>

</docgen-api>
