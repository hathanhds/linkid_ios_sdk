////
////  MyRewardListViewController.swift
////  LinkIDApp
////
////  Created by ThanhNTH on 15/01/2024.
////  Copyright (c) 2024 All rights reserved.
////
//
//import UIKit
//import RxSwift
//import Tabman
//import Pageboy
//
//class MyRewardViewController: TabmanViewController {
//
//    var navigator: Navigator!
//
//    class func create(with navigator: Navigator, viewModel: MyRewardViewModel) -> Self {
//        let vc = UIStoryboard.myReward.instantiateViewController(ofType: MyRewardViewController.self)
//        vc.navigator = navigator
//        vc.viewModel = viewModel
//        return vc as! Self
//    }
//
//    var viewModel: MyRewardViewModel!
//
//
//    private var viewControllers:[BaseViewController] = []
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        viewModel.input.viewDidLoad.onNext(())
//        initView()
//        initTabView()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        setupTransparentNavigationBar()
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        setupGradientViewBehindBars()
//    }
//
//    func setupTransparentNavigationBar() {
//        guard let navigationBar = navigationController?.navigationBar else { return }
//
//        // Set navigation bar's background to a clear image
//        navigationBar.setBackgroundImage(UIImage(), for: .default)
//        navigationBar.shadowImage = UIImage()
//        navigationBar.isTranslucent = true
//
//        // Keep the title text
//        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white] // Or any color you want
//
//
//        // For iOS 15 and later, you might need to configure the appearance as well
//        if #available(iOS 15, *) {
//            let appearance = UINavigationBarAppearance()
//            appearance.configureWithTransparentBackground()
//            // Set the title text attributes for a white color in the appearance object
//            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//
//            navigationBar.standardAppearance = appearance
//            navigationBar.compactAppearance = appearance // For iPhone small navigation bar in landscape.
//            navigationBar.scrollEdgeAppearance = appearance // For large title navigation bar.
//        }
//    }
//
//    func setupGradientViewBehindBars() {
//
//        // The gradient will cover the navigation bar and the Tabman bar
//        let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
//        let navigationBarHeight = navigationController?.navigationBar.frame.height ?? 0
//        let tabmanBarHeight: CGFloat = 48 // Adjust if you have a custom size for Tabman bar
//
//        let gradientView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: statusBarHeight + navigationBarHeight + tabmanBarHeight))
//        let gradientImageView = UIImageView(frame: gradientView.bounds)
//        gradientImageView.image = UIImage(named: "by_header_myreward")
//        gradientView.addSubview(gradientImageView)
//        // Place the gradient view behind all other views
//        view.addSubview(gradientView)
//        view.sendSubviewToBack(gradientView)
//    }
//
//    func initView() {
//        self.title =  "Quà của tôi"
//        viewControllers = [
//            MyOwnedRewardViewController.create(with: self.navigator, viewModel: MyOwnedRewardViewModel(myrewardRepository: MyrewardRepositoryImpl())),
//            MyUsedRewardViewController.create(with: self.navigator, viewModel: MyUsedRewardViewModel(myrewardRepository: MyrewardRepositoryImpl()))
//        ];
//    }
//
//
//    func initTabView() {
//        self.dataSource = self
//
//        // Create bar
//        let bar = TMBar.ButtonBar()
//        bar.backgroundView.style = .clear // Makes the background clear // Set your custom background color
//        bar.layout.transitionStyle = .snap // How the bar changes between tabs
//        bar.layout.contentMode = .fit // Other options include .intrinsic
//
//        // Customize the bar buttons
//        bar.buttons.customize { (button) in
//            button.tintColor = .white // Color for non-selected items
//            button.selectedTintColor = .cFFCC00 // Color for selected item
//            button.font = UIFont(name: "BeVietnamPro-Regular", size: 14.0)! // Choose your font here
//            button.selectedFont = UIFont(name: "BeVietnamPro-SemiBold", size: 14.0)! // Choose your selected item font here
//        }
//
//        // Customize the bar indicator
//        bar.indicator.tintColor = .cFFCC00  // Set to the color you require
//        bar.indicator.weight = .custom(value: 2) // Set your desired indicator height
//
//        // Customize the spacing and insets if necessary
//        bar.layout.interButtonSpacing = 20 // Set the space between the buttons if needed
//        bar.layout.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10) // Adjust the insets
//
//        // Add the bar to the view controller
//        addBar(bar, dataSource: self, at: .top)
//    }
//}
//
//
//extension MyRewardViewController: PageboyViewControllerDataSource, TMBarDataSource {
//
//    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
//        return viewControllers.count
//    }
//
//    func viewController(for pageboyViewController: PageboyViewController,
//                        at index: PageboyViewController.PageIndex) -> UIViewController? {
//        return viewControllers[index]
//    }
//
//    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
//        return nil
//    }
//
//    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
//        var title = ""
//        if(index == 0){
//            title = "Chưa sử dụng"
//        } else if(index == 1) {
//            title = "Đã sử dụng/ Hết hạn"
//        }
//        return TMBarItem(title: title)
//    }
//}
