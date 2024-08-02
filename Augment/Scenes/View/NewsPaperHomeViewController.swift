import UIKit

final class NewsPaperHomeViewController: UIViewController {
    // MARK: - Views
    private lazy var activity: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .large)
        activity.hidesWhenStopped = true
        activity.translatesAutoresizingMaskIntoConstraints = false
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
        imageView.backgroundColor = .black
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
        label.textAlignment = .center
        label.numberOfLines = .zero
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let subscribeSubtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = .zero
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .darkGray
        return label
    }()
    
    private let offersStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var benefitsExpandableView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapExpandBenefits)))
        return view
    }()
    
    private var benefitsExpandableTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.text = "What is \"News+\"?"
        return label
    }()
    
    private let benefitsExpandableImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.tintColor = .black
        return imageView
    }()
    
    private let benefitsExpandedStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.isHidden = true
        return stackView
    }()
    
    private lazy var subscribeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Subscribe Now", for: .normal)
        button.addTarget(self, action: #selector(subscribeButtonClicked), for: .touchUpInside)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 4
        return button
    }()
    
    private let disclaimerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = .zero
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    // MARK: - Properties
    private var viewModel: NewsPaperHomeViewModelProtocol
    
    private var isBenefitsExpanded: Bool = false {
        didSet {
            benefitsExpandedStackView.isHidden = !isBenefitsExpanded
            benefitsExpandableImageView.image = isBenefitsExpanded ? UIImage(systemName: "chevron.down") : UIImage(systemName: "chevron.up")
        }
    }
    
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

// MARK: - private extension
private extension NewsPaperHomeViewController {
    func setupViewHierarchy() {
        benefitsExpandableView.addSubview(benefitsExpandableTitle)
        benefitsExpandableView.addSubview(benefitsExpandableImageView)
        contentView.addSubview(headerLogoImageView)
        contentView.addSubview(coverImageImageView)
        contentView.addSubview(subscribeTitleLabel)
        contentView.addSubview(subscribeSubtitleLabel)
        contentView.addSubview(offersStackView)
        contentView.addSubview(benefitsExpandableView)
        contentView.addSubview(benefitsExpandedStackView)
        contentView.addSubview(subscribeButton)
        contentView.addSubview(disclaimerLabel)
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
        view.addSubview(activity)
    }
    
    func setupConstraints() {
        scrollViewConstraints()
        contentViewConstraints()
        headerLogoImageViewConstraints()
        coverImageImageViewConstraints()
        subscribeTitleLabelConstraints()
        subscribeSubtitleLabelConstraints()
        offersStackViewConstraints()
        benefitsExpandableTitleConstraints()
        benefitsExpandableImageConstraints()
        benefitsExpandableViewConstraints()
        benefitsExpandedStackViewConstraints()
        subscribeButtonConstraints()
        disclaimerLabelConstraints()
        activityIndicatorConstraints()
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
    
    func addBenefitsToBenefitsStackView(_ benefits: [String]) {
        benefits.forEach { benefit in
            let label = UILabel()
            label.text = "- \(benefit)"
            label.numberOfLines = 1
            label.font = .systemFont(ofSize: 12, weight: .regular)
            benefitsExpandedStackView.addArrangedSubview(label)
        }
    }
    
    func startLoading() {
        activity.startAnimating()
    }
    
    func stopLoading() {
        activity.stopAnimating()
    }
}

// MARK: - NewsPaperHomeViewModelDelegate
extension NewsPaperHomeViewController: NewsPaperHomeViewModelDelegate {
    func newsPaperHomeDidLoad(with model: NewsPaperHomeModel) {
        stopLoading()
        headerLogoImageView.setImageUrl(with: model.record.headerLogo)
        coverImageImageView.setImageUrl(with: model.record.subscription.coverImage)
        subscribeTitleLabel.text = model.record.subscription.subscribeTitle
        subscribeSubtitleLabel.text = model.record.subscription.subscribeSubtitle
        let firstPriceValue = PriceDescriptionView()
        firstPriceValue.setupPriceDescription(
            price: model.record.subscription.offers.id0.price,
            description: model.record.subscription.offers.id0.description
        )
        offersStackView.addArrangedSubview(firstPriceValue)
        let secondPriceValue = PriceDescriptionView()
        secondPriceValue.setupPriceDescription(
            price: model.record.subscription.offers.id1.price,
            description: model.record.subscription.offers.id1.description
        )
        offersStackView.addArrangedSubview(secondPriceValue)
        disclaimerLabel.text = model.record.subscription.disclaimer
        addBenefitsToBenefitsStackView(model.record.subscription.benefits)
    }
    
