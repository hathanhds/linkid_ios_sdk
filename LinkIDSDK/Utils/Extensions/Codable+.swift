//
//  Encodable.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 19/02/2024.
//

import Foundation

extension Encodable {
    func encoded() throws -> Data {
        return try JSONEncoder().encode(self)
    }
}

extension Data {
    func decoded<T: Decodable>(type: T.Type) throws -> T {
        return try JSONDecoder().decode(T.self, from: self)
    }
}
