//
//  UIApplication+Extension.swift
//  Quiet
//
//  Created by Aliaksandr Dvoineu on 3.05.23.
//  Copyright © 2023 Quiet Inc. All rights reserved.
//

import UIKit

extension UIApplication {

    class func getTopMostViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        } else {
            return nil
        }
    }
}
