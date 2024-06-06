//
//  BaseViewController.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 28/01/2024.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {

    var navigator: Navigator!
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkNetwork()
        self.initView()
        self.setUpData()
        self.bindToView()
        self.bindToViewModel()
    }

    func initView() {
    }

    func setUpData() { }

    func bindToView() { }

    func bindToViewModel() { }

    func checkNetwork () {
        NotificationCenter.observe(name: .networkIsConnected) { _ in
            self.hidePopup()
        }

        NotificationCenter.observe(name: .networkIsNotConnected) { _ in
            self.showPopup()
        }
    }

    @objc func showPopup() {
        navigator.show(segue: .popup(type: .noOption, title: "Mất kết nối mạng", message: "Vui lòng kiểm tra lại", image: .imageMascotError!)) { [weak self] vc in
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self?.navigationController?.present(vc, animated: true)
        }
    }

    @objc func hidePopup() {
        self.dismissViewController()
    }

    func dismissViewController(animated flag: Bool = true, completion: (() -> Void)? = nil) {
        self.navigationController?.dismiss(animated: flag, completion: completion)
    }

    func pop() {
        self.navigationController?.popViewController(animated: true)
    }

    func addBackButton(withIcon icon: UIImage? = .icBackBtn, color: UIColor? = .mainColor, selector: Selector? = #selector(BaseViewController.performBack)) {

        self.navigationController?.navigationBar.backIndicatorImage = icon
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = icon
        self.navigationController?.navigationBar.setGradientBackground(colors: [.c591C90!, .c971ACC!])


        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: icon, style: .plain, target: self, action: selector)
    }

    @objc func performBack() {
        self.navigationController?.popViewController(animated: true)
    }

    func addRightBarButtonWith(image: UIImage?, title: String? = nil, selector: Selector) {
        self.navigationController?.navigationBar.setGradientBackground(colors: [.c591C90!, .c971ACC!])
        if let image = image {
            self.navigationController?.navigationBar.backIndicatorImage = image
            self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = image
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: selector)
            self.navigationController?.navigationBar.tintColor = .white
            return
        }

        if let rightTitle = title {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: rightTitle, style: .plain, target: self, action: selector)
        }
    }


}

