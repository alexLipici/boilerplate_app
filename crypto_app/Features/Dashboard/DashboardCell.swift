//
//  DashboardCell.swift
//  crypto_app
//
//  Created by Petru-Alexandru Lipici on 07.11.2022.
//

import UIKit

class DashboardCell: UITableViewCell {}

struct DashboardCellPovider {
    
    private let tableView: UITableView
    
    init(tableView: UITableView) {
        self.tableView = tableView
    }
    
    func cellForRow(object: CoinInfo) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardCell") as! DashboardCell
        
        var config = cell.defaultContentConfiguration()
        config.text = object.name
        config.secondaryText = object.priceUsd
        
        cell.accessoryType = .disclosureIndicator
        cell.contentConfiguration = config
        
        return cell
    }
}
