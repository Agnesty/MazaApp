//
//  AuthUseCase.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 30/09/25.
//

import Foundation
import RxSwift

protocol AuthUseCaseProtocol {
    func register(username: String, fullName: String, email: String, phone: String, location: String, password: String) -> Completable
    func login(email: String, password: String) -> Single<User>
    func getCurrentUser() -> User?
    func logout()
}

class AuthUseCase: AuthUseCaseProtocol {
    private let repository: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }
    
    func register(username: String, fullName: String, email: String, phone: String, location: String, password: String) -> Completable {
        repository.register(username: username, fullName: fullName, email: email, phone: phone, location: location, password: password)
    }
    
    func login(email: String, password: String) -> Single<User> {
        repository.login(email: email, password: password)
    }
    
    func getCurrentUser() -> User? {
        repository.currentUser()
    }
    
    func logout() {
        repository.logout()
    }
}

