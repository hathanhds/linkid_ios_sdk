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
        let giftInfo: BehaviorRelay<GiftInfoItem?>
        let updateGiftStatusResult: Observable<Result<Void, APIErrorResponseModel>>
    }

    let input: Input
    let viewDidLoadSubj = PublishSubject<Void>()

    let output: Output
    let isLoadingSubj = BehaviorRelay(value: false)
    let giftInfoSubj = BehaviorRelay<GiftInfoItem?>(value: nil)
    let updateGiftStatusResultSubj = PublishSubject<Result<Void, APIErrorResponseModel>>()

    let giftTransactionCode: String

    init(myRewardRepository: MyrewardRepository, giftTransactionCode: String, giftInfo: GiftInfoItem) {
        self.myRewardRepository = myRewardRepository
        self.giftTransactionCode = giftTransactionCode

        self.input = Input(viewDidLoad: viewDidLoadSubj.asObserver())
        self.output = Output(isLoading: isLoadingSubj,
            giftInfo: giftInfoSubj,
            updateGiftStatusResult: updateGiftStatusResultSubj.asObservable())

        self.viewDidLoadSubj.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.getGiftDetail()
            giftInfoSubj.accept(giftInfo)
        }.disposed(by: disposeBag)


    }

    func getGiftDetail(loadingState: LoadingState = .loading) {
        isLoadingSubj.accept(true)
        myRewardRepository.getMyRewardDetail(giftTransactionCode: self.giftTransactionCode)
            .subscribe { [weak self] res in
            guard let self = self else { return }
            if let data = res.result?.items?.first {
                giftInfoSubj.accept(data)
            }
            isLoadingSubj.accept(false)
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            isLoadingSubj.accept(false)
        }.disposed(by: disposeBag)
    }

    func updateEgiftStatus() {
        let transactionCode = output.giftInfo.value?.giftTransaction?.code ?? ""
        isLoadingSubj.accept(true)
        myRewardRepository.updateGiftStatus(transactionCode: transactionCode)
            .subscribe { [weak self] res in
            guard let self = self else { return }
            getGiftDetail()
            self.updateGiftStatusResultSubj.onNext(.success(()))
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            isLoadingSubj.accept(false)
//            let giftInfo = output.giftInfo.value
//            giftInfoSubj.accept(GiftInfoItem(
//                giftTransaction: giftInfo?.giftTransaction,
//                eGift: EGift(usedStatus: "U")))
            if let error = error as? APIErrorResponseModel {
                self.updateGiftStatusResultSubj.onNext(.failure(error))
            } else {
                self.updateGiftStatusResultSubj.onNext(.failure(APIErrorResponseModel(message: error.localizedDescription)))
            }
        }.disposed(by: disposeBag)

    }

}

extension EgiftRewardDetailViewModel {

    func displaydDateInfo(giftInfo: GiftInfoItem?) -> RewarddDateInfoModel {
        let egift = giftInfo?.eGift
        let giftTransaction = giftInfo?.giftTransaction
        let expiredDate = UtilHelper.formatDate(date: egift?.expiredDate)
        let sentDate = UtilHelper.formatDate(date: giftTransaction?.transferTime)
        let usedDate = UtilHelper.formatDate(date: giftTransaction?.eGiftUsedAt)

        let whyHaveIt = giftTransaction?.whyHaveIt
        let usedStatus = egift?.usedStatus
        if (whyHaveIt == WhyHaveRewardType.sent.rawValue && !sentDate.isEmpty) {
            return RewarddDateInfoModel(title: "Đã tặng vào \(sentDate)", color: .cF5574E!)
        } else if (usedStatus == EgiftRewardStatus.expired.rawValue && !expiredDate.isEmpty) {
            return RewarddDateInfoModel(title: "Hết hạn vào \(expiredDate)", color: .cF5574E!)
        } else if (usedStatus == EgiftRewardStatus.used.rawValue) {
//            ? isDiamondTrial
//                               ? 'Gửi yêu cầu vào $usedDate'
//                               : 'Đã dùng vào: $usedDate'
            return RewarddDateInfoModel(title: !usedDate.isEmpty ? "Đã dùng vào \(usedDate)" : "Đã sử dụng", color: .cF5574E!)
        } else {
            return RewarddDateInfoModel(title: !expiredDate.isEmpty ? "HSD: \(expiredDate)" : "", color: .c6D6B7A!)
        }
    }

    func isShowMarkUsedButton() -> Bool {
        let giftInfo = output.giftInfo.value
        let eGift = giftInfo?.eGift
        // Check hệ thống có tự động cập nhật trạng thái mua quà
        let isUsageCheck = giftInfo?.eGift?.usageCheck ?? false

        // Check điều kiện quà chưa sử dụng:
        // - Quà ở trạng thái redeem
        // - Quà chưa được tặng
        let whyHaveIt = giftInfo?.giftTransaction?.whyHaveIt
        let isNotUsed = eGift?.usedStatus == EgiftRewardStatus.redeemed.rawValue && whyHaveIt != WhyHaveRewardType.sent.rawValue
        return !isUsageCheck && isNotUsed
    }

    func caculateTicketPosition() -> CGFloat {
        let giftName = output.giftInfo.value?.giftTransaction?.giftName ?? ""
        let imageHeight = 64.0
        let titleHeight = UtilHelper.heightForLabel(text: giftName, font: .f18s!, width: UtilHelper.screenWidth - 64)
        let dateHeight = 16.0
        let space = CGFloat(24 + 8 + 8 + 18)
        return CGFloat(imageHeight + titleHeight + dateHeight + space)
    }
}

struct RewarddDateInfoModel {
    let title: String
    let color: UIColor
    init(title: String, color: UIColor) {
        self.title = title
        self.color = color
    }
}
