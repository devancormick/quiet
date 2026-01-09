//
//  UIStackView+Ext.swift
//  Quiet
//
//  Created by Alexander Parshakov on 12/5/22
//  Copyright © 2022 Quiet Inc. All rights reserved.
// 

import UIKit

extension UIStackView {
    
    func clear() {
        arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
}
