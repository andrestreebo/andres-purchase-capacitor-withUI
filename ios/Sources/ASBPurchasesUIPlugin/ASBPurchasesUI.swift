import Foundation
import UIKit
import RevenueCat
import RevenueCatUI

@objc public class ASBPurchasesUI: NSObject {
    @objc public func configure(apiKey: String) {
        RevenueCat.Purchases.configure(withAPIKey: apiKey)
    }
    
    @objc public func presentPaywall(offeringId: String, viewController: UIViewController, completion: @escaping (RevenueCatUI.PaywallResult) -> Void) {
        RevenueCatUI.PaywallViewController.presentPaywall(
            forOfferingID: offeringId,
            on: viewController, 
            animated: true,
            completion: completion
        )
    }
}
