//
//  MyCellCollectionViewCell.swift
//  CollectionViewLayout
//
//  Created by David Perez on 1/8/19.
//  Copyright © 2019 David Perez P. All rights reserved.
//

import UIKit

final class MyCellCollectionViewCell: UICollectionViewCell {
    
     var label: UILabel = {
       let l = UILabel(frame: .zero)
        l.textAlignment = .center
        l.textColor = .white
        l.font.withSize(30)
        l.backgroundColor = .clear
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    var img: UIImageView = {
       let i = UIImageView()
        let image = UIImage()
        i.image = image
        i.contentMode = UIView.ContentMode.scaleAspectFill
        i.alpha = 0.9
        i.translatesAutoresizingMaskIntoConstraints = false
        return i
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews(){
        self.contentView.addSubview(img)
        self.contentView.addSubview(label)
       
        NSLayoutConstraint.activate([
            img.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            img.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            img.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            img.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            label.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            ])
       
        self.clipsToBounds = true
        self.contentView.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        fatalError("awake from nib has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.label.text = "nil"
    }
    
}
