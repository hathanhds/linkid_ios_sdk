//
//  AccountExistAndNotConnectedViewController.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 14/03/2024.
//

import Foundation
import UIKit

// Tồn tại tài khoản với SĐT X từ App chủ
// SĐT X chưa có liên kết LID

class AccountExistAndNotConnectedViewController: BaseViewController, ViewControllerType {
    typealias ViewModel = AccountExistAndNotConnectedViewModel

    static func create(with navigator: Navigator, viewModel: AccountExistAndNotConnectedViewModel) -> Self {
        let vc = UIStoryboard.auth.instantiateViewController(ofType: AccountExistAndNotConnectedViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc as! Self
    }

    var viewModel: AccountExistAndNotConnectedViewModel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var merchantImageView: UIImageView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        continueButton.setCommonGradient()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavigationBar()
    }

    override func initView() {
        titleLabel.text = "Đăng nhập bằng \(AppConfig.shared.merchantName)"
        userNameLabel.text = AppConfig.shared.userName
        phoneNumberLabel.text = AppConfig.shared.phoneNumberFormatter
    }

    @IBAction func closeAction(_ sender: Any) {
        // TODO: close APP
    }

    @IBAction func skipAction(_ sender: Any) {
        AppConfig.shared.viewMode = .anonymous
        self.navigator.show(segue: .main) { [weak self] vc in
            vc.modalPresentationStyle = .fullScreen
            self?.present(vc, animated: true)
        }
    }

    @IBAction func continueAction(_ sender: Any) {
        AppConfig.shared.viewMode = .authenticated
        self.navigator.show(segue: .main) { [weak self] vc in
            vc.modalPresentationStyle = .fullScreen
            self?.present(vc, animated: true)
        }
    }

}

