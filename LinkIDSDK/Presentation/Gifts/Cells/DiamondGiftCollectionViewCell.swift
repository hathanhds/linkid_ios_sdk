//
//  DiamondGiftCollectionViewCell.swift
//  LinkIDApp
//
//  Created by Phan Tuan Anh on 24/06/2024.
//

import UIKit

class DiamondGiftCollectionViewCell: UICollectionViewCell{
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var contentContainerView: UIView!
    @IBOutlet weak var discountPercentButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbImageView.layer.masksToBounds = true
        thumbImageView.layer.cornerRadius = 12
        thumbImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]

        contentContainerView.backgroundColor = .c332D2E
        contentContainerView.layer.masksToBounds = true
        contentContainerView.layer.cornerRadius = 12
//        discountPercentButton.layer.cornerRadius = 8
//        discountPercentButton.layer.maskedCorners = [.layerMinXMaxYCorner]
//        discountPercentButton.layer.masksToBounds = false
    }
    


    func setDataForCell(data: GiftInfor) {
        thumbImageView.setSDImage(with: data.imageLink?.first?.fullLink ?? "")

        brandLabel.text = data.brandName
        titleLabel.text = data.name
        priceLabel.text = data.requiredCoin?.formatter()
       


    }
    
}
