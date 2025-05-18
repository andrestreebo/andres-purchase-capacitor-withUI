import Foundation
import Capacitor
import RevenueCatUI
import PurchasesHybridCommonUI

@objc(RevenueCatUIPlugin)
public class RevenueCatUIPlugin: CAPPlugin {
    
    @objc func presentPaywall(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            let args = self.parsePaywallArgs(from: call)
            
            RevenueCatUI.presentPaywall(
                offeringIdentifier: args.offeringIdentifier,
                requiredEntitlementIdentifier: args.requiredEntitlementIdentifier,
                overrides: args.overrides,
                scene: self.bridge?.viewController) { result in
                    call.resolve(self.mapPaywallResult(result))
                }
        }
    }
    
    @objc func presentPaywallIfNeeded(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            let args = self.parsePaywallArgs(from: call)
            
            // Ensure we have a required entitlement identifier
            guard let requiredEntitlementIdentifier = args.requiredEntitlementIdentifier else {
                call.reject("requiredEntitlementIdentifier is required for presentPaywallIfNeeded")
                return
            }
            
            RevenueCatUI.presentPaywallIfNeeded(
                requiredEntitlementIdentifier: requiredEntitlementIdentifier,
                offeringIdentifier: args.offeringIdentifier,
                overrides: args.overrides,
                scene: self.bridge?.viewController) { result in
                    if let result = result {
                        call.resolve(self.mapPaywallResult(result))
                    } else {
                        call.resolve(nil)
                    }
                }
        }
    }
    
    @objc func presentCustomerCenter(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            RevenueCatUI.presentCustomerCenter(
                parent: self.bridge?.viewController,
                onSuccess: {
                    call.resolve()
                },
                onError: { error in
                    call.reject(error.localizedDescription)
                }
            )
        }
    }
    
    @objc func setPaywallOverrides(_ call: CAPPluginCall) {
        if let overridesDict = call.getObject("overrides") {
            let overrides = self.parseOverrides(from: overridesDict)
            RevenueCatUI.setPaywallOverrides(overrides)
            call.resolve()
        } else {
            call.reject("Missing overrides parameter")
        }
    }
    
    // MARK: - Helper Methods
    
    private func parsePaywallArgs(from call: CAPPluginCall) -> (offeringIdentifier: String?, requiredEntitlementIdentifier: String?, overrides: RevenueCatUI.PaywallOverrides?) {
        let offeringIdentifier = call.getString("offeringIdentifier")
        let requiredEntitlementIdentifier = call.getString("requiredEntitlementIdentifier")
        
        var overrides: RevenueCatUI.PaywallOverrides? = nil
        if let overridesDict = call.getObject("overrides") {
            overrides = parseOverrides(from: overridesDict)
        }
        
        return (offeringIdentifier, requiredEntitlementIdentifier, overrides)
    }
    
    private func parseOverrides(from dict: [String: Any]) -> RevenueCatUI.PaywallOverrides {
        let overrides = RevenueCatUI.PaywallOverrides()
        
        // Font options
        if let fontFamily = dict["fontFamily"] as? String {
            overrides.fontName = fontFamily
        }
        if let titleFontSize = dict["titleFontSize"] as? NSNumber {
            overrides.titleFontSize = titleFontSize.floatValue
        }
        if let bodyFontSize = dict["bodyFontSize"] as? NSNumber {
            overrides.bodyFontSize = bodyFontSize.floatValue
        }
        if let captionFontSize = dict["captionFontSize"] as? NSNumber {
            overrides.captionFontSize = captionFontSize.floatValue
        }
        
        // Colors
        if let backgroundColor = dict["backgroundColor"] as? String {
            overrides.backgroundColor = UIColor(hexString: backgroundColor)
        }
        if let primaryTextColor = dict["primaryTextColor"] as? String {
            overrides.primaryTextColor = UIColor(hexString: primaryTextColor)
        }
        if let secondaryTextColor = dict["secondaryTextColor"] as? String {
            overrides.secondaryTextColor = UIColor(hexString: secondaryTextColor)
        }
        if let accentColor = dict["accentColor"] as? String {
            overrides.accentColor = UIColor(hexString: accentColor)
        }
        
        // Button options
        if let primaryButtonBackgroundColor = dict["primaryButtonBackgroundColor"] as? String {
            overrides.primaryButtonBackgroundColor = UIColor(hexString: primaryButtonBackgroundColor)
        }
        if let primaryButtonTextColor = dict["primaryButtonTextColor"] as? String {
            overrides.primaryButtonTextColor = UIColor(hexString: primaryButtonTextColor)
        }
        if let secondaryButtonBackgroundColor = dict["secondaryButtonBackgroundColor"] as? String {
            overrides.secondaryButtonBackgroundColor = UIColor(hexString: secondaryButtonBackgroundColor)
        }
        if let secondaryButtonTextColor = dict["secondaryButtonTextColor"] as? String {
            overrides.secondaryButtonTextColor = UIColor(hexString: secondaryButtonTextColor)
        }
        
        // Text overrides
        if let title = dict["title"] as? String {
            overrides.title = title
        }
        if let subtitle = dict["subtitle"] as? String {
            overrides.subtitle = subtitle
        }
        if let callToAction = dict["callToAction"] as? String {
            overrides.callToAction = callToAction
        }
        if let restoreButtonText = dict["restoreButtonText"] as? String {
            overrides.restoreButtonText = restoreButtonText
        }
        
        // Display options
        if let displayCloseButton = dict["displayCloseButton"] as? Bool {
            overrides.displayCloseButton = displayCloseButton
        }
        
        return overrides
    }
    
    private func mapPaywallResult(_ result: RevenueCatUI.PaywallResult) -> [String: Any] {
        var resultDict: [String: Any] = [:]
        
        switch result {
        case .purchased(let transactionId):
            resultDict["status"] = "purchased"
            resultDict["transactionId"] = transactionId
            
        case .restored(let transactionId):
            resultDict["status"] = "restored"
            if let transactionId = transactionId {
                resultDict["transactionId"] = transactionId
            }
            
        case .cancelled:
            resultDict["status"] = "cancelled"
            
        case .error(let error):
            resultDict["status"] = "error"
            resultDict["error"] = [
                "code": "\(error.code)",
                "message": error.localizedDescription
            ]
        }
        
        return resultDict
    }
}

// MARK: - UIColor extension for hex string
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
} 