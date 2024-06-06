//
//  EgiftRewardDetailViewController.swift
//  LinkIDApp
//
//  Created by Phan Tuan Anh on 17/04/2024.
//

import UIKit
import RxSwift
import RxCocoa

class PhysicalRewardDetailViewModel: ViewModelType {
    let disposeBag = DisposeBag()
    let dispatchGroup = DispatchGroup()

    private let myRewardRepository: MyrewardRepository

    struct Input {
        let viewDidLoad: AnyObserver<Void>

    }

    struct Output {
        let isLoading: BehaviorRelay<Bool>
        let rewardInfo: BehaviorRelay<GiftInfoItem?>
        let listProgress: BehaviorRelay<[PhysicalRewardTransactionModel]>
    }

    let input: Input
    let viewDidLoadSubj = PublishSubject<Void>()

    let output: Output
    let isLoadingSubj = BehaviorRelay(value: false)
    let rewardInfoSubj = BehaviorRelay<GiftInfoItem?>(value: nil)
    let listProgressSubj = BehaviorRelay<[PhysicalRewardTransactionModel]>(value: [])

    let giftTransactionCode: String

    init(myRewardRepository: MyrewardRepository, giftTransactionCode: String) {
        self.myRewardRepository = myRewardRepository
        self.giftTransactionCode = giftTransactionCode

        self.input = Input(viewDidLoad: viewDidLoadSubj.asObserver())
        self.output = Output(
            isLoading: isLoadingSubj,
            rewardInfo: rewardInfoSubj,
            listProgress: listProgressSubj)

        listProgressSubj.accept(getProgressItems(status: .canceled))

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

    func getProgressItems(status: PhysicalRewardStatus) -> [PhysicalRewardTransactionModel] {
        let progressIndex = status.progressInfo.progressIndex ?? 0;
        let progress1 = [
            PhysicalRewardTransactionModel(
                title: "Đang xử lý",
                stepNumber: 1,
                isCurrentStep: progressIndex == 1,
                isLeftLineActive: progressIndex >= 1,
                isRightLineActive: progressIndex > 1),
            PhysicalRewardTransactionModel(
                title: "Đang giao hàng",
                stepNumber: 2,
                isCurrentStep: progressIndex == 2,
                isLeftLineActive: progressIndex >= 2,
                isRightLineActive: progressIndex > 2),
            PhysicalRewardTransactionModel(
                title: "Đã giao hàng",
                stepNumber: 2,
                isCurrentStep: progressIndex == 3,
                isLeftLineActive: progressIndex == 3,
                isRightLineActive: progressIndex == 3),
        ];

        let progress2 = [
            PhysicalRewardTransactionModel(
                title: "Đang xử lý",
                stepNumber: 1,
                isCurrentStep: progressIndex == 1,
                isLeftLineActive: progressIndex >= 1,
                isRightLineActive: progressIndex > 1),
            PhysicalRewardTransactionModel(
                title: "Đã huỷ",
                stepNumber: 2,
                isCurrentStep: progressIndex == 2,
                isLeftLineActive: progressIndex == 2,
                isRightLineActive: progressIndex == 2),
        ];

        let progress3 = [
            PhysicalRewardTransactionModel(
                title: "Đang xử lý",
                stepNumber: 1,
                isCurrentStep: progressIndex == 1,
                isLeftLineActive: progressIndex >= 1,
                isRightLineActive: progressIndex > 1),
            PhysicalRewardTransactionModel(
                title: "Đang giao hàng",
                stepNumber: 2,
                isCurrentStep: progressIndex == 2,
                isLeftLineActive: progressIndex >= 2,
                isRightLineActive: progressIndex > 2),
            PhysicalRewardTransactionModel(
                title: "Vận chuyển trả hàng",
                stepNumber: 2,
                isCurrentStep: progressIndex == 3,
                isLeftLineActive: progressIndex >= 3,
                isRightLineActive: progressIndex > 3),
            PhysicalRewardTransactionModel(
                title: "Đã huỷ",
                stepNumber: 4,
                isCurrentStep: progressIndex == 4,
                isLeftLineActive: progressIndex == 4,
                isRightLineActive: progressIndex == 4),
        ];

        switch (status.progressInfo.progressNumber) {
        case 1:
            return progress1;
        case 2:
            return progress2;
        case 3:
            return progress3;
        default:
            return [];
        }
    }

}
