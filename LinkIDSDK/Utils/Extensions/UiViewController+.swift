//
//  UiViewController+.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 15/01/2024.
//

import UIKit
import SVProgressHUD

extension UIViewController {

    func hideNavigationBar(animated: Bool = false) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    func showNavigationBar(animated: Bool = false) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

extension UIViewController {

    func showLoading() {
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setForegroundColor(.mainColor!)
        SVProgressHUD.setBackgroundColor(.clear)
        SVProgressHUD.setBackgroundLayerColor(.clear)
        SVProgressHUD.setRingThickness(4)
        SVProgressHUD.setCornerRadius(26)
        SVProgressHUD.show()
        self.view.endEditing(true)
    }

    func hideLoading() {
        SVProgressHUD.dismiss()
    }
}

extension UIViewController {

    @discardableResult
    func showToast(ofType type: ToastType, withMessage message: String?, dismissOtherToasts: Bool = false, topOffset: CGFloat? = nil, afterSeconds seconds: TimeInterval? = nil) -> ToastView {
        let toast = ToastView(type: type, message: message)
        if let topOffset = topOffset {
            toast.navBarHeight = topOffset
        } else if let navBar = (self as? UINavigationController)?.navigationBar ?? self.navigationController?.navigationBar, !navBar.isHidden {
            toast.navBarHeight = navBar.frame.height
        }
        if let seconds = seconds, seconds > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [weak self] in
                guard let self = self else { return }
                if dismissOtherToasts {
                    self.dismissAllToasts(animated: false)
                }
                toast.show(self.view)
            }
        } else {
            if dismissOtherToasts {
                self.dismissAllToasts(animated: false)
            }
            toast.show(self.view)
        }
        return toast
    }

    func dismissAllToasts(animated: Bool = true) {
        self.view.subviews.forEach { v in
            if let v = v as? ToastView {
                v.dismiss(animated: animated)
            }
        }
    }

}
