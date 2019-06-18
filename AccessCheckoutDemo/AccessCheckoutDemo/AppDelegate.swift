import UIKit
import Mockingjay
import AccessCheckoutSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Network stubs
        setupDiscoveryStub()
        setupVerifiedTokensStub()
        setupVerifiedTokensSessionStub()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    private func setupDiscoveryStub() {
        if let stubDiscovery = UserDefaults.standard.string(forKey: "stubDiscovery"),
            let url = Bundle.main.url(forResource: stubDiscovery, withExtension: "json"),
            let data = try? Data(contentsOf: url) {
                MockingjayProtocol.addStub(matcher: http(.get, uri: "https://access.worldpay.com"),
                                           builder: jsonData(data))
        }
    }

    private func setupVerifiedTokensStub() {
        if let stubVerifiedTokens = UserDefaults.standard.string(forKey: "stubVerifiedTokens"),
            let url = Bundle.main.url(forResource: stubVerifiedTokens, withExtension: "json"),
            let data = try? Data(contentsOf: url) {
            MockingjayProtocol.addStub(matcher: http(.get, uri: "https://access.worldpay.com/verifiedTokens"),
                                           builder: jsonData(data))
        }
    }
    
    private func setupVerifiedTokensSessionStub() {
        if let stubVerifiedTokensSession = UserDefaults.standard.string(forKey: "stubVerifiedTokensSession"),
            let url = Bundle.main.url(forResource: stubVerifiedTokensSession, withExtension: "json"),
            let data = try? Data(contentsOf: url) {
                MockingjayProtocol.addStub(matcher: http(.post, uri: "https://access.worldpay.com/verifiedTokens/sessions"),
                                       builder: jsonData(data))
        }
    }

}

