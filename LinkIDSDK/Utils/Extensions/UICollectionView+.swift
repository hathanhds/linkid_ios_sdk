//
//  UICollectionView+.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 24/01/2024.
//

import UIKit

extension UICollectionView {

    func dequeueCell<T: UICollectionViewCell>(ofType type: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as! T
    }

    func registerCellFromNib<T: UICollectionViewCell>(ofType type: T.Type) {
        let id = String(describing: T.self)
        self.register(UINib(nibName: id, bundle: UIStoryboard.bundle), forCellWithReuseIdentifier: id)
    }

    func isValid(indexPath: IndexPath) -> Bool {
        guard indexPath.section < numberOfSections,
            indexPath.row < numberOfItems(inSection: indexPath.section)
            else { return false }
        return true
    }
}


