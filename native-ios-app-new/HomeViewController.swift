import UIKit

class HomeViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = "Home"
        view.backgroundColor = .systemBackground
        
        // Setup scroll view
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
        
        // Create cards
        let cards = [
            CardInfo(title: "Native Profile", subtitle: "Native iOS Screen", color: .systemBlue, viewController: ProfileViewController()),
            CardInfo(title: "Native About", subtitle: "Native iOS Screen", color: .systemGreen, viewController: AboutViewController()),
            CardInfo(title: "RN Products", subtitle: "React Native Module", color: .systemOrange, viewController: ProductsViewController()),
            CardInfo(title: "RN Carts", subtitle: "React Native Module", color: .systemPurple, viewController: CartViewController()),
            CardInfo(title: "RN PDP", subtitle: "React Native Module", color: .systemRed, viewController: PDPViewController(productId: "sample-product-123"))
        ]
        
        for card in cards {
            let cardView = createCardView(for: card)
            contentView.addArrangedSubview(cardView)
        }
    }
    
    private func createCardView(for cardInfo: CardInfo) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .secondarySystemBackground
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        containerView.layer.shadowOpacity = 0.1
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardTapped(_:)))
        containerView.addGestureRecognizer(tapGesture)
        containerView.tag = contentView.arrangedSubviews.count
        containerView.isUserInteractionEnabled = true
        
        // Store view controller reference
        objc_setAssociatedObject(containerView, &AssociatedKeys.viewController, cardInfo.viewController, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = cardInfo.title
        titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textColor = cardInfo.color
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = cardInfo.subtitle
        subtitleLabel.font = .systemFont(ofSize: 14, weight: .regular)
        subtitleLabel.textColor = .secondaryLabel
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        
        containerView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            containerView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        return containerView
    }
    
    @objc private func cardTapped(_ gesture: UITapGestureRecognizer) {
        guard let cardView = gesture.view,
              let viewController = objc_getAssociatedObject(cardView, &AssociatedKeys.viewController) as? UIViewController else {
            return
        }
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}

private struct CardInfo {
    let title: String
    let subtitle: String
    let color: UIColor
    let viewController: UIViewController
}

private struct AssociatedKeys {
    static var viewController: UInt8 = 0
}
