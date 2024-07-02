//
//  UiViewController+.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 15/01/2024.
//

import UIKit
import SVProgressHUD
import iCarousel
import EasyTipView

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

extension UIViewController {
    private func dismissAllPresentedViewControllers(animated: Bool, completion: (() -> Void)? = nil) {
        if let presentedVC = self.presentedViewController {
            presentedVC.dismiss(animated: animated) {
                self.dismissAllPresentedViewControllers(animated: animated, completion: completion)
            }
        } else {
            completion?()
        }
    }

    func dimissAllViewControllers() {
        if #available(iOS 13.0, *) {
            if let rootViewController = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController {
                rootViewController.dismissAllPresentedViewControllers(animated: true)
            }
        } else {
            if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
                rootViewController.dismissAllPresentedViewControllers(animated: true)
            }
        }
    }
}

extension UIViewController {
    func setUpEasyView(tipView: inout EasyTipView) {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.dimissTipView))
        self.view.addGestureRecognizer(gesture)

        var preferences = EasyTipView.Preferences()
        preferences.drawing.font = .systemFont(ofSize: 14)
        preferences.drawing.foregroundColor = .white
        preferences.drawing.backgroundColor = .c242424!
        preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.bottom
        tipView = EasyTipView(text: "Ưu đãi có giá trị sử dụng đến 23:59 căn cứ theo giờ Việt Nam (GMT+7) và theo hệ thống LYNKID.", preferences: preferences)
    }

    @objc func dimissTipView(sender: UITapGestureRecognizer) {
        for v in self.view.subviews {
            if let v = v as? EasyTipView {
                v.dismiss()
                return
            }
        }
    }
}

extension UIViewController {

    func setUpCarousel(carousel: iCarousel, cornerRadius: CGFloat = 0) {
        carousel.type = .linear
        carousel.layer.masksToBounds = false
        carousel.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        carousel.layer.cornerRadius = cornerRadius
        carousel.scrollToItem(at: 0, animated: true)
        carousel.isPagingEnabled = true
    }
}
