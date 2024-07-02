//
//  TransactionHistoryChildModel.swift
//  LinkIDApp
//
//  Created by Phan Tuan Anh on 31/05/2024.
//

import UIKit
import RxSwift
import RxCocoa

enum SelectedTab {
    case all
    case earn
    case exchange
    case used
}

class TransactionHistoryChildModel: ViewModelType {
    let disposeBag = DisposeBag()
    let dispatchGroup = DispatchGroup()

    private let transactionRepository: TransactionRepository

    struct Input {
        let viewDidLoad: AnyObserver<Void>
        let refreshData: AnyObserver<Void>
    }

    struct Output {
        let listTransaction: BehaviorRelay<[TransactionItem]>
        let isLoading: BehaviorRelay<Bool>
        let isLoadMore: BehaviorRelay<Bool>
        let isRefreshing: BehaviorRelay<Bool>
    }

    let input: Input
    let viewDidLoadSubj = PublishSubject<Void>()
    let refreshDataSubj = PublishSubject<Void>()

    let output: Output
    let isLoadingSubj = BehaviorRelay(value: true)
   
    let listTransactionSubj = BehaviorRelay<[TransactionItem]>(value: [])
    
    let isLoadMoreSubj = BehaviorRelay(value: false)
    let isRefreshingSubj = BehaviorRelay(value: false)

    var currentTab:SelectedTab = .all
    var page = 0
    var totalCount = 0
    var itemsPerPage = 10
    
    

    init(selectedTab:SelectedTab ,transactionRepository: TransactionRepository) {
        self.transactionRepository = transactionRepository
        self.currentTab = selectedTab
        
        
        self.input = Input(viewDidLoad: viewDidLoadSubj.asObserver(),
            refreshData: refreshDataSubj.asObserver())
        self.output = Output(
            listTransaction: listTransactionSubj,
            isLoading: isLoadingSubj,
            isLoadMore: isLoadMoreSubj,
            isRefreshing: isRefreshingSubj
        )

        
        self.viewDidLoadSubj.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.fetchData()
        }.disposed(by: disposeBag)

        self.refreshDataSubj.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.isRefreshingSubj.accept(true)
            dispatchGroup.notify(queue: .main) {
                self.isRefreshingSubj.accept(false)
            }
            page = 0
            fetchData(loadingState: .refresh)
        }.disposed(by: disposeBag)
      
        
        
    }

    func fetchData(loadingState: LoadingState = .loading) {
        getListTransaction(loadingState: loadingState)
    }

    func onLoadMore() {
        page += 1
        getListTransaction(loadingState: .loadMore)
    }

    func getListTransaction(loadingState: LoadingState = .loading) {
        if (loadingState == .loading) {
            self.isLoadingSubj.accept(true)
        } else if (loadingState == .loadMore) {
            self.isLoadMoreSubj.accept(true)
        }
        dispatchGroup.enter()
        
        var actionTypeFilter = ""
        
        switch currentTab {
        case .all:
            actionTypeFilter = ""
        case .earn:
            actionTypeFilter = "Action;AdjustPlus;AdjustMinus;BatchManualGrant;Order;SingleManualGrant;Topup"
        case .exchange:
            actionTypeFilter = "Exchange;ExchangeAndUse;RevertExchange"
        case .used:
            actionTypeFilter = "PayByToken;Redeem"
        }
        
        transactionRepository.getListTransaction(request: TransactionHistoryRequestModel(limit: itemsPerPage, offset: page * itemsPerPage, actionTypeFilter: actionTypeFilter))
            .subscribe { [weak self] res in
            guard let self = self else { return }
                var currentItems:[TransactionItem] = []
            currentItems = self.output.listTransaction.value.count > 0 ? self.output.listTransaction.value : []
            let newItems = res.items ?? []
            let items = currentItems + newItems
            totalCount = res.totalCount ?? 0
            listTransactionSubj.accept(items)
            isLoadingSubj.accept(false)
            isLoadMoreSubj.accept(false)
            dispatchGroup.leave()
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            isLoadingSubj.accept(false)
            isLoadMoreSubj.accept(false)
            dispatchGroup.leave()
        }.disposed(by: disposeBag)
    }
    
    func refreshListReward() {
        page = 0
        totalCount = 0
        listTransactionSubj.accept([])
        getListTransaction()
    }
}
