import UIKit

extension UIColor {
    /// Фон приложения — тот же #0A0A0A, что и в веб-интерфейсе.
    static let monoBackground = UIColor(red: 10 / 255, green: 10 / 255, blue: 10 / 255, alpha: 1)
}

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = .monoBackground
        window.overrideUserInterfaceStyle = .dark
        window.rootViewController = WebViewController()
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
}
