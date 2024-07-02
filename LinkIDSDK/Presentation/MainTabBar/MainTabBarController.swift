//
//  MainTabBarViewController.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 15/01/2024.
//  Copyright (c) 2024 All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    var viewModel: MainTabBarViewModel!
    var navigator: Navigator!

    class func create(with navigator: Navigator, viewModel: MainTabBarViewModel) -> MainTabBarController {
        let vc = UIStoryboard.main.instantiateViewController(ofType: MainTabBarController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureUI()
    }

    private func setUpViews() {
        self.delegate = self
        // Home
        let homeVC = HomeViewController.create(with: navigator,
            viewModel: HomeViewModel(newsRepository: NewsRepositoryImpl(),
                giftsRepository: GiftsRepositoryImpl(),
                userRepository: UserRepositoryImpl())
        )
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.tabBarItem = UITabBarItem(title: "Trang chủ",
            image: .icTabHomeInActive?.withRenderingMode(.alwaysOriginal),
            selectedImage: .icTabHomeActive?.withRenderingMode(.alwaysOriginal))

        let viewMode = AppConfig.shared.viewMode
        // MyReward
        let myRewardVC = viewMode == .anonymous ? AnonymousViewController.create(with: self.navigator, viewModel: AnonymousViewModel())
        : MyRewardViewController.create(with: self.navigator, viewModel: MyRewardViewModel(giftsRepository: GiftsRepositoryImpl()))
        let myrewardNav = UINavigationController(rootViewController: myRewardVC)
        myrewardNav.navigationBar.isHidden = false
        myrewardNav.tabBarItem = UITabBarItem(title: "Quà của tôi",
            image: .icTabMyrewardInactive?.withRenderingMode(.alwaysOriginal),
            selectedImage: .icTabMyRewardActive?.withRenderingMode(.alwaysOriginal))

        // Transaction History
        let transactionHistoryVC = viewMode == .anonymous ? AnonymousViewController.create(with: self.navigator, viewModel: AnonymousViewModel())
        : TransactionHistoryViewController.create(with: self.navigator, viewModel: TransactionHistoryViewModel(merchantRepository: MerchantRepositoryImp()))
        let transactionHistoryNav = UINavigationController(rootViewController: transactionHistoryVC)
        transactionHistoryNav.navigationBar.isHidden = false
        transactionHistoryNav.tabBarItem = UITabBarItem(title: "Lịch sử",
            image: .icTabTransaction?.withRenderingMode(.alwaysOriginal),
            selectedImage: .icTabTransaction?.withRenderingMode(.alwaysTemplate))
        // UserInfo
        let userInfoNav = UINavigationController(rootViewController: UIViewController())
        userInfoNav.navigationBar.isHidden = true
        userInfoNav.tabBarItem = UITabBarItem(title: "Tài khoản",
            image: .icTabUserInfoInactive?.withRenderingMode(.alwaysOriginal),
            selectedImage: .icTabUserInfoActive?.withRenderingMode(.alwaysOriginal))


        self.viewControllers = [homeNav, myrewardNav, transactionHistoryNav, userInfoNav]

    }

    func configureUI() {
        self.tabBar.tintColor = .mainColor
        self.tabBar.backgroundColor = .white
        self.tabBar.unselectedItemTintColor = .cA7A7B3
        self.view.backgroundColor = .white

        self.tabBar.layer.masksToBounds = false
        self.tabBar.layer.cornerRadius = 20
        self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.tabBar.isTranslucent = false

        self.tabBar.layer.shadowColor = UIColor.black.cgColor
        self.tabBar.layer.shadowOffset = CGSize(width: 0, height: -8.0)
        self.tabBar.layer.shadowOpacity = 0.13
        self.tabBar.layer.shadowRadius = 20
    }

}

extension MainTabBarController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.title == "Tài khoản" {
            self.navigator.show(segue: .installAppPopup) { [weak self] vc in
                guard let self = self else { return }
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }

        }
    }
}
