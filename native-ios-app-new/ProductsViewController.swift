import UIKit
import React
import VSCORNModuleProductsSPM

class ProductsViewController: UIViewController {
    
    var reactRootView: RCTRootView?
    var bridge: RCTBridge?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "RN Products"
        loadProductsModule()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func loadProductsModule() {
        print("🔍 Starting Products module load...")
        
        // Use SPM package's API to get bundle URL
        // SPM packages are linked statically, not as separate framework bundles
        guard let bundleURL = ModuleProductsFramework.shared.getBundleURL() else {
            print("❌ Failed to get bundle URL from ModuleProductsFramework")
            print("   Checking available bundles in main bundle...")
            if let bundlePath = Bundle.main.path(forResource: "module-products", ofType: "bundle") {
                print("   ✅ Found bundle in main bundle: \(bundlePath)")
            } else {
                print("   ❌ Bundle not found in main bundle either")
            }
            setupFallbackView()
            return
        }
        
        print("✅ Bundle URL: \(bundleURL.path)")
        
        let moduleName = ModuleProductsFramework.shared.getModuleName()
        
        print("📦 Loading Products module")
        print("   JS Bundle URL: \(bundleURL.path)")
        print("   Module Name: \(moduleName)")
        
        // Create bridge
        let bridge = RCTBridge(bundleURL: bundleURL, moduleProvider: nil, launchOptions: nil)
        
        guard let bridge = bridge else {
            print("❌ Failed to create React Native bridge")
            setupFallbackView()
            return
        }
        
        self.bridge = bridge
        print("✅ React Native bridge created")
        
        // Create root view
        let rootView = RCTRootView(
            bridge: bridge,
            moduleName: moduleName,
            initialProperties: nil
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
        
        let label = UILabel()
        label.text = "Failed to load Products Module. Check logs."
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    deinit {
        reactRootView?.removeFromSuperview()
        reactRootView = nil
        bridge?.invalidate()
        bridge = nil
    }
}
