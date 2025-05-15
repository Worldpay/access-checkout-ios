import XCTest

@testable import AccessCheckoutDemo

class AppLauncher {
    private let LaunchArgument_enableStubs = "enableStubs"

    private init() {}

    static func appLauncher() -> AppLauncher {
        return AppLauncher()
    }

    static func launch(enableStubs: Bool? = nil) -> XCUIApplication {
        return AppLauncher().launch(enableStubs: enableStubs)
    }

    private func launch(enableStubs: Bool? = nil) -> XCUIApplication {
        let app = XCUIApplication()

        if let enableStubs = enableStubs {
            app.launchArguments.append(contentsOf: [
                "-\(LaunchArgument_enableStubs)", enableStubs.description,
            ])
        }
        app.launch()

        return app
    }
}
