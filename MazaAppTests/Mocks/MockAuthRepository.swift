//
//  MockAuthRepository.swift
//  MazaAppTests
//
//  Created by Agnes Triselia Yudia on 30/09/25.
//

import Foundation
import RxSwift
@testable import MazaApp

final class MockAuthRepository: AuthRepositoryProtocol {
    var shouldSucceed = true
    var didRegister = false
    var didLogin = false
    
    func register(username: String, fullName: String, email: String, phone: String, location: String, password: String) -> Completable {
        didRegister = true
        if shouldSucceed {
            return .empty()
        } else {
            return .error(NSError(domain: "RegisterError", code: 1))
        }
    }
    
    func login(email: String, password: String) -> Single<User> {
        didLogin = true
        if shouldSucceed {
            return .just(User(username: "test", fullName: "Test User", email: email, phone: "123", location: "ID"))
        } else {
            return .error(NSError(domain: "LoginError", code: 401))
        }
    }
    
    func currentUser() -> User? {
        shouldSucceed ? User(username: "mock", fullName: "Mock User", email: "mock@mail.com", phone: "000", location: "Mockland") : nil
    }
    
    func logout() {}
    func printAllUsers() {}
}
