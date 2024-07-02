//
//  UIImage+.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 16/01/2024.
//

import UIKit

extension UIImage {
    // MARK: - TabBar
    static let icTabHomeActive = UIImage(imageName: "ic_home_active")
    static let icTabHomeInActive = UIImage(imageName: "ic_home_inactive")
    static let icTabMyRewardActive = UIImage(imageName: "ic_reward_active")
    static let icTabMyrewardInactive = UIImage(imageName: "ic_reward_inactive")
    static let icTabTransaction = UIImage(imageName: "ic_transaction")
    static let icTabUserInfoActive = UIImage(imageName: "ic_account_active")
    static let icTabUserInfoInactive = UIImage(imageName: "ic_account_inactive")

    // MARK: - Placeholder
    static let imgLinkIDPlaceholder = UIImage(imageName: "img_placeholder")
    static let imgAvatarDefault = UIImage(imageName: "img_mascot_avatar_default")

    // MARK: - Home
    static let icHomeEyeOpen = UIImage(imageName: "ic_eye_open")
    static let icHomeEyeOff = UIImage(imageName: "ic_eye_off")

    // MARK: - Common
    static let imgEmptyGift = UIImage(imageName: "img_empty_gifts")
    static let icBackBtn = UIImage(imageName: "ic_back")
    static let iconCheckCircleWhite = UIImage(imageName: "ic_check_circle_white")
    static let iconWarning = UIImage(imageName: "ic_warning")
    static let imageMascotError = UIImage(imageName: "img_mascot_error")
    static let imageMascotSmallDefault = UIImage(imageName: "img_mascot_small_default")
    static let imageLogo = UIImage(imageName: "img_logo")
    static let imageMascotOTP = UIImage(imageName: "img_mascot_otp")
    static let iconAppPlaceholder = UIImage(imageName: "ic_app_placeholder")

    static let imageCopyWhite = UIImage(imageName: "ic_copy_white")
    static let imageCopyGray = UIImage(imageName: "ic_copy_gray")
    static let imageLocationWhite = UIImage(imageName: "ic_location_white")
    static let imageLocationGray = UIImage(imageName: "ic_location_gray")

    // MARK: - Gift
    static let icGiftSortAsc = UIImage(imageName: "ic_sort_asc")
    static let icGiftSortDesc = UIImage(imageName: "ic_sort_desc")
    static let icGiftCheckBoxOutline = UIImage(imageName: "ic_check_box_outline")
    static let icGiftCheckedBox = UIImage(imageName: "ic_checked_box")
    static let icSearchGift = UIImage(imageName: "ic_search")
    static let imgGiftMap = UIImage(imageName: "img_map")
    static let icGiftCheckCircleWhite = UIImage(imageName: "ic_check_circle_white")
    static let iconArrowToSwipe = UIImage(imageName: "ic_arrow_to_swipe")
    
    // MARK: Reward
    static let imageByHeaderMyreward = UIImage(imageName: "by_header_myreward")

    // MARK: - Diamond
    static let icBackDiamondBtn = UIImage(imageName: "ic_back_diamond")
    static let icSearchDiamondBtn = UIImage(imageName: "ic_search_diamond")
    static let icDiamondOptionSelectedBtn = UIImage(imageName: "ic_diamond_option_selected")
    static let icDiamondOptionUnselectedBtn = UIImage(imageName: "ic_diamond_option_unselected")
    static let imageBgHeaderDiamond = UIImage(imageName: "bg_header_diamond")
    

}

extension UIImage {
    convenience init?(imageName: String) {
        let bundle = Bundle(for: LaunchScreenViewController.self)
        self.init(named: imageName, in: bundle, compatibleWith: nil)
    }
}


extension UIImage {
    func blendWithColor(color: UIColor = .gray, blendMode: CGBlendMode = .saturation) -> UIImage? {
        let rect = CGRect(origin: CGPoint.zero, size: self.size)

        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }

        // Fill the context with the background color
        context.setFillColor(color.cgColor)
        context.fill(rect)

        // Draw the original image with the specified blend mode
        self.draw(in: rect, blendMode: blendMode, alpha: 1.0)

        // Get the blended image
        let blendedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return blendedImage
    }

    func applyColorFilter(color: UIColor = .gray) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }

        let ciImage = CIImage(cgImage: cgImage)

        guard let filter = CIFilter(name: "CIColorMonochrome") else { return nil }
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(CIColor(color: color), forKey: kCIInputColorKey)
        filter.setValue(1.0, forKey: kCIInputIntensityKey)

        guard let outputImage = filter.outputImage else { return nil }

        let context = CIContext(options: nil)
        guard let outputCGImage = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }

        return UIImage(cgImage: outputCGImage)
    }

}
