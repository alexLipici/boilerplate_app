//
//  AppCoordinator.swift
//  crypto_app
//
//  Created by Petru-Alexandru Lipici on 07.11.2022.
//

import UIKit
import RxSwift
import PKHUD

class AppCoordinator: BaseCoordinator<Void> {
    
    static let shared = AppCoordinator()
    
    var window: UIWindow!
    private var rootViewController: UIViewController {
        return window.rootViewController!
    }
        
    override func start() -> Observable<CoordinateResultType<Void>> {
        
        coordinate(to: SplashCoordinator(window: window))
            .subscribe(onNext: { [weak self] coordinationResult in
                
                guard let self = self else { return }
                
                switch coordinationResult {
                case .goToApp:
                    self.showMainScreen()
                }
            })
            .disposed(by: disposeBag)
        
        return .never()
    }
    
    private func showMainScreen() {
                
        let dashboardCoordinator = DashboardCoordinator(window: window)
        
        coordinate(to: dashboardCoordinator)
            .subscribe()
            .disposed(by: disposeBag)
    }
}

