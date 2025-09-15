//
//  AuthRepositoryService.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 03/09/25.
//

import CryptoKit
import RealmSwift
import RxSwift

class AuthRepositoryService: AuthRepositoryProtocol {
    static let shared = AuthRepositoryService()
    private let currentKey = "CURRENT_USERNAME"
    private let realm = try! Realm()
    
    private func hash(_ s: String) -> String {
        let data = Data(s.utf8)
        return SHA256.hash(data: data).compactMap { String(format: "%02x", $0) }.joined()
    }
    
    func register(username: String, fullName: String, email: String, phone: String, location: String, password: String) -> Completable {
        Completable.create { comp in
            let user = RMUser()
            user.username = username.lowercased()
            user.fullName = fullName
            user.email = email
            user.phone = phone
            user.location = location
            user.passwordHash = self.hash(password)
            do {
                try self.realm.write {
                    self.realm.add(user, update: .error)
                }
                comp(.completed)
            } catch {
                comp(.error(error))
            }
            return Disposables.create()
        }
    }
    
    func login(email: String, password: String) -> Single<User> {
        let key = email.lowercased()
        if let rm = realm.object(ofType: RMUser.self, forPrimaryKey: key),
           rm.passwordHash == hash(password) {
            UserDefaults.standard.set(key, forKey: currentKey)
            return .just(User(
                username: rm.username, fullName: rm.fullName, email: key, phone: rm.phone, location: rm.location
            ))
        }
        return .error(NSError(domain: "Invalid credentials", code: 401))
    }
    
    func currentUser() -> User? {
        guard let key = UserDefaults.standard.string(forKey: currentKey),
              let rm = realm.object(ofType: RMUser.self, forPrimaryKey: key) else { return nil }
        return User(username: rm.username, fullName: rm.fullName, email: rm.email, phone: rm.phone, location: rm.location)
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: currentKey)
    }
    
    func printAllUsers() {
        let users = realm.objects(RMUser.self)
        print("=== Semua user di Realm ===")
        for user in users {
            print("Username: \(user.username), Full Name: \(user.fullName)")
        }
        print("===========================")
    }
}
