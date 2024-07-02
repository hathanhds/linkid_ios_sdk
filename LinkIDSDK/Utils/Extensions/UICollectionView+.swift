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
    
    func dequeueHeaderFooterView<T: UICollectionReusableView>(ofKind kind: String, withIdentifier identifier: String, for indexPath: IndexPath) -> T {
        guard let view = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Could not dequeue view with identifier: \(identifier) or it couldn't be cast to \(T.self)")
        }
        return view
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

