//
//  UserRepositoryImpl.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 02/02/2024.
//

import RxSwift

class UserRepositoryImpl: UserRepository {
    private let disposeBag = DisposeBag()

    func getUserInfo() -> RxSwift.Single<UserInfoResponseModel> {
        return Single.create { observer -> Disposable in
            APIManager.request(target: .getUserInfo)
                .map({ res -> UserInfoResponseModel in
                let data = res.data
                if let model = try? data.decoded(type: UserInfoResponseModel.self) {
                    return model
                } else {
                    throw APIError.somethingWentWrong
                }

            })
                .subscribe(onSuccess: { model in
                observer(.success(model))
            }, onFailure: { error in
                    observer(.failure(error))
                })
                .disposed(by: self.disposeBag)

            return Disposables.create()
        }.observe(on: MainScheduler())
    }

    func getUserPoint() -> RxSwift.Single<UserPointResponseModel> {
        return Single.create { observer -> Disposable in
            APIManager.request(target: .getUserInfo)
                .map({ res -> UserPointResponseModel in
                let data = res.data
                if let model = try? data.decoded(type: UserPointResponseModel.self) {
                    return model
                } else {
                    throw APIError.somethingWentWrong
                }

            })
                .subscribe(onSuccess: { model in
                observer(.success(model))
            }, onFailure: { error in
                    observer(.failure(error))
                })
                .disposed(by: self.disposeBag)

            return Disposables.create()
        }.observe(on: MainScheduler())
    }
}

