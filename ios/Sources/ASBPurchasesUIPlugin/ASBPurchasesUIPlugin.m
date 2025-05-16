#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>

// Define the plugin using the CAP_PLUGIN macro and the name of your plugin
CAP_PLUGIN(ASBPurchasesUIPlugin, "ASBPurchasesUI",
           CAP_PLUGIN_METHOD(configure, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(presentPaywall, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(presentPaywallIfNeeded, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(presentCustomerCenter, CAPPluginReturnPromise);
) 