//
//  GiftsRepository.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 30/01/2024.
//

import RxSwift

protocol GiftsRepository {
    func getListGiftCate() -> Single<BaseResponseModel2<GiftCateResultModel>>
    func getListGiftGroupForHomepage(maxItem: Int?) -> Single<GiftGroupsResponseModel>
    func getALlGifts(request: AllGiftsRequestModel) -> Single<GiftListResponseModel>
    func getAllGiftGroups() -> Single<AllGiftsByGroupResponseModel>
    func getListGiftByGroup(groupCode: String, limit: Int, offset: Int) -> Single<GiftListResponseModel>
}
