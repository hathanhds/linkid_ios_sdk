//
//  GiftConfirmExchangeViewController.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 31/05/2024.
//

import UIKit
import RxSwift

class GiftConfirmExchangeViewController: BaseViewController {

    class func create(with navigator: Navigator, viewModel: GiftConfirmExchangeViewModel) -> Self {
        let vc = UIStoryboard.myReward.instantiateViewController(ofType: GiftConfirmExchangeViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc as! Self
    }

    var viewModel: GiftConfirmExchangeViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.input.viewDidLoad.onNext(())
    }

   override func initView() {
       self.title = "Xác nhận"
    }
}

