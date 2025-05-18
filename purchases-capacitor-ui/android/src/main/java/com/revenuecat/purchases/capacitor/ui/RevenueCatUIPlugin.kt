package com.revenuecat.purchases.capacitor.ui

import android.graphics.Color
import com.getcapacitor.JSObject
import com.getcapacitor.Plugin
import com.getcapacitor.PluginCall
import com.getcapacitor.PluginMethod
import com.getcapacitor.annotation.CapacitorPlugin
import org.json.JSONObject
import com.revenuecat.purchases.ui.paywall.PaywallActivityLauncher
import com.revenuecat.purchases.ui.paywall.PaywallColor
import com.revenuecat.purchases.ui.paywall.PaywallDialog
import com.revenuecat.purchases.ui.paywall.PaywallFooterColor
import com.revenuecat.purchases.ui.paywall.PaywallFooterView
import com.revenuecat.purchases.ui.paywall.PaywallOptions
import com.revenuecat.purchases.ui.paywall.PaywallOverrides
import com.revenuecat.purchases.ui.paywall.PaywallText
import com.revenuecat.purchases.ui.revenuecatui.CustomerCenter
import com.revenuecat.purchases.ui.revenuecatui.CustomerCenterLauncher

@CapacitorPlugin(name = "RevenueCatUI")
class RevenueCatUIPlugin : Plugin() {

    @PluginMethod
    fun presentPaywall(call: PluginCall) {
        val args = parsePaywallArgs(call)
        
        activity?.let { activity ->
            PaywallActivityLauncher.launch(
                activity = activity,
                offeringIdentifier = args.offeringIdentifier,
                requiredEntitlementIdentifier = args.requiredEntitlementIdentifier,
                overrides = args.overrides,
                listener = CapacitorPaywallListener(call)
            )
        } ?: run {
            call.reject("Activity not available")
        }
    }

    @PluginMethod
    fun presentPaywallIfNeeded(call: PluginCall) {
        val args = parsePaywallArgs(call)
        val requiredEntitlementIdentifier = args.requiredEntitlementIdentifier
        
        if (requiredEntitlementIdentifier == null) {
            call.reject("requiredEntitlementIdentifier is required for presentPaywallIfNeeded")
            return
        }
        
        activity?.let { activity ->
            PaywallActivityLauncher.launchIfNeeded(
                activity = activity,
                requiredEntitlementIdentifier = requiredEntitlementIdentifier,
                offeringIdentifier = args.offeringIdentifier,
                overrides = args.overrides,
                listener = CapacitorPaywallListener(call)
            )
        } ?: run {
            call.reject("Activity not available")
        }
    }

    @PluginMethod
    fun presentCustomerCenter(call: PluginCall) {
        activity?.let { activity ->
            CustomerCenterLauncher.launch(
                activity,
                listener = CapacitorCustomerCenterListener(call)
            )
        } ?: run {
            call.reject("Activity not available")
        }
    }

    @PluginMethod
    fun setPaywallOverrides(call: PluginCall) {
        val overridesObject = call.getObject("overrides") ?: run {
            call.reject("Missing overrides parameter")
            return
        }
        
        val overrides = parseOverrides(overridesObject)
        PaywallOverrides.setDefaultOverrides(overrides)
        call.resolve()
    }

    // MARK: - Helper Methods

    private fun parsePaywallArgs(call: PluginCall): PaywallArgs {
        val offeringIdentifier = call.getString("offeringIdentifier")
        val requiredEntitlementIdentifier = call.getString("requiredEntitlementIdentifier")
        
        var overrides: PaywallOverrides? = null
        call.getObject("overrides")?.let {
            overrides = parseOverrides(it)
        }
        
        return PaywallArgs(offeringIdentifier, requiredEntitlementIdentifier, overrides)
    }

