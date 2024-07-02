//
//  CreateTransactionRequestModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 24/06/2024.
//

import Foundation

struct CreateTransactionRequestModel: Codable {
    var sessionId: String
    var giftCode: String
    var totalAmount: Int
    var quantity: Int
    var receiverInfo: ReceiverInfoModel?

    init(sessionId: String, giftCode: String, totalAmount: Int, quantity: Int, receiverInfo: ReceiverInfoModel? = nil) {
        self.sessionId = sessionId
        self.giftCode = giftCode
        self.totalAmount = totalAmount
        self.quantity = quantity
        self.receiverInfo = receiverInfo
    }

    func getParams() -> [String: Any] {
        var params = [
            "memberCode": AppConfig.shared.memberCode,
            "sessionId": sessionId,
            "cifCode": AppConfig.shared.cif,
            "quantity": quantity,
            "giftCode": giftCode,
            "totalAmount": totalAmount,
        ] as [String: Any]
        if let receiverInfo = receiverInfo {
            params["description"] = receiverInfo.receiverRequest().toJsonString()
        }
        return params
    }
}

