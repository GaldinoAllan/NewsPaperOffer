import UIKit

final class NewsPaperHomeViewController: UIViewController {
    // MARK: - Views
    private lazy var activity: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.hidesWhenStopped = true
        return activity
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let headerLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let coverImageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let subscribeTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subscribeSubtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let benefitsExpandableView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let benefitsExpandable: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Properties
    private var viewModel: NewsPaperHomeViewModelProtocol
    
    // MARK: - Initializers
    init(viewModel: NewsPaperHomeViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { nil }
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        viewModel.loadNewsPaperHome()
        startLoading()
    }
    
    // MARK: - Set Up methods
    
    private func setupLayout() {
        setupViewHierarchy()
        setupConstraints()
        configureView()
        setupDelegates()
    }
}

private extension NewsPaperHomeViewController {
    func setupViewHierarchy() {
    }
    
    func setupConstraints() {
    }
    
    func configureView() {
        view.backgroundColor = .white
    }
    
    func setupDelegates() {
        viewModel.delegate = self
    }
    
    func showAlert(with alertInfo: (title: String, message: String)) {
        let alert = UIAlertController(title: alertInfo.title,
                                      message: alertInfo.message,
                                      preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Try Again", style: .default) { [weak self] action in
            dump(action)
            self?.startLoading()
            self?.viewModel.loadNewsPaperHome()
        }
        alert.addAction(alertAction)
        self.present(alert, animated: true)
    }
    
    func startLoading() {
        activity.startAnimating()
    }
    
    func stopLoading() {
        activity.stopAnimating()
    }
}

extension NewsPaperHomeViewController: NewsPaperHomeViewModelDelegate {
    func newsPaperHomeDidLoad() {
        stopLoading()
    }
    
    func fetchFailed(withError errorInfo: (title: String, message: String)) {
        stopLoading()
        showAlert(with: errorInfo)
    }
}
