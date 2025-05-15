import Foundation
import Capacitor
import RevenueCat
import RevenueCatUI

@objc(PurchasesUIPlugin)
public class PurchasesUIPlugin: CAPPlugin {
    private var currentPaywallViewController: PaywallViewController?
    private var currentFooterPaywallViewController: PaywallFooterViewController?
    
    @objc func presentPaywall(_ call: CAPPluginCall) {
        if currentPaywallViewController != nil || currentFooterPaywallViewController != nil {
            call.reject("A paywall is already being presented")
            return
        }
        
        let offering = call.getString("offering")
        let displayMode = call.getString("displayMode", "fullScreen")
        let fontFamily = call.getString("fontFamily")
        let colors = call.getObject("colors") ?? [:]
        
        var options = PaywallOptions()
        
        // Configure the offering if provided
        if let offering = offering, !offering.isEmpty {
            options.offering = offering
        }
        
        // Configure font if provided
        if let fontFamily = fontFamily, !fontFamily.isEmpty {
            options.fontFamily = .custom(name: fontFamily)
        }
        
        // Configure colors if provided
        if let accentColorHex = colors["accent"] as? String {
            options.colors.accent = UIColor(hex: accentColorHex) ?? options.colors.accent
        }
        
        if let textColorHex = colors["text"] as? String {
            options.colors.text = UIColor(hex: textColorHex) ?? options.colors.text
        }
        
        if let backgroundColorHex = colors["background"] as? String {
            options.colors.background = UIColor(hex: backgroundColorHex) ?? options.colors.background
        }
        
        if let secondaryBackgroundColorHex = colors["secondaryBackground"] as? String {
            options.colors.secondaryBackground = UIColor(hex: secondaryBackgroundColorHex) ?? options.colors.secondaryBackground
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // Create the paywall view controller
            let isSheet = displayMode == "sheet"
            let paywallVC = PaywallViewController(options: options, displayCloseButton: true)
            self.currentPaywallViewController = paywallVC
            
            // Set up the delegate
            paywallVC.delegate = self
            
            // Store the call for later use in the delegate
            self.bridge?.saveCall(call)
            
            if isSheet {
                // Present as a sheet
                if let rootVC = self.bridge?.viewController {
                    if #available(iOS 15.0, *) {
                        if let sheet = paywallVC.sheetPresentationController {
                            sheet.detents = [.medium(), .large()]
                            sheet.preferredCornerRadius = 32.0
                        }
                    }
                    rootVC.present(paywallVC, animated: true)
                } else {
                    call.reject("Unable to present paywall: no root view controller")
                    self.currentPaywallViewController = nil
                }
            } else {
                // Present full screen
                if let rootVC = self.bridge?.viewController {
                    rootVC.present(paywallVC, animated: true)
                } else {
                    call.reject("Unable to present paywall: no root view controller")
                    self.currentPaywallViewController = nil
                }
            }
        }
    }
    
    @objc func presentFooterPaywall(_ call: CAPPluginCall) {
        if currentPaywallViewController != nil || currentFooterPaywallViewController != nil {
            call.reject("A paywall is already being presented")
            return
        }
        
        let offering = call.getString("offering")
        let fontFamily = call.getString("fontFamily")
        let colors = call.getObject("colors") ?? [:]
        
        var options = PaywallOptions()
        
        // Configure the offering if provided
        if let offering = offering, !offering.isEmpty {
            options.offering = offering
        }
        
        // Configure font if provided
        if let fontFamily = fontFamily, !fontFamily.isEmpty {
            options.fontFamily = .custom(name: fontFamily)
        }
        
        // Configure colors if provided
        if let accentColorHex = colors["accent"] as? String {
            options.colors.accent = UIColor(hex: accentColorHex) ?? options.colors.accent
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // Create the footer paywall view controller
            let footerVC = PaywallFooterViewController(options: options)
            self.currentFooterPaywallViewController = footerVC
            
            // Set up the delegate
            footerVC.delegate = self
            
            // Store the call for later use in the delegate
            self.bridge?.saveCall(call)
            
            // Present the footer
            if let rootVC = self.bridge?.viewController {
                rootVC.present(footerVC, animated: true)
            } else {
                call.reject("Unable to present footer paywall: no root view controller")
                self.currentFooterPaywallViewController = nil
            }
        }
    }
    
    @objc func closePaywall(_ call: CAPPluginCall) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if let paywallVC = self.currentPaywallViewController {
                paywallVC.dismiss(animated: true) {
                    self.currentPaywallViewController = nil
                    call.resolve()
                }
            } else if let footerVC = self.currentFooterPaywallViewController {
                footerVC.dismiss(animated: true) {
                    self.currentFooterPaywallViewController = nil
                    call.resolve()
                }
            } else {
                call.resolve()
            }
        }
    }
}

