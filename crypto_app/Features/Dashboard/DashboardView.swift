//
//  DashboardView.swift
//  crypto_app
//
//  Created by Petru-Alexandru Lipici on 07.11.2022.
//

import UIKit
import SnapKit

class DashboardView: UIView {

    lazy var tableView: UITableView = {
        UIBuilder.makeInsetGroupedTableView()
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        configSubviewsConstraints()
        configSubviewsLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func addSubviews() {
        addSubview(tableView)
    }
    
    private func configSubviewsConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configSubviewsLayout() {
        tableView.contentInset = .init(top: 12, left: 0, bottom: 0, right: 0)
    }
}
