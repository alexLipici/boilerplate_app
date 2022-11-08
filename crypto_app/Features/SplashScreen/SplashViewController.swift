//
//  SplashViewController.swift
//  crypto_app
//
//  Created by Petru-Alexandru Lipici on 07.11.2022.
//

import UIKit
import PKHUD

class SplashViewController: UIViewController {
    
    private let viewModel: SplashViewModel
    
    private var permissionManager: PermissionManager?
    
    private var _view: SplashView {
        return view as! SplashView
    }
    
    override func loadView() {
        view = SplashView(frame: .zero)
    }
    
    required init(viewModel: SplashViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("☠️ deinit called on \(NSStringFromClass(type(of: self)))")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        permissionManager = PermissionManager(parentViewController: self)
        
        permissionManager?.requestAccessFor(
            .appTransparency,
            showGoToSettingsAlert: false,
            completionHandler: { [weak self] _ in
                DispatchQueue.main.async {
                    self?.viewModel.viewDidAppear()
                }
            })
    }
}