// MARK: - PaywallViewControllerDelegate
extension PurchasesUIPlugin: PaywallViewControllerDelegate {
    public func paywallViewController(_ controller: PaywallViewController, didFinishPurchasingWith customerInfo: CustomerInfo, transaction: StoreTransaction?) {
        let result: [String: Any] = [
            "didPurchase": true,
            "productIdentifier": transaction?.productIdentifier ?? ""
        ]
        
        if let call = bridge?.savedCall(withID: controller.callbackId) {
            call.resolve(result)
            bridge?.removeSavedCall(call)
        }
        
        currentPaywallViewController = nil
    }
    
    public func paywallViewController(_ controller: PaywallViewController, didFailPurchasingWith error: Error) {
        let result: [String: Any] = [
            "didPurchase": false,
            "error": error.localizedDescription
        ]
        
        if let call = bridge?.savedCall(withID: controller.callbackId) {
            call.resolve(result)
            bridge?.removeSavedCall(call)
        }
        
        currentPaywallViewController = nil
    }
    
    public func paywallViewControllerDidFinish(_ controller: PaywallViewController) {
        let result: [String: Any] = [
            "didPurchase": false,
            "userCancelled": true
        ]
        
        if let call = bridge?.savedCall(withID: controller.callbackId) {
            call.resolve(result)
            bridge?.removeSavedCall(call)
        }
        
        currentPaywallViewController = nil
    }
}

// MARK: - PaywallFooterViewControllerDelegate
extension PurchasesUIPlugin: PaywallFooterViewControllerDelegate {
    public func paywallFooterViewController(_ controller: PaywallFooterViewController, didFinishPurchasingWith customerInfo: CustomerInfo, transaction: StoreTransaction?) {
        let result: [String: Any] = [
            "didPurchase": true,
            "productIdentifier": transaction?.productIdentifier ?? ""
        ]
        
        if let call = bridge?.savedCall(withID: controller.callbackId) {
            call.resolve(result)
            bridge?.removeSavedCall(call)
        }
        
        currentFooterPaywallViewController = nil
    }
    
    public func paywallFooterViewController(_ controller: PaywallFooterViewController, didFailPurchasingWith error: Error) {
        let result: [String: Any] = [
            "didPurchase": false,
            "error": error.localizedDescription
        ]
        
        if let call = bridge?.savedCall(withID: controller.callbackId) {
            call.resolve(result)
            bridge?.removeSavedCall(call)
        }
        
        currentFooterPaywallViewController = nil
    }
    
    public func paywallFooterViewControllerDidFinish(_ controller: PaywallFooterViewController) {
        let result: [String: Any] = [
            "didPurchase": false,
            "userCancelled": true
        ]
        
        if let call = bridge?.savedCall(withID: controller.callbackId) {
            call.resolve(result)
            bridge?.removeSavedCall(call)
        }
        
        currentFooterPaywallViewController = nil
    }
}

// MARK: - UIColor Extension
extension UIColor {
    convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x0000ff) / 255
                    a = 1.0
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            } else if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
} 