import Foundation
import WebKit

/// Отдаёт файлы из папки Web внутри приложения по адресам вида mono://app/<путь>.
/// Постоянный адрес нужен, чтобы данные в localStorage не терялись между запусками.
final class LocalFileSchemeHandler: NSObject, WKURLSchemeHandler {
    private let root: URL = Bundle.main.resourceURL!
        .appendingPathComponent("Web", isDirectory: true)
        .standardizedFileURL

    func webView(_ webView: WKWebView, start task: WKURLSchemeTask) {
        guard let url = task.request.url else { return fail(task) }

        var path = url.path
        if path.isEmpty || path == "/" { path = "/index.html" }
        let file = root.appendingPathComponent(String(path.dropFirst())).standardizedFileURL

        // Не выпускаем запросы за пределы папки Web.
        guard file.path.hasPrefix(root.path + "/"),
              let data = try? Data(contentsOf: file),
              let response = HTTPURLResponse(
                  url: url,
                  statusCode: 200,
                  httpVersion: "HTTP/1.1",
                  headerFields: [
                      "Content-Type": Self.mimeType(for: file.pathExtension),
                      "Content-Length": String(data.count),
                      "Cache-Control": "no-cache",
                  ]
              )
        else { return fail(task) }

        task.didReceive(response)
        task.didReceive(data)
        task.didFinish()
    }

    func webView(_ webView: WKWebView, stop task: WKURLSchemeTask) {}

    private func fail(_ task: WKURLSchemeTask) {
        task.didFailWithError(URLError(.fileDoesNotExist))
    }

    private static func mimeType(for ext: String) -> String {
        switch ext.lowercased() {
        case "html", "htm": return "text/html; charset=utf-8"
        case "js", "mjs": return "text/javascript; charset=utf-8"
        case "css": return "text/css; charset=utf-8"
        case "json", "map": return "application/json; charset=utf-8"
        case "svg": return "image/svg+xml"
        case "png": return "image/png"
        case "jpg", "jpeg": return "image/jpeg"
        case "webp": return "image/webp"
        case "woff2": return "font/woff2"
        case "woff": return "font/woff"
        case "wasm": return "application/wasm"
        case "bcmap": return "application/octet-stream"
        default: return "application/octet-stream"
        }
    }
}
