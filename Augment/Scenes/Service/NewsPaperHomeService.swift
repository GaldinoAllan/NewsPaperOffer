import Foundation
import CoreData
import UIKit

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
            guard let self else { return }
            
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
                guard let decoded = try self.getModel(from: jsonData) else {
                    completionHandler(.failure(.jsonDecoding(message: "Could not decode JSON")))
                    return
                }
                DispatchQueue.main.async {
                    completionHandler(.success(decoded))
                }
            } catch let error {
                DispatchQueue.main.async {
                    completionHandler(.failure(.jsonDecoding(message: error.localizedDescription)))
                }
            }
        }
        
        /// Used the code below to mock when the server was unavailable
//        do {
//            guard let decodedMock = try self.getModel(from: NewsPaperHomeAPI.modelMock!) else {
//                completionHandler(.failure(.jsonDecoding(message: "Could not decode JSON")))
//                return
//            }
//            DispatchQueue.main.async {
//                completionHandler(.success(decodedMock))
//            }
//        } catch let error {
//            DispatchQueue.main.async {
//                completionHandler(.failure(.jsonDecoding(message: error.localizedDescription)))
//            }
//        }
//        return
    }
}

private extension NewsPaperHomeService {
    func getModel(from data: Data) throws -> NewsPaperHomeModel? {
        let decoder = JSONDecoder()
        let responseModel = try? decoder.decode(NewsPaperHomeModel.self, from: data)
        let coreDataModel = try? decoder.decode(NewsPaperHomeModel.self, from: fetchFromCoreData())
        
        switch (responseModel, coreDataModel) {
        case (nil, nil):
            throw NetworkErrors.jsonDecoding(message: "Could not decode JSON")
        case (let response, nil):
            dump("Save new response to Core Data")
            saveToCoreData(data: data)
            return response
        case (nil, let cdResponse):
            dump("Return value from Core Data")
            return cdResponse
        case (let response, let cdResponse):
            dump("Compare and update values")
            if response == cdResponse {
                return cdResponse
            } else {
                saveToCoreData(data: data)
                return response
            }
        }
    }
    
    func saveToCoreData(data: Data) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let newEntity = NSEntityDescription.insertNewObject(
            forEntityName: CoreDataValues.Entity.newsPaperHome,
            into: context
        )
        newEntity.setValue(data, forKey: CoreDataValues.Key.newsPaperHomeData)
        
        do {
            try context.save()
        } catch {
            print("Failed saving data")
        }
    }
    
    func fetchFromCoreData() -> Data {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataValues.Entity.newsPaperHome)
        
        do {
            let result = try context.fetch(request)
            var dataResponse: Data = Data()
            for data in result as! [NSManagedObject] {
                guard let myData = data.value(forKey: CoreDataValues.Key.newsPaperHomeData) as? Data else { return Data() }
                dataResponse = myData
            }
            return dataResponse
        } catch {
            print("Failed fetching")
        }
        return Data()
    }
}
