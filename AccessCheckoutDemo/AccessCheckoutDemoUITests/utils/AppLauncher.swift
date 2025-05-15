import XCTest

@testable import AccessCheckoutDemo

class AppLauncher {
    private let LaunchArgument_enableStubs = "enableStubs"
    private let LaunchArgument_displayDismissKeyboardButton = "displayDismissKeyboardButton"

    private init() {}

    static func appLauncher() -> AppLauncher {
        return AppLauncher()
    }

    static func launch(enableStubs: Bool? = nil) -> XCUIApplication {
        return AppLauncher().launch(enableStubs: enableStubs)
    }

    static func launch(displayDismissKeyboardButton: Bool) -> XCUIApplication {
        return AppLauncher().launch(
            enableStubs: false, displayDismissKeyboardButton: displayDismissKeyboardButton)
    }

    private func launch(enableStubs: Bool? = nil, displayDismissKeyboardButton: Bool? = nil)
        -> XCUIApplication
    {
        let app = XCUIApplication()

        if let enableStubs = enableStubs {
            app.launchArguments.append(contentsOf: [
                "-\(LaunchArgument_enableStubs)", enableStubs.description,
            ])
        }

        if let displayDismissKeyboardButton = displayDismissKeyboardButton {
            app.launchArguments.append(contentsOf: [
                "-\(LaunchArgument_displayDismissKeyboardButton)",
                displayDismissKeyboardButton.description,
            ])
        }

        app.launch()

        return app
    }
}
