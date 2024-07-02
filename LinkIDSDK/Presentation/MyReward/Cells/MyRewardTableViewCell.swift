//
//  MyRewardTableViewCell.swift
//  LinkIDApp
//
//  Created by Phan Tuan Anh on 01/04/2024.
//

import UIKit

class MyRewardTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var ticketContainerView: UIView!
    @IBOutlet weak var brandImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var lcExtraInfoWidth: NSLayoutConstraint!
    @IBOutlet weak var lcExtraInfoBottomToItemDescTop: NSLayoutConstraint!
    @IBOutlet weak var lcItemDescTopToSuperViewTop: NSLayoutConstraint!
    @IBOutlet weak var lbExtraInfo: UILabel!
    @IBOutlet weak var vExtraInfo: UIView!
    @IBOutlet weak var btnUseNow: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        brandImageView.layer.cornerRadius = 32
        brandImageView.layer.masksToBounds = true
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
//        DispatchQueue.main.async { [self] in
        // The layout pass is complete, frames should now be accurate
        ticketContainerView.drawTicket(
            directionHorizontal: true,
            withCutoutRadius: 8,
            andCornerRadius: 12,
            fillColor: nil,
            andFrame: CGRect(x: 0, y: 0, width: self.ticketContainerView.frame.size.width, height: self.ticketContainerView.frame.size.height),
            andTicketPosition: CGPointMake(80, self.ticketContainerView.frame.size.height))

//        vExtraInfo.setCommonGradient()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setLastCell(isLastCell: Bool) {
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = isLastCell ? 12 : 0
        containerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }

    func setDataForTransactionDetail(data: TransactionDetailModel) {
        containerView.backgroundColor = UIColor.white
        if let redeemQuantity = data.redeemQuantity {
            lcExtraInfoBottomToItemDescTop.priority = .defaultHigh
            lcItemDescTopToSuperViewTop.priority = .defaultLow
            vExtraInfo.setGradient(colors: [.cFFD10F!, .cFE9E32!], direction: .right)
            lcExtraInfoWidth.constant = 40
            let path = UIBezierPath(roundedRect: vExtraInfo.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 8, height: 8))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            vExtraInfo.layer.mask = mask
            lbExtraInfo.text = "x\(redeemQuantity)"
            vExtraInfo.isHidden = false
        } else {
            lcExtraInfoBottomToItemDescTop.priority = .defaultLow
            lcItemDescTopToSuperViewTop.priority = .defaultHigh
            vExtraInfo.isHidden = true
        }

        if let brandImage = data.brandImage {
            brandImageView.setSDImage(with: brandImage)
        } else {
            brandImageView.image = .imageLogo
        }

        if let giftName = data.giftName {
            nameLabel.text = giftName
        } else {
            nameLabel.text = ""
        }

        if let expiredDate = data.eGiftExpiredDate {
            if(expiredDate.isEmpty == false) {
                let date = Date.init(fromString: expiredDate, formatter: .yyyyMMddThhmmss)?.toString(formatter: .ddMMyyyy) ?? ""
                dateLabel.text = "HSD: \(date)"
            } else {
                dateLabel.text = ""
            }
        } else {
            dateLabel.text = ""
        }

        if let brandTitle = data.brandName {
            brandLabel.text = brandTitle
        } else {
            brandLabel.text = "THƯƠNG HIỆU KHÁC"
        }
    }

    func setDataForCell(data: GiftInfoItem, isUsedGift: Bool = false) {
        brandImageView.setSDImage(with: data.brandInfo?.brandImage ?? "", placeholderImage: .imageLogo)
        if (isUsedGift) {
            brandImageView.image = brandImageView.image?.applyColorFilter()
        }
        let whyhaveIt = data.giftTransaction?.whyHaveIt
        if let extraInfo = extraInfo(giftInfoItem: data) {
            lcExtraInfoBottomToItemDescTop.priority = .defaultHigh
            lcItemDescTopToSuperViewTop.priority = .defaultLow
            vExtraInfo.backgroundColor = extraInfo.color
            if (whyhaveIt == WhyHaveRewardType.received.rawValue) {
                vExtraInfo.backgroundColor = .mainColor
            }
            let path = UIBezierPath(roundedRect: vExtraInfo.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 8, height: 8))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            vExtraInfo.layer.mask = mask
            lbExtraInfo.text = extraInfo.info
            vExtraInfo.isHidden = false
        } else {
            lcExtraInfoBottomToItemDescTop.priority = .defaultLow
            lcItemDescTopToSuperViewTop.priority = .defaultHigh
            vExtraInfo.isHidden = true
        }


        if let giftName = data.giftTransaction?.giftName {
            nameLabel.text = giftName
        } else {
            nameLabel.text = ""
        }

        if let expiredDate = data.eGift?.expiredDate ?? data.giftInfor?.expireDuration {
            let date = Date.init(fromString: expiredDate, formatter: .yyyyMMddThhmmss)?.toString(formatter: .ddMMyyyy) ?? ""
            dateLabel.text = "HSD: \(date)"
        } else {
            dateLabel.text = ""
        }

        if let brandTitle = data.brandInfo?.brandName {
            brandLabel.text = brandTitle
        } else {
            brandLabel.text = "THƯƠNG HIỆU KHÁC"
        }
    }

    func extraInfo(giftInfoItem: GiftInfoItem) -> (info: String, color: UIColor?)? {
        let isEgift = giftInfoItem.eGift != nil
        let isShowReceiveReward = isEgift && (giftInfoItem.giftTransaction?.whyHaveIt ?? "") == WhyHaveRewardType.received.rawValue

        if isShowReceiveReward {
            return (info: "Quà tặng", color: UIColor.mainColor)
        } else if !isEgift {
            guard let status = giftInfoItem.giftTransaction?.status else {
                return nil
            }
            switch status {
            case "Pending", "Waiting":
                return (info: "Chờ xác nhận", color: UIColor.cFFAD33)
            case "Approved", "Confirmed":
                return (info: "Đã xác nhận", color: UIColor.c007AFF) // systemBlue
            case "Rejected", "Canceled":
                return (info: "Đã hủy", color: UIColor.cF5574E) // systemRed
            case "Delivered", "Delivering", "Returned", "Returning":
                return (info: status == "Delivering" ? "Đang giao" : (status == "Returned" ? "Đã trả hàng" : (status == "Returning" ? "Đang trả hàng" : "Đã giao hàng")), color: UIColor.c007AFF) // systemGreen
            default:
                return nil
            }
        }
        return nil
    }

    @IBAction func onClickUseNow(_ sender: Any) {

    }
}
