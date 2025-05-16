import Foundation
import UIKit
import RevenueCat
import RevenueCatUI
import ObjectiveC

@objc public class ASBPurchasesUI: NSObject {
    @objc public func configure(apiKey: String) {
        RevenueCat.Purchases.configure(withAPIKey: apiKey)
    }
    
    @objc public func presentPaywall(offeringId: String, viewController: UIViewController, completion: @escaping (Bool, String?) -> Void) {
        Purchases.shared.getOfferings { offerings, error in
            if let error = error {
                print("Error fetching offerings: \(error.localizedDescription)")
                completion(false, nil)
                return
            }
            
            guard let offering = offerings?.offering(identifier: offeringId) else {
                print("No offering found with identifier: \(offeringId)")
                completion(false, nil)
                return
            }
            
            DispatchQueue.main.async {
                let paywallVC = PaywallViewController(offering: offering)
                let delegateHandler = PaywallDelegateHandler(completion: completion)
                paywallVC.delegate = delegateHandler
                // Store the delegate handler to prevent it from being deallocated
                objc_setAssociatedObject(paywallVC, UnsafeRawPointer(bitPattern: 1)!, delegateHandler, .OBJC_ASSOCIATION_RETAIN)
                paywallVC.displayCloseButton = true
                viewController.present(paywallVC, animated: true)
            }
        }
    }
}

// Helper delegate handler to manage PaywallViewController delegate methods
private class PaywallDelegateHandler: NSObject, PaywallViewControllerDelegate {
    private let completion: (Bool, String?) -> Void
    
    init(completion: @escaping (Bool, String?) -> Void) {
        self.completion = completion
        super.init()
    }
    
    func paywallViewController(_ controller: PaywallViewController, didFinishPurchasingWith customerInfo: CustomerInfo, transaction: StoreTransaction?) {
        completion(true, transaction?.productIdentifier)
        controller.dismiss(animated: true)
    }
    
    func paywallViewControllerDidCancel(_ controller: PaywallViewController) {
        completion(false, nil)
    }
    
    func paywallViewController(_ controller: PaywallViewController, didFailWith error: NSError) {
        completion(false, nil)
    }
}
