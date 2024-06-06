//
//  APIService.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 16/02/2024.
//

import Foundation
import Moya

enum APIService {
    case refreshToken(refreshToken: String)
    case generatePartnerToken(phoneNumber: String, cif: String, name: String)
    case checkMemberAndConnection(phoneNumber: String, cif: String)
    case authenWithConnectedPhone(originalPhone: String, connectedPhone: String)
    case createMember(phoneNumber: String, cif: String, name: String)
    case getListNews(offset: Int, limit: Int)
    case getListNewsAndBanner
    case getListGiftGroupForHomePage(maxItem: Int?)
    case getListGiftCate
    case getUserInfo
    case getUserPoint
    case getAllGifts(request: AllGiftsRequestModel)
    case getAllGiftGroups
    case getListGiftsByGroup(groupCode: String, limit: Int, offset: Int)
    case getTermsAndConditions
    case getSecurityPolicy
    case getListReward(request: MyRewardRequestModel)
    case getMyRewardDetail(giftTransactionCode: String)
}

extension APIService: TargetType {
    var path: String {
        switch self {
            // Auth
        case .refreshToken:
            return APIConstant.sdk.refreshToken
        case .generatePartnerToken:
            return APIConstant.sdk.generatePartnerToken
        case .checkMemberAndConnection:
            return APIConstant.sdk.checkMemberAndConnection
        case .authenWithConnectedPhone:
            return APIConstant.sdk.authenWithConnectedPhoneNumber
        case .createMember:
            return APIConstant.sdk.creatMember
            // LoyaltyArticles
        case .getListNews:
            return APIConstant.loyaltyArticles.getAllArticleAndRelatedNews
        case .getListNewsAndBanner:
            return APIConstant.sdk.getListNewsAndBanner
        case .getListGiftGroupForHomePage:
            // GiftInfo
            return APIConstant.sdk.getListGiftGroupForHomePage
        case .getAllGifts:
            return APIConstant.sdk.getListGift
        case .getListGiftCate:
            // GiftCategory
            return APIConstant.sdk.getListCate
            // Member
        case .getUserInfo:
            return APIConstant.member.view
        case .getUserPoint:
            return APIConstant.member.viewPoint
        case .getAllGiftGroups:
            return APIConstant.sdk.getAllGiftGroups
        case .getListGiftsByGroup:
            return APIConstant.sdk.getAllByMemberCode
        case .getTermsAndConditions:
            return APIConstant.loyaltyArticles.getTermsAndConditions
        case .getSecurityPolicy:
            return APIConstant.loyaltyArticles.getSecurityPolicy
        case .getListReward,
             .getMyRewardDetail:
            return APIConstant.sdk.getAllWithEgift

        }
    }

    var method: Moya.Method {
        switch self {
        case .refreshToken,
             .getListNews,
             .getListNewsAndBanner,
             .getListGiftGroupForHomePage,
             .getAllGifts,
             .getListGiftCate,
             .getUserInfo,
             .getUserPoint,
             .getAllGiftGroups,
             .getListGiftsByGroup,
             .getTermsAndConditions,
             .getSecurityPolicy,
             .getListReward,
             .getMyRewardDetail:
            return .get
        case.generatePartnerToken,
             .checkMemberAndConnection,
             .authenWithConnectedPhone,
             .createMember:
            return .post
        }
    }


