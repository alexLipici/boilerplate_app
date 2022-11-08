//
//  DashboardViewModel.swift
//  crypto_app
//
//  Created by Petru-Alexandru Lipici on 07.11.2022.
//

import Foundation
import RxSwift

class DashboardViewModel {
    
    private let remoteRepository: RemoteRepository<GetCoinsResponse>
    
    var showError = PublishSubject<AppError>()
    var reloadData = PublishSubject<Void>()
    
    var objects: [CoinInfo] = [] {
        didSet {
            reloadData.onNext(())
        }
    }
    
    init(remoteRepository: RemoteRepository<GetCoinsResponse>) {
        self.remoteRepository = remoteRepository
    }
    
    func viewDidLoad() {
        DispatchQueue.global().async {
            self.remoteRepository.executeRequest(parameters: [:]) { [weak self] result in
                switch result {
                case .success(let response):
                    self?.objects = response.data
                case .failure(let error):
                    self?.showError.onNext(error.toAppError())
                }
            }
        }
    }
    
    func didDissapear() {
        remoteRepository.cancelRequest()
    }
}
