//
//  QuietTheme.swift
//  Quiet
//
//  Central visual identity for the Quiet demo. Change the accent here (and in
//  the AccentColor asset) and it updates everywhere it is referenced.
//

import UIKit

enum QuietTheme {

    /// Brand accent — #2E6FF2. Prefers the asset-catalog color when present.
    static let accent: UIColor = UIColor(named: "AccentColor")
        ?? UIColor(red: 46/255, green: 111/255, blue: 242/255, alpha: 1)

    static var background: UIColor {
        if #available(iOS 13.0, *) { return .systemBackground }
        return .white
    }

    static var primaryText: UIColor {
        if #available(iOS 13.0, *) { return .label }
        return .black
    }

    static var secondaryText: UIColor {
        if #available(iOS 13.0, *) { return .secondaryLabel }
        return UIColor(white: 0.4, alpha: 1)
    }

    /// Neutral fill for the inactive power button.
    static var inactiveFill: UIColor {
        if #available(iOS 13.0, *) { return .secondarySystemFill }
        return UIColor(white: 0.92, alpha: 1)
    }
}
