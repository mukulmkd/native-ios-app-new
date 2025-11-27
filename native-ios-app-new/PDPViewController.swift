import UIKit

class PDPViewController: UIViewController {
        
    private let productId: String
    
    init(productId: String) {
        self.productId = productId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = "RN PDP"
        view.backgroundColor = .systemBackground
        
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = "React Native PDP Module\n(Will be integrated later)"
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        
        let productIdLabel = UILabel()
        productIdLabel.text = "Product ID: \(productId)"
        productIdLabel.font = .systemFont(ofSize: 16, weight: .regular)
        productIdLabel.textColor = .systemBlue
        
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(productIdLabel)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
}
