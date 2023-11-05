//
//  AuthUseCase.swift
//  DomainKit
//
//  Created by 고병학 on 10/15/23.
//  Copyright © 2023 kr.ddd.ozeon. All rights reserved.
//

import ComposableArchitecture
import CoreKit
import DIKit

import Foundation

public protocol AuthUseCaseProtocol {
    func loginWithSocialToken(_ token: String, socialType: SocialType) async -> (String?, Error?)
    func checkNickname(_ nickname: String) async -> (Bool, Error?)
}

public final class AuthUseCase: AuthUseCaseProtocol {
    private let repository: AuthRepositoryProtocol
    
    public init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }
    
    public func loginWithSocialToken(_ token: String, socialType: SocialType) async -> (String?, Error?) {
        let (response, error): (LoginResponseModel?, Error?) = await repository.loginWithSocialToken(
            token,
            socialType: socialType
        )
        if response?.body == nil {
            Logger.log(response?.body.debugDescription, "\(Self.self)", #function)
        }
        return (response?.body?.accessToken, error)
    }
    
    public func checkNickname(_ nickname: String) async -> (Bool, Error?) {
        let (response, error): (SimpleYNResponse?, Error?) = await repository.checkNickname(nickname)
        if response?.body == nil {
            Logger.log(response.debugDescription, "\(Self.self)", #function)
        }
        return (response?.body == "Y", error)
    }
}

extension AuthUseCase: DependencyKey {
    public static let liveValue: AuthUseCase = {
        let authRepository: AuthRepositoryProtocol = DIContainer.container.resolve(AuthRepositoryProtocol.self)!
        return AuthUseCase(repository: authRepository)
    }()
}

extension DependencyValues {
    public var authUseCase: AuthUseCaseProtocol {
        get { self[AuthUseCase.self] }
        set { self[AuthUseCase.self] = newValue as! AuthUseCase }
    }
}
