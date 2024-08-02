import Foundation

protocol NetworkSession {
    func executeRequest(with url: URL,
                        completionHandler: @escaping ((Data?, URLResponse?, Error?) -> Void))
}
