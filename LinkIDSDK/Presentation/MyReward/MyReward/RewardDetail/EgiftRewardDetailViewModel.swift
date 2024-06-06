//
//  EgiftRewardDetailViewController.swift
//  LinkIDApp
//
//  Created by Phan Tuan Anh on 17/04/2024.
//

import UIKit
import RxSwift
import RxCocoa

class EgiftRewardDetailViewModel: ViewModelType {
    let disposeBag = DisposeBag()
    let dispatchGroup = DispatchGroup()

    private let myRewardRepository: MyrewardRepository

    struct Input {
        let viewDidLoad: AnyObserver<Void>

    }

    struct Output {
        let isLoading: BehaviorRelay<Bool>
        let rewardInfo: BehaviorRelay<GiftInfoItem?>
    }

    let input: Input
    let viewDidLoadSubj = PublishSubject<Void>()

    let output: Output
    let isLoadingSubj = BehaviorRelay(value: false)
    let rewardInfoSubj = BehaviorRelay<GiftInfoItem?>(value: nil)

    let giftTransactionCode: String

    init(myRewardRepository: MyrewardRepository, giftTransactionCode: String) {
        self.myRewardRepository = myRewardRepository
        self.giftTransactionCode = giftTransactionCode

        self.input = Input(viewDidLoad: viewDidLoadSubj.asObserver())
        self.output = Output(isLoading: isLoadingSubj, rewardInfo: rewardInfoSubj)

        self.viewDidLoadSubj.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.fetchData()
        }.disposed(by: disposeBag)
    }

    func fetchData(loadingState: LoadingState = .loading) {
        isLoadingSubj.accept(true)
        myRewardRepository.getMyRewardDetail(giftTransactionCode: self.giftTransactionCode)
            .subscribe { [weak self] res in
            guard let self = self else { return }
            let data = res.result?.items?.first
            rewardInfoSubj.accept(data)
            isLoadingSubj.accept(false)
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            isLoadingSubj.accept(false)
        }.disposed(by: disposeBag)

    }


}
