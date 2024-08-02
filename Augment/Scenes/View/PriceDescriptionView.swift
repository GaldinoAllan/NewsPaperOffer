import UIKit

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
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
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
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            priceLabel.topAnchor.constraint(equalTo: topAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            priceDescriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            priceDescriptionLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8),
            priceDescriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            priceDescriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func formatAsCurrency(value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: NSNumber(value: value)) ?? ""
    }

}
