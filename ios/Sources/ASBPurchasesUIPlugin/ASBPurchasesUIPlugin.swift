import Foundation
import Capacitor

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(ASBPurchasesUIPlugin)
public class ASBPurchasesUIPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "ASBPurchasesUIPlugin"
    public let jsName = "ASBPurchasesUI"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "echo", returnType: CAPPluginReturnPromise)
    ]
    private let implementation = ASBPurchasesUI()

    @objc func echo(_ call: CAPPluginCall) {
        let value = call.getString("value") ?? ""
        call.resolve([
            "value": implementation.echo(value)
        ])
    }
}
