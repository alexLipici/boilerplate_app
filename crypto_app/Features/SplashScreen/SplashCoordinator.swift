//
//  SplashCoordinator.swift
//  crypto_app
//
//  Created by Petru-Alexandru Lipici on 07.11.2022.
//

import UIKit
import RxSwift

enum SplashCoordinatationResult: Equatable {
    case goToApp
}

class SplashCoordinator: BaseCoordinator<SplashCoordinatationResult> {
    
    private let window: UIWindow!
    
    private var viewController: UIViewController!
    
    required init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<CoordinateResultType<CoordinationResult>> {
        
        let viewModel = SplashViewModel()
        viewController = SplashViewController(viewModel: viewModel)
        
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
                
        let goToAppObserver = viewModel.goToApp
            .map({ CoordinateResultType.executeAndFreeUpTheCoordinator(
                CoordinationResult.goToApp) })
        
        return Observable.merge(goToAppObserver)
            .take(1)
    }
}
