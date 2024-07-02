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

        // Userinfo
        static let viewPoint = "/api/sdk-v1/Member/View-point"
        static let location = "/api/sdk-v1/Location/GetAll"
        static let memberView = "/api/sdk-v1/Member/View"

        // Gift
        static let getListCate = "/api/sdk-v1/get-list-categories"
        static let getListCateDiamond = "/api/sdk-v1/GetAllGiftCategoriesAndInfo"

        static let getListGift = "/api/sdk-v1/get-list-gift"
        static let getGiftDetail = "/api/sdk-v1/get-gift-details"
        static let createTransaction = "/api/sdk-v1/create-transaction"
        static let confirmOtpCreateTransaction = "/api/sdk-v1/confirm-otp-create-transaction"
        static let getListGiftGroupForHomePage = "/api/sdk-v1/get-gift-group"
        static let getAllGiftGroups = "/api/sdk-v1/get-gift-all-infors"
        static let getAllByMemberCode = "/api/sdk-v1/get-all-by-member-code"
        static let getAllWithEgift = "/api/sdk-v1/GetAllWithEGift"
        static let getGiftUsageAddress = "/api/sdk-v1/GetGiftUsageAddress"
        
        // News
        static let getListNewsAndBanner = "/api/sdk-v1/get-all-article-and-related-news"


        //Transaction
        static let transactionHistoryList = "/api/sdk-v1/Member/TokenTrans/GetByMemberId"
        static let transactionDetail = "/api/sdk-v1/get-tx-detail"

        //Merchant
        static let merchantList = "/api/sdk-v1/Merchant/GetAll"

        // Reward
        static let updateGiftStatus = "/api/sdk-v1/EGiftInfors/UpdateGiftStatus"


    }

    struct transaction {
        static let transaction = "get-transaction"

    }

    struct loyaltyArticles {
        static let getAllArticleAndRelatedNews = "/api/Article/GetAllArticleAndRelatedNews"
        static let getTermsAndConditions = "/api/Article/GetTermsAndConditions"
        static let getSecurityPolicy = "/api/Article/GetSecurityPolicy"
    }
}
