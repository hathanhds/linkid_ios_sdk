//
//  TransactionHistoryViewController.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 15/01/2024.
//  Copyright (c) 2024 All rights reserved.
//

import UIKit

class TransactionHistoryViewController: UIViewController {
    
    private var navigator: Navigator!
    private var viewModel: TransactionHistoryViewModel!
    
    class func create(with navigator: Navigator, viewModel: TransactionHistoryViewModel) -> TransactionHistoryViewController {
        let vc = UIStoryboard.transactionHistory.instantiateViewController(ofType: TransactionHistoryViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bind(to: viewModel)
        viewModel.viewDidLoad()
    }
    
    func bind(to viewModel: TransactionHistoryViewModel) {

    }
}
