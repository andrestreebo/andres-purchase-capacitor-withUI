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
        
        if (placementId != null) {
            intent = PaywallActivity.intentForPaywall(activity, placementId);
        } else if (offeringId != null) {
            intent = PaywallActivity.intentForPaywall(activity, offeringId);
        } else {
            intent = PaywallActivity.intentForPaywall(activity);
        }
        
        intent.putExtra(PaywallActivity.SHOULD_DISPLAY_DISMISS_BUTTON, displayCloseButton);
        
        if (fontFamily != null) {
            PaywallFontFamily paywallFontFamily = new PaywallFontFamily(
                Collections.singletonList(PaywallFont.ResourceFont.Companion.createFromFontFamily(fontFamily))
            );
            CustomParcelizableFontProvider fontProvider = new CustomParcelizableFontProvider(paywallFontFamily);
            intent.putExtra(PaywallActivity.FONT_PROVIDER_KEY, fontProvider);
        }
        
        return intent;
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
        Intent intent = CustomerCenterActivity.createIntent(activity);
        
        intent.putExtra(CustomerCenterActivity.SHOULD_DISPLAY_DISMISS_BUTTON, displayCloseButton);
        
        if (fontFamily != null) {
            PaywallFontFamily paywallFontFamily = new PaywallFontFamily(
                Collections.singletonList(PaywallFont.ResourceFont.Companion.createFromFontFamily(fontFamily))
            );
            CustomParcelizableFontProvider fontProvider = new CustomParcelizableFontProvider(paywallFontFamily);
            intent.putExtra(CustomerCenterActivity.FONT_PROVIDER_KEY, fontProvider);
        }
        
        return intent;
    }
    
    public interface EntitlementCheckCallback {
        void onEntitlementCheck(boolean hasEntitlement, @Nullable Intent intent);
    }
}
