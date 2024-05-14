//
//  UICollectionView+Helper.swift
//  SampleApp
//
//  Created by Daniel Velikov on 14.05.24.
//

import UIKit

typealias CollectionViewDelegate = UICollectionViewDataSource & UICollectionViewDelegate

extension UICollectionView {
    var flowLayout: UICollectionViewFlowLayout? { collectionViewLayout as? UICollectionViewFlowLayout }
    
    func registerCell<T: UICollectionViewCell>(_ type: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.identifier)
    }
    
    func registerCellNib<T: UICollectionViewCell>(_ type: T.Type) {
        register(.init(nibName: T.identifier, bundle: .main), forCellWithReuseIdentifier: T.identifier)
    }
    
    func dequeueCell<T: UICollectionViewCell>(_ type: T.Type, for index: IndexPath) -> T? {
        dequeueReusableCell(withReuseIdentifier: T.identifier, for: index) as? T
    }
}
