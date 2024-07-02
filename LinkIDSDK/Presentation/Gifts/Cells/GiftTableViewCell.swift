//
//  GiftTableViewCell.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 28/02/2024.
//

import UIKit

class GiftTableViewCell: UITableViewCell {


    @IBOutlet weak var giftImageView: UIImageView!
    @IBOutlet weak var discountPercentButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var fullPriceLabel: UILabel!

    @IBOutlet weak var contentContainerView: UIView!


    override func awakeFromNib() {
        super.awakeFromNib()
        self.fullPriceLabel.strikeThrough()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        giftImageView.layer.masksToBounds = true
        giftImageView.layer.cornerRadius = 12
        giftImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]

        contentContainerView.layer.masksToBounds = false
        contentContainerView.layer.cornerRadius = 12
        contentContainerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        contentContainerView.layer.borderWidth = 1
        contentContainerView.layer.borderColor = UIColor.cEFEFF6?.cgColor

        discountPercentButton.layer.cornerRadius = 8
        discountPercentButton.layer.maskedCorners = [.layerMinXMaxYCorner]
        discountPercentButton.layer.masksToBounds = false
    }

    func setDataForCell(data: GiftInfoItem) {
        giftImageView.setSDImage(with: data.imageLink?.first?.fullLink ?? "")
        let giftInfor = data.giftInfor

        let giftDiscountInfor = data.giftDiscountInfor;
        let fullPrice = giftInfor?.fullPrice ?? 0;
        let requiredCoin = giftInfor?.requiredCoin;
        let salePrice = giftDiscountInfor?.salePrice;
        let displayPrice = salePrice ?? requiredCoin ?? 0;
        let reductionRateDisplay = Int(giftDiscountInfor?.reductionRateDisplay ??
            giftInfor?.discountPrice ??
            0)
        let isShowDiscount = reductionRateDisplay > 0;

        discountPercentButton.setTitle("- \(reductionRateDisplay)%", for: .normal)
        discountPercentButton.isHidden = reductionRateDisplay == 0
        priceLabel.text = displayPrice.formatter()
        fullPriceLabel.text = fullPrice.formatter()
        fullPriceLabel.isHidden = fullPrice - displayPrice <= 0
        titleLabel.text = giftInfor?.name
    }

}
