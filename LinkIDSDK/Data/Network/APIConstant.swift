//
//  APIConstant.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 16/01/2024.
//

struct APIConstant {

    struct sdk {
        // Auth
        static let generatePartnerToken = "/api/sdk-v1/partner/generate-token" // Giả lập api generate SeedToken để app chủ truyền cho SDK
        static let checkMemberAndConnection = "/api/sdk-v1/check-member-and-connection" // Kiểm tra dữ liệu member và liên kết
        static let authenWithConnectedPhoneNumber = "/api/sdk-v1/authen-with-connected-phone" // Lấy token bởi số điện thoại liên kết
        static let creatMember = "/api/sdk-v1/create-member"
        static let refreshToken = "/api/sdk-v1/refresh-token"


        // Gift
        static let getListCate = "/api/sdk-v1/get-list-categories"
        static let getListGift = "/api/sdk-v1/get-list-gift"
        static let getGiftDetail = "/api/sdk-v1/get-gift-details"
        static let createTransaction = "/api/sdk-v1/create-transaction"
        static let confirmOtpCreateTransaction = "/api/sdk-v1/confirm-otp-create-transaction"
        static let getListGiftGroupForHomePage = "/api/sdk-v1/get-gift-group"
        static let getAllGiftGroups = "/api/sdk-v1/get-gift-all-infors"
        static let getAllByMemberCode = "/api/sdk-v1/get-all-by-member-code"
        static let getAllWithEgift = "/api/sdk-v1/GetAllWithEGift"
        
        // News
        static let getListNewsAndBanner = "/api/sdk-v1/get-all-article-and-related-news"
    }

    struct transaction {
        static let transaction = "get-transaction"
    }

    struct userInfo {
        static let viewPoint = "view-point"
    }

    struct loyaltyArticles {
        static let getAllArticleAndRelatedNews = "/api/Article/GetAllArticleAndRelatedNews"
//        static let getListNewsAndBanner = "/api/Article/GetAllArticleAndRelatedNews_Optimize"
        static let getTermsAndConditions = "/api/Article/GetTermsAndConditions"
        static let getSecurityPolicy = "/api/Article/GetSecurityPolicy"
    }

    struct giftInfos {
//        static let getListGiftGroupForHomePage = "/api/GiftInfos/appv1dot1/get-gift-group-for-home-page"
//        static let getAllForCategoryV1 = "/api/GiftInfos/GetAllEffectiveCategory_v1"
//        static let getAllGiftGroups = "/api/GiftInfos/GetGiftAllInfors"
//        static let getAllByMemberCode = "/api/GiftInfos/GetAllByMemberCode"

    }

//    struct giftCategory {
//        static let getGiftListCategoriesInTwoRows = "/api/GiftCategory/GiftListCategoriesInTwoRows"
//    }

    struct member {
        static let view = "/api/Member/View"
        static let viewPoint = "/api/Member/ViewPoint"
    }
}
