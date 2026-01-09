//
//  Font+Ext.swift
//  Quiet
//
//  Created by Alexander Parshakov on 11/23/22
//  Copyright © 2022 Quiet Inc. All rights reserved.
// 

import UIKit

extension UIFont {
    
    static func regularQuietFont(size: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-Regular", size: size) ?? .systemFont(ofSize: size, weight: .regular)
    }
    
    static func mediumQuietFont(size: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-Medium", size: size) ?? .systemFont(ofSize: size, weight: .medium)
    }
    
    static func semiboldQuietFont(size: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-SemiBold", size: size) ?? .systemFont(ofSize: size, weight: .semibold)
    }
    
    static func boldQuietFont(size: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-Bold", size: size) ?? .systemFont(ofSize: size, weight: .bold)
    }
}
