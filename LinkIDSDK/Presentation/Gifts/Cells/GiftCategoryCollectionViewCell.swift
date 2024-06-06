//
//  GiftCategoryCollectionViewCell.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 23/01/2024.
//

import UIKit

enum GiftCateType {
    case oneRow
    case twoRow
}

class GiftCategoryCollectionViewCell: UICollectionViewCell {


    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var fullImageView: UIImageView!

    @IBOutlet weak var highlightCateButton: UIButton!
    @IBOutlet weak var twoRowCateTitleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageContainerView: UIView!

    override class func awakeFromNib() {
        super.awakeFromNib()
    }

    func setDataForCell(cate: GiftCategory, type: GiftCateType = .oneRow, isSelectedCate: Bool = false) {

        let name = cate.name
        let isShowFullImage = name == "Diamond"
        let isCashout = cate.categoryTypeCode == "CashOut"
        highlightCateButton.isHidden = !isCashout
        // Image
        imageView.isHidden = isShowFullImage
        fullImageView.isHidden = !isShowFullImage
        if (cate.categoryTypeCode == "all") {
            imageView.image = UIImage(named: cate.fullLink!)
        } else {
            imageView.setSDImage(with: cate.fullLink, placeholderImage: .imgMascotSmallDefault)
            fullImageView.setSDImage(with: cate.fullLink, placeholderImage: .imgMascotSmallDefault)
        }
        // Title
        twoRowCateTitleLabel.text = name
        twoRowCateTitleLabel.numberOfLines = 2

        // Selected
        if (isSelectedCate) {
            self.containerView.backgroundColor = .cF0F0F4
            self.imageContainerView.backgroundColor = .white
        } else {
            self.containerView.backgroundColor = .white
            self.imageContainerView.backgroundColor = .cF0F0F4
        }
    }
}
