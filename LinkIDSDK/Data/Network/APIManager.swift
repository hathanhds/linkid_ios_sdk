//
//  APIManager.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 16/02/2024.
//

import Foundation
import Moya
import RxSwift
import Alamofire

class APIManager {

    private static let shared = APIManager()

    class DefaultAlamofireSession: Alamofire.Session {
        static let shared: DefaultAlamofireSession = {
            let configuration = URLSessionConfiguration.default
            configuration.headers = .default
            configuration.timeoutIntervalForRequest = 60 // in second
            configuration.timeoutIntervalForResource = 60 // in second
            configuration.requestCachePolicy = .useProtocolCachePolicy
            return DefaultAlamofireSession(configuration: configuration)
        }()
    }

    private let provider = MoyaProvider<APIService>(
        session: DefaultAlamofireSession.shared,
        plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))]).rx

    private let disposeBag = DisposeBag()

    private init() { }

    static func request(target: APIService, onQueue queue: DispatchQueue? = .global()) -> Single<Response> {

        guard NetworkManager.shared.isNetworkconnected else {
            return Single.create { observer -> Disposable in
                observer(.failure(APIError.noInternetConnection))
                return Disposables.create()
            }
        }


        switch target.tokenType {
        case .accessToken:
            return Single.create { observer -> Disposable in
                let refreshAccessTokenRequest = {
                    shared.refreshAccessToken(tokenType: target.tokenType)
                        .subscribe(onSuccess: { accessToken, refreshToken in
                        AppConfig.shared.accessToken = accessToken
                        AppConfig.shared.refreshToken = refreshToken
                        shared.provider.request(target, callbackQueue: queue)
                            .subscribe { (event) in
                            observer(event)
                        }
                            .disposed(by: self.shared.disposeBag)
                    }, onFailure: { _ in
                            observer(.failure(APIError.somethingWentWrong))
                            // TODO: show error or quit SDK
                        })
                        .disposed(by: self.shared.disposeBag)
                }

                shared.provider.request(target, callbackQueue: queue)
                    .subscribe(
                    onSuccess: { res in
                        switch res.statusCode {
                        case 200...300:
                            observer(.success(res))
                        case 401:
                            refreshAccessTokenRequest()
                        default:
                            observer(.failure(APIError.somethingWentWrong))
                        }

                    }, onFailure: { _ in
                        observer(.failure(APIError.somethingWentWrong))
                        // TODO: show error or quit SDK
                    })
                    .disposed(by: shared.disposeBag)
                return Disposables.create()
            }.observe(on: MainScheduler.instance)
        case .seedToken:
            return Single.create { observer -> Disposable in
                let refreshSeedTokenRequest = {
                    shared.refreshAccessToken(tokenType: APIService.TokenType.accessToken)
                        .subscribe(onSuccess: { accessToken, refreshToken in
                        AppConfig.shared.seedToken = accessToken
                        AppConfig.shared.refreshSeedToken = refreshToken
                        shared.provider.request(target, callbackQueue: queue)
                            .subscribe { (event) in
                            observer(event)
                        }
                            .disposed(by: self.shared.disposeBag)
                    }, onFailure: { _ in
                            observer(.failure(APIError.somethingWentWrong))
                            // TODO: show error or quit SDK
                        })
                        .disposed(by: self.shared.disposeBag)
                }

                shared.provider.request(target, callbackQueue: queue)
                    .subscribe(
                    onSuccess: { res in
                        switch res.statusCode {
                        case 200...300:
                            observer(.success(res))
                        case 401:
                            refreshSeedTokenRequest()
                        default:
                            observer(.failure(APIError.somethingWentWrong))
                        }

                    }, onFailure: { _ in
                        observer(.failure(APIError.somethingWentWrong))
                    })
                    .disposed(by: shared.disposeBag)
                return Disposables.create()
            }.observe(on: MainScheduler.instance)
        case .none:
            return Single.create { observer -> Disposable in
                shared.provider.request(target, callbackQueue: queue)
                    .subscribe(
                    onSuccess: { res in
                        switch res.statusCode {
                        case 200...300:
                            observer(.success(res))
                        default:
                            observer(.failure(APIError.somethingWentWrong))
                        }

                    }, onFailure: { _ in
                        observer(.failure(APIError.somethingWentWrong))
                    })
                    .disposed(by: shared.disposeBag)
                return Disposables.create()
            }.observe(on: MainScheduler.instance)
        }
    }

}


extension APIManager {
    private func refreshAccessToken(tokenType: APIService.TokenType) -> Single<(String, String)> {
        let refreshToken = tokenType == .accessToken ? AppConfig.shared.refreshToken : AppConfig.shared.refreshSeedToken
        guard !refreshToken.isEmpty else {
            return Single.create { observer -> Disposable in
                observer(.failure(APIError.unauthorized))
                return Disposables.create()
            }
        }
        return APIManager.request(target: .refreshToken(refreshToken: refreshToken))
            .map({ res -> (String, String) in
            if let json = try? JSONSerialization.jsonObject(with: res.data) as? [String: Any],
                let accessToken = json?["access_token"] as? String,
                let refreshToken = json?["refresh_token"] as? String {
                return (accessToken, refreshToken)
            } else {
                throw APIError.somethingWentWrong
            }
        })
    }
}
