//
//  InlineInitSystemExtension.swift
//  crypto_app
//
//  Created by Petru-Alexandru Lipici on 07.11.2022.
//

import UIKit

extension UIView {
    @objc convenience init(_ block: @escaping (UIView) -> Void) {
        self.init()
        block(self)
    }
}

extension UIButton {
    @objc convenience init(_ block: @escaping (UIButton) -> Void) {
        self.init()
        block(self)
    }
}

extension UIStackView {
    @objc convenience init(block: (UIStackView)->Void) {
        self.init()
        block(self)
    }
}

extension UILabel {
    @objc convenience init(block: @escaping (UILabel)->Void) {
        self.init()
        block(self)
    }
}

extension UIImageView {
    @objc convenience init(block: @escaping (UIImageView) -> Void) {
        self.init()
        block(self)
    }
}

extension UIScrollView {
    @objc convenience init(block: @escaping (UIScrollView) -> Void) {
        self.init()
        block(self)
    }
}
