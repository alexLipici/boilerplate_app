//
//  DashboardCoordinator.swift
//  crypto_app
//
//  Created by Petru-Alexandru Lipici on 08.11.2022.
//

import UIKit
import RxSwift

enum DashboardCoordinationResult: Equatable { }

class DashboardCoordinator: BaseCoordinator<DashboardCoordinationResult> {
    
    private let window: UIWindow!
    
    private var navigationController: UINavigationController!
    
    required init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<CoordinateResultType<CoordinationResult>> {
        let remoteRepository = GetCoinsRepository()
        let viewModel = DashboardViewModel(remoteRepository: remoteRepository)
        let vc = DashboardViewController(viewModel: viewModel)
        navigationController = UINavigationController(rootViewController: vc)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return .never()
    }
}


