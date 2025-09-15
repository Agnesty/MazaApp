//
//  RMUser.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 03/09/25.
//

import Foundation
import RealmSwift

final class RMUser: Object {
    @Persisted(primaryKey: true) var email: String
    @Persisted var passwordHash: String
    @Persisted var fullName: String
    @Persisted var username: String?
    @Persisted var phone: String?
    @Persisted var location: String?
}