    var task: Moya.Task {
        switch self {
        case .generatePartnerToken(let phoneNumber, let cif, let name):
            return .requestParameters(parameters: [
                "phoneNumber": phoneNumber,
                "cif": cif,
                "name": name,
                ], encoding: JSONEncoding.default)
        case .checkMemberAndConnection(let phoneNumber, let cif):
            return .requestParameters(parameters: [
                "phoneNumber": phoneNumber,
                "cif": cif,
                ], encoding: JSONEncoding.default)
        case .authenWithConnectedPhone(let originalPhone, let connectedPhone):
            return .requestParameters(parameters: [
                "originalPhone": originalPhone,
                "connectedPhone": connectedPhone,
                ], encoding: JSONEncoding.default)
        case .createMember(let phoneNumber, let cif, let name):
            return .requestParameters(parameters: [
                "phoneNumber": phoneNumber,
                "cif": cif,
                "name": name
                ], encoding: JSONEncoding.default)
        case .getListNews(let offset, let limit):
            return .requestParameters(parameters: ["CategoryTypeFilter": 0,
                "SkipCount": offset,
                "MaxResultCount": limit,
                "Sorting": "Article.CreationTime desc"
                ], encoding: URLEncoding.queryString)
        case .getListNewsAndBanner:
            return .requestParameters(parameters: [
                "SkipCount": 0,
                "MaxResultCount": 5,
                "Sorting": "Article.Ordinal desc"
                ], encoding: URLEncoding.queryString)
        case .getListGiftGroupForHomePage(let maxItem):
            return .requestParameters(parameters: [
                "MemberCode": AppConfig.shared.memberCode,
                "MaxItem": 5,
                "MaxResultCount": maxItem ?? 6,
                "GiftGroupTypeFilter": 0,
                "SimplifiedResponse": "true"
                ], encoding: URLEncoding.queryString)
        case .getAllGifts(let request):
            let params = request.getParams()
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .getListGiftCate:
            return .requestParameters(parameters: [
                "MemberCode": AppConfig.shared.memberCode,
                ], encoding: URLEncoding.queryString)
        case .getUserInfo:
            return .requestParameters(parameters: [
                "MemberCode": AppConfig.shared.memberCode,
                ], encoding: URLEncoding.queryString)
        case .getUserPoint:
            return .requestParameters(parameters: [
                "MemberCode": AppConfig.shared.memberCode,
                ], encoding: URLEncoding.queryString)
        case .getAllGiftGroups:
            return .requestParameters(parameters: [
                "MemberCode": AppConfig.shared.memberCode,
                "MaxItem": 5,
                "MaxResultCount": 10,
                "GiftGroupTypeFilter": 0,
                "SimplifiedResponse": "true"
                ], encoding: URLEncoding.queryString)
        case .getListGiftsByGroup(let groupCode, let limit, let offset):
            return .requestParameters(parameters: [
                "MemberCode": AppConfig.shared.memberCode,
                "MaxResultCount": limit,
                "SkipCount": offset,
                "StatusFilter": "A",
                "GiftGroupCodeFilter": groupCode,
                "MaxRequiredCoinFilter": 1000000000,
                "Sorting": "LastModificationTime desc"
                ], encoding: URLEncoding.queryString)
        case .getListReward(let request):
            let params = request.getParams()
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .getMyRewardDetail(let giftTransactionCode):
            return .requestParameters(parameters: ["OwnerCodeFilter": AppConfig.shared.memberCode, "GiftTransactionCode": giftTransactionCode, "Ver": "next"], encoding: URLEncoding.queryString)
        default: return .requestPlain
        }
    }

    var tokenType: TokenType {
        switch self {
        case .refreshToken,
             .generatePartnerToken,
             .getTermsAndConditions,
             .getSecurityPolicy:
            return .none
        case .checkMemberAndConnection,
             .authenWithConnectedPhone,
             .createMember,
             .getListGiftCate,
             .getAllGifts,
             .getListNewsAndBanner,
             .getListGiftGroupForHomePage,
             .getListGiftsByGroup,
             .getAllGiftGroups:
            return .seedToken
        default:
            return .accessToken
        }
    }

    var headers: [String: String]? {
        switch tokenType {
        case .accessToken:
            return ["Content-Type": "application/json",
                "X-PartnerCode": AppConfig.shared.partnerCode,
                "Authorization": "Bearer \(AppConfig.shared.accessToken)"
            ]
        case .seedToken:
            return ["Content-Type": "application/json",
                "X-PartnerCode": AppConfig.shared.partnerCode,
                "Authorization": "Bearer \(AppConfig.shared.seedToken)"
            ]
        case .none:
            switch self {
            case .refreshToken(let refreshToken):
                return ["Content-Type": "application/json",
                    "X-PartnerCode": AppConfig.shared.partnerCode,
                    "Authorization": "Bearer \(refreshToken)"
                ]
            default:
                return ["Content-Type": "application/json",
                    "X-PartnerCode": AppConfig.shared.partnerCode
                ]
            }

        }
    }

    var baseURL: URL {
        let urlString = EnvConfig.shared.baseUrl
        return URL(string: "https:/vpid-mobile-api-uat.linkid.vn")!
    }
}

extension APIService {
    enum TokenType {
        case accessToken
        case seedToken
        case none
    }
}

