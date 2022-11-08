//
//  UIBuilder.swift
//  crypto_app
//
//  Created by Petru-Alexandru Lipici on 07.11.2022.
//

import UIKit

class UIBuilder {
    static func makeRegularLabel(text: String? = nil, ofSize size: CGFloat) -> UILabel {
        let label = UILabel(block: {
            $0.text = text
            $0.font = UIFont.systemFont(ofSize: size)
            $0.textColor = UIColor.Text.primary
        })
        return label
    }
    
    static func makeMediumLabel(text: String? = nil, ofSize size: CGFloat) -> UILabel {
        let label = UILabel(block: {
            $0.text = text
            $0.font = UIFont.boldSystemFont(ofSize: size)
            $0.textColor = UIColor.Text.primary
        })
        return label
    }
    
    static func makeScrollView(isScrollEnabled: Bool = false, isPagingEnabled: Bool = true) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = isScrollEnabled
        scrollView.isPagingEnabled = isPagingEnabled
        scrollView.backgroundColor = .clear
        return scrollView
    }
    
    static func makeCardView(cornerRadius: CGFloat, bgColor: UIColor = .white) -> UIView {
        let view = UIView()
        view.backgroundColor = bgColor
        view.layer.cornerRadius = cornerRadius
        view.clipsToBounds = true
        return view
    }
    
    static func makeInsetGroupedTableView() -> UITableView {
        return UITableView(frame: .zero, style: .insetGrouped)
    }
}
