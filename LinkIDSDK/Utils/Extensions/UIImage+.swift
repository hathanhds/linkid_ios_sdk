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
    static let imgMascotSmallDefault = UIImage(imageName: "image_mascot_small_default")
    static let imgLinkIDPlaceholder = UIImage(imageName: "img_placeholder")
    static let imgAvatarDefault = UIImage(imageName: "img_mascot_avatar_default")

    // MARK: - Home
    static let icHomeEyeOpen = UIImage(imageName: "ic_eye_open")
    static let icHomeEyeOff = UIImage(imageName: "ic_eye_off")

    // MARK: - Common
    static let imgEmptyGift = UIImage(imageName: "img_empty_gifts")
    static let icBackBtn = UIImage(imageName: "ic_back")
    static let iconCheckCircleWhite = UIImage(imageName: "ic_check_circle_white")
    static let imageMascotError = UIImage(imageName: "img_mascot_error")
    

    // MARK: - Gift
    static let icGiftSortAsc = UIImage(imageName: "ic_sort_asc")
    static let icGiftSortDesc = UIImage(imageName: "ic_sort_desc")
    static let icGiftCheckBoxOutline = UIImage(imageName: "ic_check_box_outline")
    static let icGiftCheckedBox = UIImage(imageName: "ic_checked_box")
    static let icSearchGift = UIImage(imageName: "ic_search")
    static let imgGiftMap = UIImage(imageName: "img_map")
    static let icGiftCheckCircleWhite = UIImage(imageName: "ic_check_circle_white")
}

extension UIImage {
    convenience init?(imageName: String) {
        let bundle = Bundle(for: LaunchScreenViewController.self)
        self.init(named: imageName, in: bundle, compatibleWith: nil)
    }
}
