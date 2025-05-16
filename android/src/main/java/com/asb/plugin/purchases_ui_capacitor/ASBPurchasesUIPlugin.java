package com.asb.plugin.purchases_ui_capacitor;

import android.app.Activity;
import android.content.Intent;
import com.getcapacitor.*;
import com.getcapacitor.annotation.CapacitorPlugin;
import com.getcapacitor.annotation.ActivityCallback;
import com.revenuecat.purchases.Purchases;
import com.revenuecat.purchases.ui.revenuecatui.activity.PaywallActivity;
import com.revenuecat.purchases.ui.revenuecatui.activity.PaywallResult;
import org.json.JSONObject;

@CapacitorPlugin(
    name = "ASBPurchasesUI",
    requestCodes = {ASBPurchasesUIPlugin.PAYWALL_REQ}
)
public class ASBPurchasesUIPlugin extends Plugin {
    
    static final int PAYWALL_REQ = 7117;
    private ASBPurchasesUI implementation = new ASBPurchasesUI();

    @PluginMethod
    public void configure(PluginCall call) {
        String apiKey = call.getString("apiKey");
        if (apiKey == null) {
            call.reject("apiKey missing");
            return;
        }
        
        Activity activity = getActivity();
        if (activity == null) {
            call.reject("Activity not available");
            return;
        }
        
        implementation.configure(activity, apiKey);
        call.resolve();
    }

    @PluginMethod
    public void presentPaywall(PluginCall call) {
        String offeringId = call.getString("offeringId");
        if (offeringId == null) {
            call.reject("offeringId missing");
            return;
        }
        
        // Save the call to handle the result
        saveCall(call);
        
        // Get the activity
        Activity activity = getActivity();
        if (activity == null) {
            call.reject("Activity not available");
            return;
        }
        
        // Start the paywall activity
        Intent intent = implementation.getPaywallIntent(activity, offeringId);
        startActivityForResult(call, intent, PAYWALL_REQ);
    }

    @ActivityCallback
    private void handlePaywallResult(PluginCall call, int resultCode, Intent data) {
        if (call == null) return;
        
        if (resultCode == Activity.RESULT_OK && data != null) {
            PaywallResult result = data.getParcelableExtra("paywallResult");
            JSObject ret = new JSObject();
            
            if (result != null) {
                switch (result.getPurchaseStatus()) {
                    case PURCHASED:
                        ret.put("status", "purchased");
                        ret.put("transactionId", result.getStoreTransaction() != null ? 
                                result.getStoreTransaction().getOrderId() : "");
                        break;
                    case CANCELLED:
                        ret.put("status", "cancelled");
                        break;
                    default:
                        ret.put("status", "error");
                        ret.put("code", "unknown");
                        ret.put("message", "Unknown purchase status");
                }
            } else {
                ret.put("status", "error");
                ret.put("code", "no_result");
                ret.put("message", "No paywall result received");
            }
            
            call.resolve(ret);
        } else {
            JSObject ret = new JSObject();
            ret.put("status", "cancelled");
            call.resolve(ret);
        }
    }
}
