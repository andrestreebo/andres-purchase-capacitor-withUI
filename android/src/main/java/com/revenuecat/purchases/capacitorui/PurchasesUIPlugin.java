package com.revenuecat.purchases.capacitorui;

import android.graphics.Color;
import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;
import com.revenuecat.purchases.ui.revenuecatui.ExperimentalPreviewRevenueCatUIPurchasesAPI;
import com.revenuecat.purchases.ui.revenuecatui.PaywallDialog;
import com.revenuecat.purchases.ui.revenuecatui.PaywallDialogOptions;
import com.revenuecat.purchases.ui.revenuecatui.PaywallFooterDialog;
import com.revenuecat.purchases.ui.revenuecatui.PaywallFooterDialogOptions;
import com.revenuecat.purchases.ui.revenuecatui.PaywallResult;
import com.revenuecat.purchases.ui.revenuecatui.fonts.PaywallFont;
import com.revenuecat.purchases.ui.revenuecatui.fonts.PaywallFontFamily;

import kotlin.Unit;

@CapacitorPlugin(name = "PurchasesUI")
public class PurchasesUIPlugin extends Plugin {

    private PaywallDialog currentPaywall;
    private PaywallFooterDialog currentFooterPaywall;

    @PluginMethod
    public void presentPaywall(PluginCall call) {
        if (currentPaywall != null || currentFooterPaywall != null) {
            call.reject("A paywall is already being presented");
            return;
        }

        String offering = call.getString("offering");
        String displayMode = call.getString("displayMode", "fullScreen");
        String fontFamily = call.getString("fontFamily");
        JSObject colors = call.getObject("colors", new JSObject());

        PaywallDialogOptions.Builder optionsBuilder = new PaywallDialogOptions.Builder();
        
        if (offering != null && !offering.isEmpty()) {
            optionsBuilder.setOfferingIdentifier(offering);
        }

        if (fontFamily != null && !fontFamily.isEmpty()) {
            PaywallFontFamily customFontFamily = new PaywallFontFamily(
                PaywallFont.create(fontFamily), 
                PaywallFont.create(fontFamily)
            );
            optionsBuilder.setFontFamily(customFontFamily);
        }

        // Parse colors
        if (colors.has("accent")) {
            try {
                int accentColor = Color.parseColor(colors.getString("accent"));
                optionsBuilder.setAccentColor(accentColor);
            } catch (Exception e) {
                // Invalid color format, ignore
            }
        }

        // Determine if we should show as a sheet or full screen
        boolean isSheet = "sheet".equals(displayMode);
        PaywallDialogOptions options = optionsBuilder.build();

        getActivity().runOnUiThread(() -> {
            if (isSheet) {
                currentPaywall = PaywallDialog.createBottomSheet(getActivity(), options);
            } else {
                currentPaywall = PaywallDialog.create(getActivity(), options);
            }

            currentPaywall.show(getActivity().getSupportFragmentManager(), "Paywall");

            currentPaywall.setOnResultListener(result -> {
                handlePaywallResult(call, result);
                currentPaywall = null;
                return Unit.INSTANCE;
            });
        });
    }

    @PluginMethod
    public void presentFooterPaywall(PluginCall call) {
        if (currentPaywall != null || currentFooterPaywall != null) {
            call.reject("A paywall is already being presented");
            return;
        }

        String offering = call.getString("offering");
        String fontFamily = call.getString("fontFamily");
        JSObject colors = call.getObject("colors", new JSObject());

        PaywallFooterDialogOptions.Builder optionsBuilder = new PaywallFooterDialogOptions.Builder();
        
        if (offering != null && !offering.isEmpty()) {
            optionsBuilder.setOfferingIdentifier(offering);
        }

        if (fontFamily != null && !fontFamily.isEmpty()) {
            PaywallFontFamily customFontFamily = new PaywallFontFamily(
                PaywallFont.create(fontFamily), 
                PaywallFont.create(fontFamily)
            );
            optionsBuilder.setFontFamily(customFontFamily);
        }

        // Parse colors
        if (colors.has("accent")) {
            try {
                int accentColor = Color.parseColor(colors.getString("accent"));
                optionsBuilder.setAccentColor(accentColor);
            } catch (Exception e) {
                // Invalid color format, ignore
            }
        }

        PaywallFooterDialogOptions options = optionsBuilder.build();

        getActivity().runOnUiThread(() -> {
            currentFooterPaywall = PaywallFooterDialog.create(getActivity(), options);
            currentFooterPaywall.show(getActivity().getSupportFragmentManager(), "FooterPaywall");

            currentFooterPaywall.setOnResultListener(result -> {
                handlePaywallResult(call, result);
                currentFooterPaywall = null;
                return Unit.INSTANCE;
            });
        });
    }

    @PluginMethod
    public void closePaywall(PluginCall call) {
        getActivity().runOnUiThread(() -> {
            if (currentPaywall != null) {
                currentPaywall.dismiss();
                currentPaywall = null;
            }
            
            if (currentFooterPaywall != null) {
                currentFooterPaywall.dismiss();
                currentFooterPaywall = null;
            }
            
            call.resolve();
        });
    }

    private void handlePaywallResult(PluginCall call, PaywallResult result) {
        JSObject response = new JSObject();
        response.put("didPurchase", result.getPurchaseSuccessful());
        
        if (result.getPurchaseSuccessful() && result.getPackageType() != null) {
            response.put("productIdentifier", result.getPackageType().getProductId());
        }
        
        call.resolve(response);
    }
} 