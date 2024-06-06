//
//  GiftDetailViewModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 30/05/2024.
//

import UIKit
import RxSwift
import RxCocoa

class GiftDetailViewModel: ViewModelType {
    let disposeBag = DisposeBag()

    private let giftsRepository: GiftsRepository

    struct Input {
        let viewDidLoad: AnyObserver<Void>

    }

    struct Output {
        let isLoading: BehaviorRelay<Bool>
        let giftInfo: BehaviorRelay<GiftInfoItem?>
    }

    let input: Input
    let viewDidLoadSubj = PublishSubject<Void>()

    let output: Output
    let isLoadingSubj = BehaviorRelay(value: false)
    let giftInfoSubj = BehaviorRelay<GiftInfoItem?>(value: nil)

    let giftId: String

    init(giftsRepository: GiftsRepository, giftId: String) {
        self.giftsRepository = giftsRepository
        self.giftId = giftId

        self.input = Input(viewDidLoad: viewDidLoadSubj.asObserver())
        self.output = Output(isLoading: isLoadingSubj, giftInfo: giftInfoSubj)

        self.viewDidLoadSubj.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.fetchData()
        }.disposed(by: disposeBag)
    }

    func fetchData(loadingState: LoadingState = .loading) {
        isLoadingSubj.accept(true)
//        myRewardRepository.getMyRewardDetail(giftTransactionCode: self.giftTransactionCode)
//            .subscribe { [weak self] res in
//            guard let self = self else { return }
//            let data = res.result?.items?.first
//            rewardInfoSubj.accept(data)
//            isLoadingSubj.accept(false)
//        } onFailure: { [weak self] error in
//            guard let self = self else { return }
//            isLoadingSubj.accept(false)
//        }.disposed(by: disposeBag)

    }


}

