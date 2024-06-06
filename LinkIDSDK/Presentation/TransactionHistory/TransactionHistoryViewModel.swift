//
//  TransactionHistoryViewModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 15/01/2024.
//  Copyright (c) 2024 All rights reserved.
//

import Foundation

protocol TransactionHistoryViewModelInput {
    func viewDidLoad()
}

protocol TransactionHistoryViewModelOutput {
    
}

protocol TransactionHistoryViewModel: TransactionHistoryViewModelInput, TransactionHistoryViewModelOutput { }

class DefaultTransactionHistoryViewModel: TransactionHistoryViewModel {
    
    // MARK: - OUTPUT

}

// MARK: - INPUT. View event methods
extension DefaultTransactionHistoryViewModel {
    func viewDidLoad() {
    }
}
