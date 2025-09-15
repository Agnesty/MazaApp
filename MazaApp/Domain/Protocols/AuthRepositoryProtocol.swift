//
//  AuthRepositoryProtocol.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 04/09/25.
//

import RealmSwift
import RxSwift

protocol AuthRepositoryProtocol {
    func register(username: String, fullName: String, email: String, phone: String, location: String, password: String) -> Completable
    func login(email: String, password: String) -> Single<User>
    func currentUser() -> User?
    func logout()
    func printAllUsers()
}
