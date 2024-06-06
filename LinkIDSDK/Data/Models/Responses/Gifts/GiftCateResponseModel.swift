//
//  GiftCateResponseModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 23/01/2024.
//

import Foundation

struct GiftCateResponseModel: Codable {
    var result: GiftCateResultModel?
}



struct GiftCateResultModel: Codable {
    var row1: [GiftCategory]?
    var row2: [GiftCategory]?
}

struct GiftCategory: ModelType {

    var code: String?
    var name: String?
    var fullLink: String?
    var categoryTypeCode: String?

    init(code: String? = nil, name: String? = nil, fullLink: String? = nil, categoryTypeCode: String? = nil) {
        self.code = code
        self.name = name
        self.fullLink = fullLink
        self.categoryTypeCode = categoryTypeCode
    }

    var cateAll: GiftCategory {
        return GiftCategory(code: "", name: "Tất cả", fullLink: "ic_cate_all", categoryTypeCode: "all")
    }

    static func == (lhs: GiftCategory, rhs: GiftCategory) -> Bool {
        return lhs.code == rhs.code
    }
}
