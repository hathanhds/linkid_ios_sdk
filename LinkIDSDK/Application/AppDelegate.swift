//
//  AppDelegate.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 12/01/2024.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var navigator = Navigator()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // MARK: - setup
        NetworkManager.shared.startListening()
        AppAppearance.setupAppearance()
        IQKeyboardManager.shared.enable = true

        let userInfo: _UserInfo = {
            let type = ConnectedStatusType.existAndConnected
            switch type {
            case .existAndConnected:
                return _UserInfo(phoneNumber: "0866400192", cif: "1400192", name: "Nguyễn Hà Thanh")
            case .existAndNotConnected:
                return _UserInfo(phoneNumber: "0920231123", cif: "5281340", name: "Nguyễn Hà Thanh")
            case .notExistAndConnected:
                return _UserInfo(phoneNumber: "0333123323", cif: "8991829", name: "Nguyễn Hà Thanh")
            case .notExistAndNotConnected:
                return _UserInfo(phoneNumber: "0358513333", cif: "1111111", name: "Nguyễn Hà Thanh")
            }
        }()

        let parnerCode = "218"
        let merchantName = "VPBank"

        AppConfig.shared.cif = userInfo.cif
        AppConfig.shared.phoneNumber = userInfo.phoneNumber
        AppConfig.shared.userName = userInfo.name
        AppConfig.shared.partnerCode = parnerCode
        AppConfig.shared.merchantName = merchantName

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = { [weak self] in
            guard let self = self else { return UIViewController() }
            let vc = LaunchScreenViewController.create(with: Navigator(), viewModel: LaunchScreenViewModel(authenRepository: AuthRepositoryImp()))
//            let vc = PhysicalRewardDetailViewController.create(with: Navigator(), viewModel: PhysicalRewardDetailViewModel(myRewardRepository: MyrewardRepositoryImpl(), giftTransactionCode: ""))

//            let vc = MainTabBarController.create(with: Navigator(), viewModel: MainTabBarViewModel())
            return UINavigationController(rootViewController: vc)
        }()
        self.window?.makeKeyAndVisible()

        return true
    }
}

enum ConnectedStatusType {
    case existAndConnected
    case existAndNotConnected
    case notExistAndConnected
    case notExistAndNotConnected
}

struct _UserInfo {
    var phoneNumber: String
    var cif: String
    var name: String

    init(phoneNumber: String, cif: String, name: String) {
        self.phoneNumber = phoneNumber
        self.cif = cif
        self.name = name
    }
}