    func fetchFailed(withError errorInfo: (title: String, message: String)) {
        stopLoading()
        showAlert(with: errorInfo)
    }
}
// MARK: Constraints
private extension NewsPaperHomeViewController {
    func scrollViewConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func contentViewConstraints() {
        let heightConstraint = contentView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
        heightConstraint.priority = .defaultLow
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            heightConstraint,
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
    }
    
    func headerLogoImageViewConstraints() {
        NSLayoutConstraint.activate([
            headerLogoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerLogoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerLogoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerLogoImageView.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    func coverImageImageViewConstraints() {
        NSLayoutConstraint.activate([
            coverImageImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            coverImageImageView.topAnchor.constraint(equalTo: headerLogoImageView.bottomAnchor, constant: 16),
            coverImageImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            coverImageImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func subscribeTitleLabelConstraints() {
        NSLayoutConstraint.activate([
            subscribeTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            subscribeTitleLabel.topAnchor.constraint(equalTo: coverImageImageView.bottomAnchor, constant: 16),
            subscribeTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    func subscribeSubtitleLabelConstraints() {
        NSLayoutConstraint.activate([
            subscribeSubtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            subscribeSubtitleLabel.topAnchor.constraint(equalTo: subscribeTitleLabel.bottomAnchor, constant: 16),
            subscribeSubtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    func offersStackViewConstraints() {
        NSLayoutConstraint.activate([
            offersStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            offersStackView.topAnchor.constraint(equalTo: subscribeSubtitleLabel.bottomAnchor, constant: 16),
            offersStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    func benefitsExpandableViewConstraints() {
        NSLayoutConstraint.activate([
            benefitsExpandableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 56),
            benefitsExpandableView.topAnchor.constraint(equalTo: offersStackView.bottomAnchor, constant: 56),
            benefitsExpandableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -56)
        ])
    }
    
    func benefitsExpandableTitleConstraints() {
        NSLayoutConstraint.activate([
            benefitsExpandableTitle.leadingAnchor.constraint(equalTo: benefitsExpandableView.leadingAnchor, constant: 4),
            benefitsExpandableTitle.topAnchor.constraint(equalTo: benefitsExpandableView.topAnchor, constant: 4),
            benefitsExpandableTitle.bottomAnchor.constraint(equalTo: benefitsExpandableView.bottomAnchor, constant: -4),
        ])
    }
    
    func benefitsExpandableImageConstraints() {
        NSLayoutConstraint.activate([
            benefitsExpandableImageView.leadingAnchor.constraint(greaterThanOrEqualTo: benefitsExpandableTitle.leadingAnchor, constant: 4),
            benefitsExpandableImageView.topAnchor.constraint(equalTo: benefitsExpandableView.topAnchor, constant: 4),
            benefitsExpandableImageView.trailingAnchor.constraint(equalTo: benefitsExpandableView.trailingAnchor, constant: -4),
            benefitsExpandableImageView.bottomAnchor.constraint(equalTo: benefitsExpandableView.bottomAnchor, constant: -4),
        ])
    }
    
    func benefitsExpandedStackViewConstraints() {
        NSLayoutConstraint.activate([
            benefitsExpandedStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            benefitsExpandedStackView.topAnchor.constraint(equalTo: benefitsExpandableView.bottomAnchor, constant: 4),
            benefitsExpandedStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32)
        ])
    }
    
    func subscribeButtonConstraints() {
        NSLayoutConstraint.activate([
            subscribeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            subscribeButton.topAnchor.constraint(greaterThanOrEqualTo: offersStackView.bottomAnchor, constant: 16),
            subscribeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            subscribeButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    func disclaimerLabelConstraints() {
        NSLayoutConstraint.activate([
            disclaimerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            disclaimerLabel.topAnchor.constraint(equalTo: subscribeButton.bottomAnchor, constant: 12),
            disclaimerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            disclaimerLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    
    func activityIndicatorConstraints() {
        NSLayoutConstraint.activate([
            activity.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activity.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

@objc
private extension NewsPaperHomeViewController {
    func subscribeButtonClicked() {
        dump("Subscribe Button Clicked")
    }
    
    func didTapExpandBenefits() {
        self.isBenefitsExpanded = !isBenefitsExpanded
    }
}
