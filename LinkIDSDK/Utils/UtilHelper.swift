//
//  UtilHelper.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 21/05/2024.
//

import UIKit

class UtilHelper {
    
    static func openURL(urlString: String) {
        if let url = URL(string: urlString) {
            if UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            } else {
                print("open error")
            }
        }
    }

    static func openPhoneCall(number: String) {
        openURL(urlString: "tel://\(number)")
    }

    static func openEmail(email: String) {
        openURL(urlString: "mailto://\(email)")
    }
    
    static var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }

    // Screen height.
    static var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
}
