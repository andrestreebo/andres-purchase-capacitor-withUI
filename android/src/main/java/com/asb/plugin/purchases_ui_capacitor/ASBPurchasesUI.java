package com.asb.plugin.purchases_ui_capacitor;

import android.app.Activity;
import android.content.Intent;
import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.revenuecat.purchases.CustomerInfo;
import com.revenuecat.purchases.Purchases;
import com.revenuecat.purchases.PurchasesError;
import com.revenuecat.purchases.interfaces.ReceiveCustomerInfoCallback;
import com.revenuecat.purchases.ui.revenuecatui.ExperimentalPreviewRevenueCatUIPurchasesAPI;
import com.revenuecat.purchases.ui.revenuecatui.activity.CustomerCenterActivity;
import com.revenuecat.purchases.ui.revenuecatui.activity.PaywallActivity;
import com.revenuecat.purchases.ui.revenuecatui.fonts.CustomParcelizableFontProvider;
import com.revenuecat.purchases.ui.revenuecatui.fonts.PaywallFontFamily;
import com.revenuecat.purchases.ui.revenuecatui.fonts.PaywallFont;

import java.util.Collections;

public class ASBPurchasesUI {

    public void configure(Activity activity, String apiKey) {
        Purchases.configure(activity, apiKey);
    }
    
    @ExperimentalPreviewRevenueCatUIPurchasesAPI
    public Intent getPaywallIntent(Activity activity, @Nullable String offeringId, @Nullable String placementId, boolean displayCloseButton, @Nullable String fontFamily) {
        Intent intent;
        
        try {
            if (placementId != null) {
                // Try to use placement ID if available in API
                try {
                    intent = PaywallActivity.intentForPaywall(activity, placementId);
                } catch (Exception e) {
                    Log.w("ASBPurchasesUI", "Placement ID not supported, falling back to offering ID or default: " + e.getMessage());
                    if (offeringId != null) {
                        intent = PaywallActivity.intentForPaywall(activity, offeringId);
                    } else {
                        intent = PaywallActivity.intentForPaywall(activity);
                    }
                }
            } else if (offeringId != null) {
                intent = PaywallActivity.intentForPaywall(activity, offeringId);
            } else {
                intent = PaywallActivity.intentForPaywall(activity);
            }
            
            // Try to set the dismiss button property
            try {
                // Check for the correct property name
                // First try SHOULD_DISPLAY_DISMISS_BUTTON (newer versions)
                intent.putExtra(PaywallActivity.SHOULD_DISPLAY_DISMISS_BUTTON, displayCloseButton);
            } catch (Exception e) {
                // If that fails, try alternative property names
                Log.w("ASBPurchasesUI", "SHOULD_DISPLAY_DISMISS_BUTTON not found, trying alternatives: " + e.getMessage());
                try {
                    intent.putExtra("shouldShowDismissButton", displayCloseButton);
                } catch (Exception e2) {
                    Log.w("ASBPurchasesUI", "Alternative property not found either: " + e2.getMessage());
                }
            }
            
            if (fontFamily != null) {
                try {
                    PaywallFontFamily paywallFontFamily = new PaywallFontFamily(
                        Collections.singletonList(PaywallFont.ResourceFont.Companion.createFromFontFamily(fontFamily))
                    );
                    CustomParcelizableFontProvider fontProvider = new CustomParcelizableFontProvider(paywallFontFamily);
                    intent.putExtra(PaywallActivity.FONT_PROVIDER_KEY, fontProvider);
                } catch (Exception e) {
                    Log.w("ASBPurchasesUI", "Could not set font family: " + e.getMessage());
                }
            }
            
            return intent;
        } catch (Exception e) {
            Log.e("ASBPurchasesUI", "Error creating paywall intent: " + e.getMessage());
            // Return a simple intent as fallback
            return new Intent(activity, PaywallActivity.class);
        }
    }
    
    @ExperimentalPreviewRevenueCatUIPurchasesAPI
    public void checkEntitlementAndGetPaywallIntent(Activity activity, @Nullable String offeringId, @Nullable String placementId, @NonNull String requiredEntitlementId, boolean displayCloseButton, @Nullable String fontFamily, EntitlementCheckCallback callback) {
        Purchases.getSharedInstance().getCustomerInfo(new ReceiveCustomerInfoCallback() {
            @Override
            public void onReceived(@NonNull CustomerInfo customerInfo) {
                if (customerInfo.getEntitlements().get(requiredEntitlementId) != null && 
                    customerInfo.getEntitlements().get(requiredEntitlementId).isActive()) {
                    // User already has entitlement
                    callback.onEntitlementCheck(true, null);
                } else {
                    // User needs to purchase, show paywall
                    Intent intent = getPaywallIntent(activity, offeringId, placementId, displayCloseButton, fontFamily);
                    callback.onEntitlementCheck(false, intent);
                }
            }

            @Override
            public void onError(@NonNull PurchasesError error) {
                Log.e("ASBPurchasesUI", "Error checking entitlement: " + error.getMessage());
                Intent intent = getPaywallIntent(activity, offeringId, placementId, displayCloseButton, fontFamily);
                callback.onEntitlementCheck(false, intent);
            }
        });
    }
    
    @ExperimentalPreviewRevenueCatUIPurchasesAPI
    public Intent getCustomerCenterIntent(Activity activity, boolean displayCloseButton, @Nullable String fontFamily) {
        try {
            Intent intent = CustomerCenterActivity.createIntent(activity);
            
            // Try to set the dismiss button property
            try {
                intent.putExtra(CustomerCenterActivity.SHOULD_DISPLAY_DISMISS_BUTTON, displayCloseButton);
            } catch (Exception e) {
                Log.w("ASBPurchasesUI", "SHOULD_DISPLAY_DISMISS_BUTTON not found for CustomerCenter: " + e.getMessage());
                try {
                    intent.putExtra("shouldShowDismissButton", displayCloseButton);
                } catch (Exception e2) {
                    Log.w("ASBPurchasesUI", "Alternative property not found either for CustomerCenter: " + e2.getMessage());
                }
            }
            
            if (fontFamily != null) {
                try {
                    PaywallFontFamily paywallFontFamily = new PaywallFontFamily(
                        Collections.singletonList(PaywallFont.ResourceFont.Companion.createFromFontFamily(fontFamily))
                    );
                    CustomParcelizableFontProvider fontProvider = new CustomParcelizableFontProvider(paywallFontFamily);
                    intent.putExtra(CustomerCenterActivity.FONT_PROVIDER_KEY, fontProvider);
                } catch (Exception e) {
                    Log.w("ASBPurchasesUI", "Could not set font family for CustomerCenter: " + e.getMessage());
                }
            }
            
            return intent;
        } catch (Exception e) {
            Log.e("ASBPurchasesUI", "Error creating CustomerCenter intent: " + e.getMessage());
            // Return a simple intent as fallback
            return new Intent(activity, CustomerCenterActivity.class);
        }
    }
    
    public interface EntitlementCheckCallback {
        void onEntitlementCheck(boolean hasEntitlement, @Nullable Intent intent);
    }
}
