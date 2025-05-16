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
        guard let offeringId = call.getString("offeringId"),
              let root = bridge?.viewController else {
            call.reject("offeringId missing or no view controller"); return
        }

        implementation.presentPaywall(
            offeringId: offeringId,
            viewController: root
        ) { success, productId in
            if success {
                call.resolve([
                    "status": "purchased",
                    "transactionId": productId ?? ""
                ])
            } else {
                call.resolve([
                    "status": "cancelled"
                ])
            }
        }
    }
}
