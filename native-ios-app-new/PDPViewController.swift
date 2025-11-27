import UIKit
import React
import ModulePDPFramework

class PDPViewController: UIViewController {
    
    private let productId: String
    var reactRootView: RCTRootView?
    var bridge: RCTBridge?
    
    init(productId: String) {
        self.productId = productId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "RN PDP"
        loadPDPModule()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func loadPDPModule() {
        print("🔍 Starting PDP module load...")
        print("   Product ID: \(productId)")
        
        // Use SPM package's API to get bundle URL
        // SPM packages are linked statically, not as separate framework bundles
        guard let bundleURL = ModulePDPFramework.shared.getBundleURL() else {
            print("❌ Failed to get bundle URL from ModulePDPFramework")
            print("   Checking available bundles in main bundle...")
            if let bundlePath = Bundle.main.path(forResource: "module-pdp", ofType: "bundle") {
                print("   ✅ Found bundle in main bundle: \(bundlePath)")
            } else {
                print("   ❌ Bundle not found in main bundle either")
            }
            setupFallbackView()
            return
        }
        
        print("✅ Bundle URL: \(bundleURL.path)")
        
        let moduleName = ModulePDPFramework.shared.getModuleName()
        
        print("📦 Loading PDP module")
        print("   JS Bundle URL: \(bundleURL.path)")
        print("   Module Name: \(moduleName)")
        print("   Initial Properties: [\"productId\": \"\(productId)\"]")
        
        // Create initial properties with productId
        let initialProperties: [String: Any] = ["productId": productId]
        
        // Create bridge
        let bridge = RCTBridge(bundleURL: bundleURL, moduleProvider: nil, launchOptions: nil)
        
        guard let bridge = bridge else {
            print("❌ Failed to create React Native bridge")
            setupFallbackView()
            return
        }
        
        self.bridge = bridge
        print("✅ React Native bridge created")
        
        // Create root view with initial properties
        let rootView = RCTRootView(
            bridge: bridge,
            moduleName: moduleName,
            initialProperties: initialProperties
        )
        
        rootView.backgroundColor = .systemBackground
        rootView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(rootView)
        self.reactRootView = rootView
        
        NSLayoutConstraint.activate([
            rootView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            rootView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            rootView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rootView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        print("✅ Root view added to hierarchy")
    }
    
    private func setupFallbackView() {
        view.backgroundColor = .systemBackground
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = "Failed to load PDP Module. Check logs."
        label.textAlignment = .center
        label.numberOfLines = 0
        
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
    
    deinit {
        reactRootView?.removeFromSuperview()
        reactRootView = nil
        bridge?.invalidate()
        bridge = nil
    }
}
