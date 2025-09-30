//
//  SignInViewCtr.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 08/02/25.
//

import UIKit
import RxSwift
import RxCocoa
import MBProgressHUD

final class SignInViewCtr: BaseViewController {
    private let viewModel: AuthViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - UI
    private let titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Maza")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign In"
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let emailTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        return tf
    }()
    
    private let passwordTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.borderStyle = .roundedRect
        tf.isSecureTextEntry = true
        
        let eyeButton = UIButton(type: .custom)
        eyeButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        eyeButton.tintColor = .gray
        eyeButton.frame = CGRect(x: 0, y: 0, width: 30, height: 20)
        
        tf.rightView = eyeButton
        tf.rightViewMode = .always
        return tf
    }()
    
    private let loginBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Login", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.tintColor = .white
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    private let registerBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Register", for: .normal)
        return btn
    }()
    
    // MARK: - Init
    init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        bindViewModel()
    }
    
    // MARK: - Setup
    private func setupUI() {
        let stack = UIStackView(arrangedSubviews: [
            titleImageView,
            subtitleLabel,
            emailTF,
            passwordTF,
            loginBtn,
            registerBtn
        ])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            titleImageView.heightAnchor.constraint(equalToConstant: 80),
            loginBtn.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        if let eyeButton = passwordTF.rightView as? UIButton {
            eyeButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        }
    }
    
    private func bindViewModel() {
        // Action
        loginBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.viewModel.login(
                    email: self.emailTF.text ?? "",
                    password: self.passwordTF.text ?? ""
                )
            })
            .disposed(by: disposeBag)
        
        registerBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let signUp = SignUpViewCtr(viewModel: self.viewModel) // reuse viewModel
                self.present(UINavigationController(rootViewController: signUp), animated: true)
            })
            .disposed(by: disposeBag)
        
        // Output
        viewModel.isLoading
            .bind(onNext: { [weak self] loading in
                loading ? self?.showLoadingHUD() : self?.hideLoadingHUD()
            })
            .disposed(by: disposeBag)
        
        viewModel.loginSuccess
            .bind(onNext: { [weak self] in
                self?.presentMain()
            })
            .disposed(by: disposeBag)
        
        viewModel.errorMessage
            .bind(onNext: { [weak self] msg in
                self?.showAlert(title: "Error", message: msg)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Actions
    private func presentMain() {
        let tabBarVC = TabBarViewCtr()
        tabBarVC.selectedIndex = 0
        tabBarVC.modalPresentationStyle = .fullScreen
        present(tabBarVC, animated: true)
    }
    
    @objc private func togglePasswordVisibility() {
        passwordTF.isSecureTextEntry.toggle()
        if let eyeButton = passwordTF.rightView as? UIButton {
            let imageName = passwordTF.isSecureTextEntry ? "eye.fill" : "eye.slash.fill"
            eyeButton.setImage(UIImage(systemName: imageName), for: .normal)
        }
    }
}
