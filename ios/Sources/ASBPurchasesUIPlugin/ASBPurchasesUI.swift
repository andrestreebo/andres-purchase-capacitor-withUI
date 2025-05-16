import Foundation
import RevenueCat
import RevenueCatUI

@objc public class ASBPurchasesUI: NSObject {
    @objc public func configure(apiKey: String) {
        Purchases.configure(withAPIKey: apiKey)
    }
    
    @objc public func presentPaywall(offeringId: String, viewController: UIViewController, completion: @escaping (PaywallResult) -> Void) {
        PaywallViewController.presentPaywall(
            forOfferingID: offeringId,
            on: viewController, 
            animated: true,
            completion: completion
        )
    }
}
