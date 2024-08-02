import UIKit

enum NewsPaperHomeFactory {
    static func make() -> UIViewController {
        let service = NewsPaperHomeService(apiUrl: NewsPaperHomeAPI.url, session: URLSession.shared)
        let viewModel = NewsPaperHomeViewModel(service: service)
        let viewController = NewsPaperHomeViewController(viewModel: viewModel)
        return viewController
    }
}
