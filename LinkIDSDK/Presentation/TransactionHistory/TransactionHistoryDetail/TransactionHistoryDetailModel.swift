//
//  TransactionHistoryDetailModel.swift
//  LinkIDApp
//
//  Created by Phan Tuan Anh on 10/06/2024.
//

import UIKit
import RxSwift
import RxCocoa

class TransactionHistoryDetailModel: ViewModelType {
    let disposeBag = DisposeBag()

    let tokenTransID: String?
    let orderCode: String?

    private let transactionRepository: TransactionRepository

    struct Input {
        let viewDidLoad: AnyObserver<Void>
    }

    struct Output {
        let transactionInfo: BehaviorRelay<TransactionDetailModel?>
        let relatedTransactionInfo: BehaviorRelay<TransactionDetailModel?>
        let isLoading: BehaviorRelay<Bool>
    }

    let input: Input
    let viewDidLoadSubj = PublishSubject<Void>()

    let output: Output
    let isLoadingSubj = BehaviorRelay(value: true)

    let transactionInfoSubj = BehaviorRelay<TransactionDetailModel?>(value: nil)
    let relatedTransactionInfoSubj = BehaviorRelay<TransactionDetailModel?>(value: nil)

    init(tokenTransID: String? = nil, orderCode: String? = nil, transactionRepository: TransactionRepository) {
        self.transactionRepository = transactionRepository
        self.tokenTransID = tokenTransID
        self.orderCode = orderCode

        self.input = Input(viewDidLoad: viewDidLoadSubj.asObserver())
        self.output = Output(
            transactionInfo: transactionInfoSubj,
            relatedTransactionInfo: relatedTransactionInfoSubj,
            isLoading: isLoadingSubj
        )

        self.viewDidLoadSubj.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.fetchData()
        }.disposed(by: disposeBag)

    }

    func fetchData() {
        if let tokenTransID = tokenTransID {
            getTransactionDetail(tokenTransID: tokenTransID)
        } else if let orderCode = orderCode {
            getTransactionList(orderCode: orderCode.replacingOccurrences(of: "_1", with: ""))
        }
    }


    func getTransactionDetail(tokenTransID: String) { self.isLoadingSubj.accept(true)
        transactionRepository.getDetailTransaction(request: TransactionDetailRequestModel(tokenTransID: tokenTransID)).subscribe {
            [weak self] res in
            guard let self = self else { return }
            transactionInfoSubj.accept(res.result)
            if let relatedTokenTransId = res.result?.relatedTokenTransId {
                getRelatedTransactionDetail(tokenTransID: relatedTokenTransId)
            }
            isLoadingSubj.accept(false)
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            isLoadingSubj.accept(false)
        }.disposed(by: disposeBag)
    }

    func getTransactionList(orderCode: String) {
        isLoadingSubj.accept(true)
        transactionRepository.getListTransaction(request: TransactionHistoryRequestModel(
            limit: 1,
            offset: 0,
            actionTypeFilter: "",
            orderCode: orderCode))
            .subscribe { [weak self] res in
            guard let self = self else { return }
            let transaction = res.items?.first
            getTransactionDetail(tokenTransID: transaction?.tokenTransID ?? "")
            isLoadingSubj.accept(false)
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            isLoadingSubj.accept(false)
        }.disposed(by: disposeBag)
    }

    func getRelatedTransactionDetail(tokenTransID: String, loadingState: LoadingState = .loading) {
        if (loadingState == .loading) {
            self.isLoadingSubj.accept(true)
        }
        transactionRepository.getDetailTransaction(request: TransactionDetailRequestModel(tokenTransID: tokenTransID)).subscribe {
            [weak self] res in
            guard let self = self else { return }
            relatedTransactionInfoSubj.accept(res.result)
            isLoadingSubj.accept(false)
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            isLoadingSubj.accept(false)
        }.disposed(by: disposeBag)
    }
}
