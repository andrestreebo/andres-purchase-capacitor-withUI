import Foundation
import UIKit
import RevenueCat
import RevenueCatUI
import ObjectiveC

@objc public class ASBPurchasesUI: NSObject {
    @objc public func configure(apiKey: String) {
        RevenueCat.Purchases.configure(withAPIKey: apiKey)
    }
    
    @available(iOS 15.0, *)
    @objc public func presentPaywall(offeringId: String?, placementId: String?, displayCloseButton: Bool, fontName: String?, viewController: UIViewController, completion: @escaping (Bool, String?, Bool) -> Void) {
        func displayPaywall(offering: Offering) {
            DispatchQueue.main.async {
                let paywallVC = PaywallViewController(offering: offering)
                let delegateHandler = PaywallDelegateHandler(completion: completion)
                paywallVC.delegate = delegateHandler
                // Store the delegate handler to prevent it from being deallocated
                objc_setAssociatedObject(paywallVC, UnsafeRawPointer(bitPattern: 1)!, delegateHandler, .OBJC_ASSOCIATION_RETAIN)
                
                // Set close button
                paywallVC.shouldShowDismissButton = displayCloseButton
                
                // Set custom font if provided
                if let fontName = fontName {
                    paywallVC.fontProvider = CustomPaywallFontProvider(fontName: fontName)
                }
                
                viewController.present(paywallVC, animated: true)
            }
        }
        
        if let placementId = placementId {
            // Use getOfferings and find the appropriate offering
            Purchases.shared.getOfferings { offerings, error in
                if let error = error {
                    print("Error fetching offerings: \(error.localizedDescription)")
                    completion(false, nil, false)
                    return
                }
                
                if let offerings = offerings {
                    // Try to get offering by ID first
                    if let offering = offerings.offering(identifier: placementId) {
                        displayPaywall(offering: offering)
                    } else if let current = offerings.current {
                        // Fallback to current offering
                        displayPaywall(offering: current)
                    } else {
                        print("No offering found for placement: \(placementId)")
                        completion(false, nil, false)
                    }
                } else {
                    print("No offerings available")
                    completion(false, nil, false)
                }
            }
        } else if let offeringId = offeringId {
            Purchases.shared.getOfferings { offerings, error in
                if let error = error {
                    print("Error fetching offerings: \(error.localizedDescription)")
                    completion(false, nil, false)
                    return
                }
                
                guard let offering = offerings?.offering(identifier: offeringId) else {
                    print("No offering found with identifier: \(offeringId)")
                    completion(false, nil, false)
                    return
                }
                
                displayPaywall(offering: offering)
            }
        } else {
            Purchases.shared.getOfferings { offerings, error in
                if let error = error {
                    print("Error fetching offerings: \(error.localizedDescription)")
                    completion(false, nil, false)
                    return
                }
                
                guard let offering = offerings?.current else {
                    print("No current offering found")
                    completion(false, nil, false)
                    return
                }
                
                displayPaywall(offering: offering)
            }
        }
    }
    
    @available(iOS 15.0, *)
    @objc public func presentPaywallIfNeeded(offeringId: String?, placementId: String?, requiredEntitlementId: String, displayCloseButton: Bool, fontName: String?, viewController: UIViewController, completion: @escaping (Bool, String?, Bool) -> Void) {
        Purchases.shared.getCustomerInfo { [weak self] customerInfo, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching customer info: \(error.localizedDescription)")
                completion(false, nil, false)
                return
            }
            
            // Check if user already has the required entitlement
            if customerInfo.entitlements[requiredEntitlementId]?.isActive == true {
                // User already has the required entitlement, return without showing paywall
                completion(false, nil, true)
                return
            }
            
            // User doesn't have the required entitlement, show paywall
            self.presentPaywall(
                offeringId: offeringId,
                placementId: placementId,
                displayCloseButton: displayCloseButton,
                fontName: fontName,
                viewController: viewController,
                completion: completion
            )
        }
    }
    
    @available(iOS 15.0, *)
    @objc public func presentCustomerCenter(displayCloseButton: Bool, fontName: String?, viewController: UIViewController, completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            let customerCenterVC = CustomerCenterViewController()
            
            // Set custom font if provided
            if let fontName = fontName {
                customerCenterVC.fontProvider = CustomPaywallFontProvider(fontName: fontName)
            }
            
            // Set close button visibility
            customerCenterVC.shouldShowDismissButton = displayCloseButton
            
            // Create a custom delegate to handle dismiss
            class CustomDismissHandler: NSObject, CustomerCenterViewControllerDelegate {
                private let dismissCallback: () -> Void
                
                init(dismissCallback: @escaping () -> Void) {
                    self.dismissCallback = dismissCallback
                    super.init()
                }
                
                func customerCenterViewControllerDidDismiss(_ customerCenterViewController: CustomerCenterViewController) {
                    dismissCallback()
                }
            }
            
            let dismissHandler = CustomDismissHandler {
                completion()
            }
            objc_setAssociatedObject(customerCenterVC, UnsafeRawPointer(bitPattern: 2)!, dismissHandler, .OBJC_ASSOCIATION_RETAIN)
            customerCenterVC.delegate = dismissHandler
            
            viewController.present(customerCenterVC, animated: true)
        }
    }
}

// Helper delegate handler to manage PaywallViewController delegate methods
@available(iOS 15.0, *)
private class PaywallDelegateHandler: NSObject, PaywallViewControllerDelegate {
    private let completion: (Bool, String?, Bool) -> Void
    
    init(completion: @escaping (Bool, String?, Bool) -> Void) {
        self.completion = completion
        super.init()
    }
    
    func paywallViewController(_ controller: PaywallViewController, didFinishPurchasingWith customerInfo: CustomerInfo, transaction: StoreTransaction?) {
        completion(true, transaction?.productIdentifier, false)
        controller.dismiss(animated: true)
    }
    
    func paywallViewControllerDidCancel(_ controller: PaywallViewController) {
        completion(false, nil, false)
    }
    
    func paywallViewController(_ controller: PaywallViewController, didFailWith error: NSError) {
        completion(false, nil, false)
    }
    
    func paywallViewController(_ controller: PaywallViewController, didFinishRestoringWith customerInfo: CustomerInfo) {
        completion(false, nil, true)
        controller.dismiss(animated: true)
    }
}
