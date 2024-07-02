//
//  TransactionHistoryViewController.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 15/01/2024.
//  Copyright (c) 2024 All rights reserved.
//

import UIKit
import RxSwift
import Tabman
import Pageboy

class TransactionHistoryViewController: TabmanViewController {

    private var navigator: Navigator!
    private var viewModel: TransactionHistoryViewModel!
    var gradientView: UIView?
    var gradientImageView: UIImageView?

    class func create(with navigator: Navigator, viewModel: TransactionHistoryViewModel) -> TransactionHistoryViewController {
        let vc = UIStoryboard.transactionHistory.instantiateViewController(ofType: TransactionHistoryViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc as! Self
    }

    private var viewControllers: [BaseViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.input.viewDidLoad.onNext(())
        initView()
        initTabView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar(isTransparent: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setupNavigationBar(isTransparent: false)
    }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupGradientViewBehindBars()
    }

    func setupNavigationBar(isTransparent: Bool) {
        guard let navigationBar = navigationController?.navigationBar else { return }
        if #available(iOS 15, *) {

            if(isTransparent == true) {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithTransparentBackground()
                // Set the title text attributes for a white color in the appearance object
                appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
                navigationBar.standardAppearance = appearance
                navigationBar.compactAppearance = appearance // For iPhone small navigation bar in landscape.
                navigationBar.scrollEdgeAppearance = appearance // For large title navigation bar.
            } else {
                navigationBar.standardAppearance = UINavigationBarAppearance()
                navigationBar.compactAppearance = UINavigationBarAppearance()
                navigationBar.scrollEdgeAppearance = UINavigationBarAppearance()
            }
        }
    }



    func setupGradientViewBehindBars() {
        // The gradient will cover the navigation bar and the Tabman bar
        let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let navigationBarHeight = navigationController?.navigationBar.frame.height ?? 0
        let tabmanBarHeight: CGFloat = 48 // Adjust if you have a custom size for Tabman bar

        if(gradientView != nil || gradientImageView != nil) {
            gradientImageView?.removeFromSuperview()
            gradientView?.removeFromSuperview()
        }

        gradientView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: statusBarHeight + navigationBarHeight + tabmanBarHeight))
        gradientImageView = UIImageView(frame: gradientView!.bounds)
        gradientImageView?.image = .imageByHeaderMyreward
        gradientView?.addSubview(gradientImageView!)
        // Place the gradient view behind all other views
        view.addSubview(gradientView!)
        view.sendSubviewToBack(gradientView!)
    }

    func initView() {
        self.title = "Lịch sử giao dịch"
        viewControllers = [
            TransactionHistoryChildViewController.create(with: self.navigator, viewModel: TransactionHistoryChildModel(selectedTab: .all, transactionRepository: ListTransactionRepositoryImp())),
            TransactionHistoryChildViewController.create(with: self.navigator, viewModel: TransactionHistoryChildModel(selectedTab: .earn, transactionRepository: ListTransactionRepositoryImp())),
            TransactionHistoryChildViewController.create(with: self.navigator, viewModel: TransactionHistoryChildModel(selectedTab: .exchange, transactionRepository: ListTransactionRepositoryImp())),
            TransactionHistoryChildViewController.create(with: self.navigator, viewModel: TransactionHistoryChildModel(selectedTab: .used, transactionRepository: ListTransactionRepositoryImp())),
        ];
    }


    func initTabView() {
        self.dataSource = self

        // Create bar
        let bar = TMBar.ButtonBar()
        bar.backgroundView.style = .clear // Makes the background clear // Set your custom background color
        bar.layout.transitionStyle = .snap // How the bar changes between tabs
        bar.layout.contentMode = .fit // Other options include .intrinsic

        // Customize the bar buttons
        bar.buttons.customize { (button) in
            button.tintColor = .white // Color for non-selected items
            button.selectedTintColor = .cFFCC00 // Color for selected item
            button.font = UIFont(name: "BeVietnamPro-Regular", size: 14.0)! // Choose your font here
            button.selectedFont = UIFont(name: "BeVietnamPro-SemiBold", size: 14.0)! // Choose your selected item font here
        }

        // Customize the bar indicator
        bar.indicator.tintColor = .cFFCC00 // Set to the color you require
        bar.indicator.weight = .custom(value: 2) // Set your desired indicator height

        // Customize the spacing and insets if necessary
        bar.layout.interButtonSpacing = 20 // Set the space between the buttons if needed
        bar.layout.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10) // Adjust the insets

        // Add the bar to the view controller
        addBar(bar, dataSource: self, at: .top)
    }
}

extension TransactionHistoryViewController: PageboyViewControllerDataSource, TMBarDataSource {

    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }

    func viewController(for pageboyViewController: PageboyViewController,
        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }

    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        var title = ""
        if(index == 0) {
            title = "Tất cả"
        } else if(index == 1) {
            title = "Tích điểm"
        } else if(index == 2) {
            title = "Đổi điểm"
        } else if(index == 3) {
            title = "Dùng điểm"
        }
        return TMBarItem(title: title)
    }
}
