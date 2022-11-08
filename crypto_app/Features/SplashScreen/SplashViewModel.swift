//
//  SplashViewModel.swift
//  crypto_app
//
//  Created by Petru-Alexandru Lipici on 07.11.2022.
//

import Foundation
import RxSwift
import PKHUD

class SplashViewModel {
    
    let goToApp: PublishSubject<Void> = .init()
    private var performedChecks = false
        
    deinit {
        print("☠️ deinit called on \(NSStringFromClass(type(of: self)))")
    }
    
    func viewDidAppear() {
        guard !performedChecks else { return }
        
        performedChecks = true
        
        fetchAppCredentials {
            self.downloadSSLCertificates {
                self.continueToApp()
            }
        }
    }
    
    // method used to download app credentials in order to avoid storring them as static keys
    private func fetchAppCredentials(completion: @escaping ()->Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            completion()
        }
    }
    
    private func downloadSSLCertificates(completion: @escaping ()->Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            completion()
        }
    }
    
    private func continueToApp() {
        goToApp.onNext(())
    }
}
