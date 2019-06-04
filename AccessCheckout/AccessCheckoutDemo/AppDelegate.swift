import UIKit
import Mockingjay
import AccessCheckout

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
        guard let stubName = UserDefaults.standard.string(forKey: "stub:discovery") else {
            return
        }
        guard let stub = StubProvider.stub(forName: stubName, bundle: Bundle.main) else {
            return
        }
        MockingjayProtocol.addStub(matcher: http(.get, uri: stub.baseUri),
                                   builder: jsonData(stub.data))
    }

    private func setupVerifiedTokensStub() {
        guard let stubName = UserDefaults.standard.string(forKey: "stub:tokens") else {
            return
        }
        guard let stub = StubProvider.stub(forName: stubName, bundle: Bundle.main) else {
            return
        }
        MockingjayProtocol.addStub(matcher: http(.get, uri: "\(stub.baseUri)/verifiedTokens"),
                                   builder: jsonData(stub.data))
    }
    
    private func setupVerifiedTokensSessionStub() {
        guard let stubName = UserDefaults.standard.string(forKey: "stub:tokens-create") else {
            return
        }
        guard let stub = StubProvider.stub(forName: stubName, bundle: Bundle.main) else {
            return
        }
        MockingjayProtocol.addStub(matcher: http(.post, uri: "\(stub.baseUri)/verifiedTokens/sessions"),
                                   builder: jsonData(stub.data))
    }

}

