import Foundation
import UIKit
import Capacitor
import RevenueCat
import RevenueCatUI

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(ASBPurchasesUIPlugin)
public class ASBPurchasesUIPlugin: CAPPlugin {
    private let implementation = ASBPurchasesUI()
    
    @objc func configure(_ call: CAPPluginCall) {
        guard let apiKey = call.getString("apiKey") else {
            call.reject("apiKey missing"); return
        }
        implementation.configure(apiKey: apiKey)
        call.resolve()
    }

    @objc func presentPaywall(_ call: CAPPluginCall) {
        guard let root = bridge?.viewController else {
            call.reject("No view controller available"); return
        }
        
        let offeringId = call.getString("offeringId")
        let placementId = call.getString("placementId")
        let displayCloseButton = call.getBool("displayCloseButton", true)
        let fontFamily = call.getString("fontFamily")
        
        // Check if at least one of offeringId or placementId is provided
        if offeringId == nil && placementId == nil {
            // If none provided, will use current offering
            print("No offeringId or placementId provided, using current offering")
        }

        implementation.presentPaywall(
            offeringId: offeringId,
            placementId: placementId,
            displayCloseButton: displayCloseButton,
            fontName: fontFamily,
            viewController: root
        ) { success, productId, restored in
            if success {
                call.resolve([
                    "status": "purchased",
                    "transactionId": productId ?? ""
                ])
            } else if restored {
                call.resolve([
                    "status": "restored",
                    "transactionId": productId
                ])
            } else {
                call.resolve([
                    "status": "cancelled"
                ])
            }
        }
    }
    
    @objc func presentPaywallIfNeeded(_ call: CAPPluginCall) {
        guard let root = bridge?.viewController else {
            call.reject("No view controller available"); return
        }
        
        guard let requiredEntitlementId = call.getString("requiredEntitlementId") else {
            call.reject("requiredEntitlementId missing"); return
        }
        
        let offeringId = call.getString("offeringId")
        let placementId = call.getString("placementId")
        let displayCloseButton = call.getBool("displayCloseButton", true)
        let fontFamily = call.getString("fontFamily")
        
        implementation.presentPaywallIfNeeded(
            offeringId: offeringId,
            placementId: placementId,
            requiredEntitlementId: requiredEntitlementId,
            displayCloseButton: displayCloseButton,
            fontName: fontFamily,
            viewController: root
        ) { success, productId, restored in
            if success {
                call.resolve([
                    "status": "purchased",
                    "transactionId": productId ?? ""
                ])
            } else if restored {
                call.resolve([
                    "status": "restored",
                    "transactionId": productId
                ])
            } else {
                call.resolve([
                    "status": "cancelled"
                ])
            }
        }
    }
    
    @objc func presentCustomerCenter(_ call: CAPPluginCall) {
        guard let root = bridge?.viewController else {
            call.reject("No view controller available"); return
        }
        
        if #available(iOS 15.0, *) {
            let displayCloseButton = call.getBool("displayCloseButton", true)
            let fontFamily = call.getString("fontFamily")
            
            implementation.presentCustomerCenter(
                displayCloseButton: displayCloseButton,
                fontName: fontFamily,
                viewController: root
            ) {
                call.resolve()
            }
        } else {
            call.reject("CustomerCenterViewController is only available on iOS 15.0+")
        }
    }
}
