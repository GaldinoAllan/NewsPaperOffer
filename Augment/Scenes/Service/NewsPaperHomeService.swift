import Foundation

protocol NewsPaperHomeServicing {
    func getNewsPaperPlans(completionHandler: @escaping (Result<NewsPaperHomeModel, NetworkErrors>) -> Void)
}

final class NewsPaperHomeService: NewsPaperHomeServicing {
    private let apiURLString: String
    private let session: NetworkSession
    
    init(apiUrl: String, session: NetworkSession) {
        self.session = session
        self.apiURLString = apiUrl
    }
    
    func getNewsPaperPlans(completionHandler: @escaping (Result<NewsPaperHomeModel, NetworkErrors>) -> Void) {
        guard let apiUrl = URL(string: apiURLString) else {
            completionHandler(.failure(.invalidUrl))
            return
        }
        
        session.executeRequest(with: apiUrl) { [weak self] (data, response, error) in
            guard self != nil else { return }
            
            guard error == nil else {
                completionHandler(.failure(
                    .serverError(message: error?.localizedDescription ?? "")))
                return
            }
            
            guard let jsonData = data else {
                completionHandler(.failure(.emptyResponse))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decoded = try decoder.decode(NewsPaperHomeModel.self, from: jsonData)
                DispatchQueue.main.async {
                    completionHandler(.success(decoded))
                }
            } catch let error {
                completionHandler(.failure(.jsonDecoding(message: error.localizedDescription)))
            }
        }
    }
}