    private fun parseOverrides(overridesObject: JSObject): PaywallOverrides {
        val overrides = PaywallOverrides()
        
        // Font options
        overridesObject.getString("fontFamily")?.let {
            overrides.fontFamily = it
        }
        
        // Colors
        overridesObject.getString("backgroundColor")?.let {
            overrides.paywallColors = overrides.paywallColors.copy(
                background = parseColor(it)
            )
        }
        
        overridesObject.getString("primaryTextColor")?.let {
            overrides.paywallColors = overrides.paywallColors.copy(
                primaryText = parseColor(it)
            )
        }
        
        overridesObject.getString("secondaryTextColor")?.let {
            overrides.paywallColors = overrides.paywallColors.copy(
                secondaryText = parseColor(it)
            )
        }
        
        overridesObject.getString("accentColor")?.let {
            overrides.paywallColors = overrides.paywallColors.copy(
                accent = parseColor(it)
            )
        }
        
        // Button options
        overridesObject.getString("primaryButtonBackgroundColor")?.let {
            overrides.paywallFooterColors = overrides.paywallFooterColors.copy(
                primaryButtonBackground = parseColor(it)
            )
        }
        
        overridesObject.getString("primaryButtonTextColor")?.let {
            overrides.paywallFooterColors = overrides.paywallFooterColors.copy(
                primaryButtonText = parseColor(it)
            )
        }
        
        overridesObject.getString("secondaryButtonBackgroundColor")?.let {
            overrides.paywallFooterColors = overrides.paywallFooterColors.copy(
                secondaryButtonBackground = parseColor(it)
            )
        }
        
        overridesObject.getString("secondaryButtonTextColor")?.let {
            overrides.paywallFooterColors = overrides.paywallFooterColors.copy(
                secondaryButtonText = parseColor(it)
            )
        }
        
        // Text overrides
        overridesObject.getString("title")?.let {
            overrides.paywallText = overrides.paywallText.copy(
                title = it
            )
        }
        
        overridesObject.getString("subtitle")?.let {
            overrides.paywallText = overrides.paywallText.copy(
                subtitle = it
            )
        }
        
        overridesObject.getString("callToAction")?.let {
            overrides.paywallText = overrides.paywallText.copy(
                callToAction = it
            )
        }
        
        overridesObject.getString("restoreButtonText")?.let {
            overrides.paywallText = overrides.paywallText.copy(
                restorePurchasesButtonText = it
            )
        }
        
        // Display options
        overridesObject.getBoolean("displayCloseButton")?.let {
            overrides.displayCloseButton = it
        }
        
        return overrides
    }

    private fun parseColor(colorString: String): PaywallColor {
        return try {
            val color = Color.parseColor(colorString)
            PaywallColor(color)
        } catch (e: Exception) {
            PaywallColor(Color.BLACK) // Default to black if invalid
        }
    }
}

// Helper class for passing Paywall arguments
private data class PaywallArgs(
    val offeringIdentifier: String?,
    val requiredEntitlementIdentifier: String?,
    val overrides: PaywallOverrides?
)

// Capacitor-specific Paywall listener implementation
private class CapacitorPaywallListener(private val call: PluginCall) : PaywallActivityLauncher.Listener {
    override fun onPaywallPresented() {
        // No need to notify for presentation
    }

    override fun onPaywallDismissed() {
        // No need to notify for dismissal
    }

    override fun onPurchaseStarted() {
        // No need to notify for purchase started
    }

    override fun onPurchaseCompleted(customerInfo: Any, storeTransaction: Any?) {
        val result = JSObject().apply {
            put("status", "purchased")
            if (storeTransaction != null) {
                put("transactionId", storeTransaction.toString())
            }
        }
        call.resolve(result)
    }

    override fun onPurchaseError(error: Throwable) {
        val result = JSObject().apply {
            put("status", "error")
            put("error", JSObject().apply {
                put("code", "purchase_error")
                put("message", error.message ?: "Unknown error")
            })
        }
        call.resolve(result)
    }

    override fun onRestoreStarted() {
        // No need to notify for restore started
    }

    override fun onRestoreCompleted(customerInfo: Any) {
        val result = JSObject().apply {
            put("status", "restored")
        }
        call.resolve(result)
    }

    override fun onRestoreError(error: Throwable) {
        val result = JSObject().apply {
            put("status", "error")
            put("error", JSObject().apply {
                put("code", "restore_error")
                put("message", error.message ?: "Unknown error")
            })
        }
        call.resolve(result)
    }

    override fun onPaywallError(error: Throwable) {
        val result = JSObject().apply {
            put("status", "error")
            put("error", JSObject().apply {
                put("code", "paywall_error")
                put("message", error.message ?: "Unknown error")
            })
        }
        call.resolve(result)
    }

    // Called when user cancels the paywall
    override fun onPaywallCancelled() {
        val result = JSObject().apply {
            put("status", "cancelled")
        }
        call.resolve(result)
    }
}

// Capacitor-specific Customer Center listener implementation
private class CapacitorCustomerCenterListener(private val call: PluginCall) : CustomerCenter.Listener {
    override fun onDismiss() {
        call.resolve()
    }

    override fun onError(error: Throwable) {
        call.reject(error.message ?: "Unknown error")
    }
} 