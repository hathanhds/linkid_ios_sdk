//
//  UtilHelper.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 21/05/2024.
//

import UIKit
import CoreImage

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

    static func callHotLine() {
        openPhoneCall(number: AppConfig.shared.hotLine)
    }

    static var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }

    // Screen height.
    static var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }

    static func copyToClipboard(text: String, completion: (() -> Void)? = nil) {
        UIPasteboard.general.string = text
        completion?()
    }
}

extension UtilHelper {
    static func heightForLabel(text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.height)
    }
}

extension UtilHelper {
    static func openGoogleMap(navigator: Navigator, parentVC: UIViewController, address: String) {
        UtilHelper.copyToClipboard(text: address)
        navigator.show(segue: .popup(
            dismissable: true,
            type: .twoOption,
            title: "Truy cập Google Map",
            message: "Coppy địa chỉ thành công. Bạn có muốn mở ứng dụng Google Maps để xem địa chỉ không?",
            image: .imgGiftMap!,
            confirmnButton: (title: "Đống ý", action: {
                UtilHelper.openURL(urlString: "https://www.google.com/maps/dir/?api=1&destination=\(address)")
            }),
            cancelButton: (title: "Huỷ", action: nil)
            )) { vc in
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            parentVC.navigationController?.present(vc, animated: true)
        }
    }
}

extension UtilHelper {

    static func showAPIErrorPopUp(navigator: Navigator, parentVC: UIViewController, title: String = "Có lỗi xảy ra", message: String) {
        navigator.show(segue: .popup(
            dismissable: true,
            type: .oneOption,
            title: title,
            message: message,
            image: .imageMascotError!,
            confirmnButton: (title: "Đống ý", action: nil)
            )) { vc in
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            parentVC.navigationController?.present(vc, animated: true)
        }
    }
}

extension UtilHelper {
    static func formatDate(date: String?, toFormatter: DateFormatterType = .HHmmddMMyyyy) -> String {
        if let date = date {
            let dateFormatter1 = Date.init(fromString: date, formatter: .yyyyMMddThhmmss)?.toString(formatter: toFormatter) ?? ""
            let dateFormatter2 = Date.init(fromString: date, formatter: .yyyyMMddThhmmssSSZ)?.toString(formatter: toFormatter) ?? ""
            if (!dateFormatter1.isEmpty) {
                return dateFormatter1
            } else {
                return dateFormatter2
            }
        }
        return ""
    }
}

extension UtilHelper {
    static func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            filter.setValue("Q", forKey: "inputCorrectionLevel")

            if let qrCodeImage = filter.outputImage {
                let transform = CGAffineTransform(scaleX: 10, y: 10)
                let scaledQRCodeImage = qrCodeImage.transformed(by: transform)

                if let cgImage = CIContext().createCGImage(scaledQRCodeImage, from: scaledQRCodeImage.extent) {
                    return UIImage(cgImage: cgImage)
                }
            }
        }

        return nil
    }
}
