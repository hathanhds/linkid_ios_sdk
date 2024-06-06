//
//  AppError.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 26/01/2024.
//

import Foundation

enum APIError: Error {
    case somethingWentWrong
    case unauthorized
    case noInternetConnection
    case invalidRequest
    case notFound
    case invalidResponse
    case timeOut
    case noData
    case internalSever
}

