import Foundation

protocol NewsPaperHomeViewModelDelegate: AnyObject {
    func newsPaperHomeDidLoad()
    func fetchFailed(withError errorInfo: (title: String, message: String))
}

class NewsPaperHomeViewModel {
    // MARK: - Properties
    private let service: NewsPaperHomeServicing
    private(set) var newsPaperHome: NewsPaperHomeModel?

    weak var delegate: NewsPaperHomeViewModelDelegate?

    // MARK: - Initializer
    init(service: NewsPaperHomeServicing) {
        self.service = service
    }

    // MARK: - Contents
    func loadNewsPaperHome() {
        service.getNewsPaperPlans { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let homeModel):
                self.onLoadHome(model: homeModel)
            case .failure(let error):
                self.delegate?.fetchFailed(
                    withError: (
                        title: "Error loading News Paper Home",
                        message: error.localizedDescription
                    )
                )
            }
        }
    }
}

private extension NewsPaperHomeViewModel {
    func onLoadHome(model: NewsPaperHomeModel) {
        self.newsPaperHome = model
        // TODO: Save to Core Data if differs from previous payload
        delegate?.newsPaperHomeDidLoad()
    }
}
