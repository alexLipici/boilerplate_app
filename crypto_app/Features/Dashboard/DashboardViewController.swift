//
//  DashboardViewController.swift
//  crypto_app
//
//  Created by Petru-Alexandru Lipici on 07.11.2022.
//

import UIKit
import RxSwift

class DashboardViewController: UIViewController {

    private let viewModel: DashboardViewModel
    private lazy var cellProvider = DashboardCellPovider(tableView: _view.tableView)
        
    private let disposeBag = DisposeBag()
    
    private var _view: DashboardView {
        return view as! DashboardView
    }
    
    override func loadView() {
        view = DashboardView(frame: .zero)
    }
    
    required init(viewModel: DashboardViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if isBeingDismissed {
            viewModel.didDissapear()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeUI()
        addSubscribers()
        viewModel.viewDidLoad()
    }

    private func customizeUI() {
        title = "Dashboard coins"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        _view.tableView.register(DashboardCell.self, forCellReuseIdentifier: "DashboardCell")
        _view.tableView.delegate = self
        _view.tableView.dataSource = self
    }
    
    private func addSubscribers() {
        viewModel.reloadData
            .subscribe(onNext: { [weak self] in
                self?._view.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension DashboardViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.objects.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.section < viewModel.objects.count else {
            return UITableViewCell()
        }
        return cellProvider.cellForRow(object: viewModel.objects[indexPath.section])
    }
}
