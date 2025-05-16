package com.asb.plugin.purchases_ui_capacitor;

import android.app.Activity;
import android.content.Intent;
import android.util.Log;
import com.revenuecat.purchases.Purchases;
import com.revenuecat.purchases.ui.revenuecatui.activity.PaywallActivity;

public class ASBPurchasesUI {

    public void configure(Activity activity, String apiKey) {
        Purchases.configure(activity, apiKey);
    }
    
    public Intent getPaywallIntent(Activity activity, String offeringId) {
        return PaywallActivity.intentForPaywall(activity, offeringId);
    }
}
