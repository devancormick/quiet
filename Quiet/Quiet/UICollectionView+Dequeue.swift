//
//  UICollectionView+Dequeue.swift
//  Quiet
//
//  Created by Alexander Parshakov on 9/5/22
//  Copyright © 2022 Quiet Inc. All rights reserved.
// 

import UIKit

protocol Dequeuable: UIView {
    static var dequeuableId: String { get }
}

extension UICollectionView {
    func dequeueCell<T>(for: T, indexPath: IndexPath) -> T? where T : Dequeuable {
        return dequeueReusableCell(withReuseIdentifier: T.dequeuableId, for: indexPath) as? T
    }
}
