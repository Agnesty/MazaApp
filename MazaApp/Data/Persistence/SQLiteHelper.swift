//
//  UserDefaultService.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 25/08/25.
//

import Foundation
import SQLite3

class SearchHistoryDB {
    static let shared = SearchHistoryDB()
    private var db: OpaquePointer?
    private let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)

    private init() {
        openDatabase()
        createTable()
    }

    private func openDatabase() {
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask,
                 appropriateFor: nil, create: false)
            .appendingPathComponent("searchHistory.sqlite")

        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("❌ Error opening database")
        }
    }

    private func createTable() {
        let createTableQuery = """
        CREATE TABLE IF NOT EXISTS history (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            keyword TEXT UNIQUE,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
        """

        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
            print("❌ Error creating table: \(String(cString: sqlite3_errmsg(db)))")
        }
    }

    // MARK: - Insert
    func insert(keyword: String) {
        let trimmed = keyword.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            print("⚠️ Empty keyword ignored")
            return
        }

        let insertQuery = "INSERT OR REPLACE INTO history (keyword, created_at) VALUES (?, CURRENT_TIMESTAMP);"
        var stmt: OpaquePointer?

        if sqlite3_prepare_v2(db, insertQuery, -1, &stmt, nil) == SQLITE_OK {
            let nsKeyword = trimmed as NSString
            sqlite3_bind_text(stmt, 1, nsKeyword.utf8String, -1, SQLITE_TRANSIENT)

            if sqlite3_step(stmt) == SQLITE_DONE {
                print("✅ Saved keyword: \(trimmed)")
            } else {
                print("❌ Could not insert keyword: \(String(cString: sqlite3_errmsg(db)))")
            }
        }
        sqlite3_finalize(stmt)
    }

    // MARK: - Select
    func fetchAll() -> [String] {
        let query = "SELECT keyword FROM history ORDER BY created_at DESC LIMIT 10;"
        var stmt: OpaquePointer?
        var results: [String] = []

        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
            while sqlite3_step(stmt) == SQLITE_ROW {
                if let cString = sqlite3_column_text(stmt, 0) {
                    let keyword = String(cString: cString)
                    results.append(keyword)
                }
            }
        } else {
            print("❌ Error preparing fetch: \(String(cString: sqlite3_errmsg(db)))")
        }
        sqlite3_finalize(stmt)

        print("📚 History fetched: \(results)")
        return results
    }

    // MARK: - Delete
    func delete(keyword: String) {
        let deleteQuery = "DELETE FROM history WHERE keyword = ?;"
        var stmt: OpaquePointer?

        if sqlite3_prepare_v2(db, deleteQuery, -1, &stmt, nil) == SQLITE_OK {
            let nsKeyword = keyword as NSString
            sqlite3_bind_text(stmt, 1, nsKeyword.utf8String, -1, SQLITE_TRANSIENT)

            if sqlite3_step(stmt) == SQLITE_DONE {
                print("✅ Deleted keyword: \(keyword)")
            } else {
                print("❌ Could not delete keyword: \(String(cString: sqlite3_errmsg(db)))")
            }
        } else {
            print("❌ Error preparing delete: \(String(cString: sqlite3_errmsg(db)))")
        }

        sqlite3_finalize(stmt)
    }

    func deleteAll() {
        let query = "DELETE FROM history;"
        sqlite3_exec(db, query, nil, nil, nil)
    }
}

