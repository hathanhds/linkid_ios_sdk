//
//  UsersRepository.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 02/02/2024.
//

import RxSwift

protocol UserRepository {
    func getUserInfo() -> Single<UserInfoResponseModel>
    func getUserPoint() -> Single<UserPointResponseModel>

}
