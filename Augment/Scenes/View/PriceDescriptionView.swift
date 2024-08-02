import UIKit

protocol PriceDescriptionViewDelegate: AnyObject {
    func didToggleCheckBox(for offerId: OfferID)
}

final class PriceDescriptionView: UIControl {
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let priceDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = .zero
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var checkboxButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        let uncheckedImage = UIImage(systemName: "circle")
        let checkedImage = UIImage(systemName: "checkmark.circle")
        button.setImage(uncheckedImage, for: .normal)
        button.setImage(checkedImage, for: .selected)
        button.tintColor = .darkGray
        button.addTarget(self, action: #selector(toggleCheckbox), for: .touchUpInside)
        return button
    }()
    
    var isChecked = false {
        didSet {
            checkboxButton.isSelected = isChecked
        }
    }
    
    weak var delegate: PriceDescriptionViewDelegate?
    
    let offerId: OfferID
    
    private var price: String = "" {
        didSet {
            priceLabel.text = price
        }
    }
    
    private var priceDescription: String = "" {
        didSet {
            priceDescriptionLabel.text = priceDescription
        }
    }
    
    init(offerId: OfferID) {
        self.offerId = offerId
        super.init(frame: .zero)
        setupViewHierarchy()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    func setupPriceDescription(price: Double, description: String) {
        self.price = formatAsCurrency(value: price)
        self.priceDescription = description
    }
}

private extension PriceDescriptionView {
    func setupViewHierarchy() {
        addSubview(priceLabel)
        addSubview(priceDescriptionLabel)
        addSubview(checkboxButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            priceLabel.topAnchor.constraint(equalTo: topAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            priceDescriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            priceDescriptionLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8),
            priceDescriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            checkboxButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            checkboxButton.topAnchor.constraint(equalTo: priceDescriptionLabel.bottomAnchor, constant: 8),
            checkboxButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            checkboxButton.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func formatAsCurrency(value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: NSNumber(value: value)) ?? ""
    }
    
    @objc
    func toggleCheckbox() {
        isChecked.toggle()
        delegate?.didToggleCheckBox(for: offerId)
    }
}
