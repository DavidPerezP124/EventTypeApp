//
//  CollectionViewFlow.swift
//  CollectionViewLayout
//
//  Created by David Perez on 1/8/19.
//  Copyright © 2019 David Perez P. All rights reserved.
//

import UIKit

final class CollectionViewFlow: UICollectionView {

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(frame: frame, collectionViewLayout: layout)
        backgroundColor = .white
        
        register(MyCellCollectionViewCell.self, forCellWithReuseIdentifier: "MyCellCollectionViewCell")
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
