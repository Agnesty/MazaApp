//
//  AuthViewModel.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 30/09/25.
//

import Foundation
import RxSwift
import RxCocoa

final class AuthViewModel {
    private let useCase: AuthUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    let isLoading = BehaviorRelay<Bool>(value: false)
    let errorMessage = PublishRelay<String>()
    let successMessage = PublishRelay<String>()
    let loginSuccess = PublishRelay<Void>()
    
    init(useCase: AuthUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func register(username: String,
                  fullName: String,
                  email: String,
                  phone: String,
                  location: String,
                  password: String) {
        isLoading.accept(true)
        useCase.register(username: username,
                         fullName: fullName,
                         email: email,
                         phone: phone,
                         location: location,
                         password: password)
        .observe(on: MainScheduler.instance)
        .subscribe(onCompleted: { [weak self] in
            self?.isLoading.accept(false)
            self?.successMessage.accept("Registrasi berhasil, silahkan login.")
        }, onError: { [weak self] error in
            self?.isLoading.accept(false)
            self?.errorMessage.accept("Registrasi gagal: \(error.localizedDescription)")
        })
        .disposed(by: disposeBag)
    }
    
    func login(email: String, password: String) {
        isLoading.accept(true)
        useCase.login(email: email, password: password)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] _ in
                self?.isLoading.accept(false)
                self?.loginSuccess.accept(())
            }, onFailure: { [weak self] error in
                self?.isLoading.accept(false)
                self?.errorMessage.accept("Login gagal: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
}
