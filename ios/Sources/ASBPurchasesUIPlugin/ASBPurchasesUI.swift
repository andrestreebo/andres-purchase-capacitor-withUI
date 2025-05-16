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
                
                // Set close button - check if the property exists
                if paywallVC.responds(to: #selector(setter: PaywallViewController.shouldShowDismissButton)) {
                    paywallVC.shouldShowDismissButton = displayCloseButton
                }
                
                // Set custom font if provided
                if let fontName = fontName {
                    if paywallVC.responds(to: #selector(setter: PaywallViewController.fonts)) {
                        paywallVC.fonts = CustomPaywallFontProvider(fontName: fontName)
                    }
                }
                
                viewController.present(paywallVC, animated: true)
            }
        }
        
        if let placementId = placementId {
            // Handle placement ID differently as the placement API might not exist in Offerings
            // Use getOfferings and then find the appropriate offering
            Purchases.shared.getOfferings { offerings, error in
                if let error = error {
                    print("Error fetching offerings: \(error.localizedDescription)")
                    completion(false, nil, false)
                    return
                }
                
                if let offerings = offerings {
                    // Since placement might not be directly accessible, find offering by ID
                    var foundOffering: Offering?
                    
                    // Try to access a placement if the API exists
                    if let offering = offerings.offering(identifier: placementId) {
                        foundOffering = offering
                    } else if let current = offerings.current {
                        // Fallback to current offering
                        foundOffering = current
                    }
                    
                    if let offering = foundOffering {
                        displayPaywall(offering: offering)
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
            // Check if CustomerCenterViewController is available
            if NSClassFromString("RevenueCatUI.CustomerCenterViewController") != nil {
                let customerCenterVC = CustomerCenterViewController()
                
                // Set custom font if provided and if the property exists
                if let fontName = fontName, customerCenterVC.responds(to: #selector(setter: CustomerCenterViewController.fonts)) {
                    customerCenterVC.fonts = CustomPaywallFontProvider(fontName: fontName)
                }
                
                // Set close button visibility if the property exists
                if customerCenterVC.responds(to: #selector(setter: CustomerCenterViewController.shouldShowDismissButton)) {
                    customerCenterVC.shouldShowDismissButton = displayCloseButton
                }
                
                // Create a custom delegate to handle dismiss
                class CustomDismissHandler: NSObject {
                    private let dismissCallback: () -> Void
                    
                    init(dismissCallback: @escaping () -> Void) {
                        self.dismissCallback = dismissCallback
                        super.init()
                    }
                    
                    @objc func customerCenterViewControllerDidDismiss(_ customerCenterViewController: UIViewController) {
                        dismissCallback()
                    }
                }
                
                let dismissHandler = CustomDismissHandler {
                    completion()
                }
                objc_setAssociatedObject(customerCenterVC, UnsafeRawPointer(bitPattern: 2)!, dismissHandler, .OBJC_ASSOCIATION_RETAIN)
                
                // Try to set the delegate if the property exists
                if customerCenterVC.responds(to: #selector(setter: CustomerCenterViewController.delegate)) {
                    let selectorName = "setDelegate:"
                    let selector = NSSelectorFromString(selectorName)
                    if customerCenterVC.responds(to: selector) {
                        customerCenterVC.perform(selector, with: dismissHandler)
                    }
                }
                
                viewController.present(customerCenterVC, animated: true)
            } else {
                print("CustomerCenterViewController is not available")
                completion()
            }
        }
    }
}

// Helper delegate handler to manage PaywallViewController delegate methods
@available(iOS 15.0, *)
private class PaywallDelegateHandler: NSObject {
    private let completion: (Bool, String?, Bool) -> Void
    
    init(completion: @escaping (Bool, String?, Bool) -> Void) {
        self.completion = completion
        super.init()
    }
    
    @objc func paywallViewController(_ controller: PaywallViewController, didFinishPurchasingWith customerInfo: CustomerInfo, transaction: StoreTransaction?) {
        completion(true, transaction?.productIdentifier, false)
        controller.dismiss(animated: true)
    }
    
    @objc func paywallViewControllerDidCancel(_ controller: PaywallViewController) {
        completion(false, nil, false)
    }
    
    @objc func paywallViewController(_ controller: PaywallViewController, didFailWith error: NSError) {
        completion(false, nil, false)
    }
    
    @objc func paywallViewController(_ controller: PaywallViewController, didFinishRestoringWith customerInfo: CustomerInfo) {
        completion(false, nil, true)
        controller.dismiss(animated: true)
    }
}
