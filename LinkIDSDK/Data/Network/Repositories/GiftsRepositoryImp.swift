//
//  GiftsRepositoryImp.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 30/01/2024.
//

import RxSwift

class GiftsRepositoryImpl: GiftsRepository {

    private let disposeBag = DisposeBag()

    func getListGiftCate() -> Single<BaseResponseModel2<GiftCateResultModel>> {
        return Single.create { observer -> Disposable in
            APIManager.request(target: .getListGiftCate)
                .map({ res -> BaseResponseModel2<GiftCateResultModel> in
                let data = res.data
                if let model = try? data.decoded(type: BaseResponseModel2<GiftCateResultModel>.self) {
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

    func getListGiftGroupForHomepage(maxItem: Int?) -> RxSwift.Single<GiftGroupsResponseModel> {
        return Single.create { observer -> Disposable in
            APIManager.request(target: .getListGiftGroupForHomePage(maxItem: maxItem))
                .map({ res -> GiftGroupsResponseModel in
                let data = res.data
                if let model = try? data.decoded(type: GiftGroupsResponseModel.self) {
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

    func getALlGifts(request: AllGiftsRequestModel) -> Single<GiftListResponseModel> {
        return Single.create { observer -> Disposable in
            APIManager.request(target: .getAllGifts(request: request))
                .map({ res -> GiftListResponseModel in
                let data = res.data
                do {
                    let model = try data.decoded(type: GiftListResponseModel.self)
                    return model
                } catch {
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

    func getAllGiftGroups() -> Single<AllGiftsByGroupResponseModel> {
        return Single.create { observer -> Disposable in
            APIManager.request(target: .getAllGiftGroups)
                .map({ res -> AllGiftsByGroupResponseModel in
                let data = res.data
                if let model = try? data.decoded(type: AllGiftsByGroupResponseModel.self) {
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

    func getListGiftByGroup(groupCode: String, limit: Int, offset: Int) -> Single<GiftListResponseModel> {
        return Single.create { observer -> Disposable in
            APIManager.request(target: .getListGiftsByGroup(groupCode: groupCode, limit: limit, offset: offset))
                .map({ res -> GiftListResponseModel in
                let data = res.data
                do {
                    let model = try data.decoded(type: GiftListResponseModel.self)
                    return model
                } catch {
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
