//
//  OTPViewModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 28/06/2024.
//

import Foundation
import RxSwift
import RxCocoa

class OTPViewModel {

    let disposeBag = DisposeBag()
    let giftsRepository: GiftsRepository
    let phoneNumber: String
    let sessionId: String
    let quantity: Int
    let giftInfo: GiftInfoItem

    let isLoading = BehaviorRelay(value: false)
    let errorText = BehaviorRelay(value: "")
    let confirmResult = PublishSubject<Result<CreateTransactionItem, APIErrorResponseModel>>()

    init(data: OTPArguments) {
        self.giftsRepository = data.giftsRepository
        self.phoneNumber = AppConfig.shared.phoneNumber
        self.sessionId = data.sessionId
        self.quantity = data.quantity
        self.giftInfo = data.giftInfo
    }

    func confirmOtpCreateTransaction(otpCode: String) {
        isLoading.accept(true)
        giftsRepository.confirmOtpCreateTransaction(
            sessionId: sessionId,
            otpCode: otpCode)
            .subscribe { [weak self] res in
            guard let self = self else { return }
            let transaction = res.data?.items?.first ?? CreateTransactionItem()
            confirmResult.onNext(.success(transaction))
            isLoading.accept(false)
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            if let error = error as? APIErrorResponseModel {
                confirmResult.onNext(.failure(error))
            } else {
                confirmResult.onNext(.failure(APIErrorResponseModel(message: APIError.somethingWentWrong.rawValue)))
            }
            isLoading.accept(false)
        }.disposed(by: disposeBag)
    }
}

struct OTPArguments {
    var giftsRepository: GiftsRepository
    var sessionId: String
    var quantity: Int
    var giftInfo: GiftInfoItem

    init(giftsRepository: GiftsRepository, sessionId: String, quantity: Int, giftInfo: GiftInfoItem) {
        self.giftsRepository = giftsRepository
        self.sessionId = sessionId
        self.quantity = quantity
        self.giftInfo = giftInfo
    }
}
