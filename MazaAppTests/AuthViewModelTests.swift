//
//  AuthViewModelTests.swift
//  MazaAppTests
//
//  Created by Agnes Triselia Yudia on 30/09/25.
//

import Foundation
import XCTest
import RxSwift
import RxCocoa
@testable import MazaApp

final class AuthViewModelTests: XCTestCase {
    var viewModel: AuthViewModel!
    var mockRepo: MockAuthRepository!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        mockRepo = MockAuthRepository()
        let useCase = AuthUseCase(repository: mockRepo)
        viewModel = AuthViewModel(useCase: useCase)
        disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        viewModel = nil
        mockRepo = nil
        disposeBag = nil
        super.tearDown()
    }
    
    func testRegisterSuccess_EmitsSuccessMessage() {
        // Given
        mockRepo.shouldSucceed = true
        let exp = expectation(description: "Success message emitted")
        
        viewModel.successMessage
            .subscribe(onNext: { msg in
                XCTAssertEqual(msg, "Registrasi berhasil, silahkan login.")
                exp.fulfill()
            })
            .disposed(by: disposeBag)
        
        // When
        viewModel.register(username: "u", fullName: "f", email: "e", phone: "p", location: "loc", password: "pw")
        
        // Then
        wait(for: [exp], timeout: 1.0)
        XCTAssertTrue(mockRepo.didRegister)
    }
    
    func testRegisterFailure_EmitsErrorMessage() {
        // Given
        mockRepo.shouldSucceed = false
        let exp = expectation(description: "Error message emitted")
        
        viewModel.errorMessage
            .subscribe(onNext: { msg in
                XCTAssertTrue(msg.contains("Registrasi gagal"))
                exp.fulfill()
            })
            .disposed(by: disposeBag)
        
        // When
        viewModel.register(username: "u", fullName: "f", email: "e", phone: "p", location: "loc", password: "pw")
        
        // Then
        wait(for: [exp], timeout: 1.0)
    }
    
    func testLoginSuccess_EmitsLoginSuccess() {
        // Given
        mockRepo.shouldSucceed = true
        let exp = expectation(description: "Login success emitted")
        
        viewModel.loginSuccess
            .subscribe(onNext: {
                exp.fulfill()
            })
            .disposed(by: disposeBag)
        
        // When
        viewModel.login(email: "e@mail.com", password: "pw")
        
        // Then
        wait(for: [exp], timeout: 1.0)
        XCTAssertTrue(mockRepo.didLogin)
    }
    
    func testLoginFailure_EmitsErrorMessage() {
        // Given
        mockRepo.shouldSucceed = false
        let exp = expectation(description: "Error message emitted")
        
        viewModel.errorMessage
            .subscribe(onNext: { msg in
                XCTAssertTrue(msg.contains("Login gagal"))
                exp.fulfill()
            })
            .disposed(by: disposeBag)
        
        // When
        viewModel.login(email: "e@mail.com", password: "wrong")
        
        // Then
        wait(for: [exp], timeout: 1.0)
    }
}
