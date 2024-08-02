import Foundation

enum NetworkErrors: Error {
    case invalidUrl
    case emptyResponse
    case serverError(message: String)
    case timeOut(message: String)
    case noConnection(message: String)
    case jsonDecoding(message: String)

    var localizedDescription: String {
        switch self {
        case .invalidUrl:
            return "Invalid URL"
        case .emptyResponse:
            return "Empty response"
        case .serverError(_):
            return "Error returning data from the server"
        case .timeOut(_):
            return "Server timeout"
        case .noConnection(_):
            return "Could not establish connection with the servers"
        case .jsonDecoding(_):
            return "Could not decode JSON"
        }
    }
}
