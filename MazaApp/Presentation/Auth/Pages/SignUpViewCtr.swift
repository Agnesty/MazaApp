//
//  SignUpViewCtr.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 03/09/25.
//

import UIKit
import RxSwift
import RxCocoa
import MBProgressHUD

final class SignUpViewCtr: BaseViewController {
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
        label.text = "Sign Up"
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let fullNameTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Full Name"
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    private let usernameTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .none
        return tf
    }()
    
    private let emailTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        return tf
    }()
    
    private let phoneTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Phone Number"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .phonePad
        return tf
    }()
    
    private let locationTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Location"
        tf.borderStyle = .roundedRect
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
    
    private let registerBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Register", for: .normal)
        btn.backgroundColor = .systemGreen
        btn.tintColor = .white
        btn.layer.cornerRadius = 8
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
        title = "Register"
        
        setupUI()
        bindViewModel()
    }
    
    // MARK: - Setup
    private func setupUI() {
        let stack = UIStackView(arrangedSubviews: [
            titleImageView,
            subtitleLabel,
            fullNameTF,
            usernameTF,
            emailTF,
            phoneTF,
            locationTF,
            passwordTF,
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
            registerBtn.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        if let eyeButton = passwordTF.rightView as? UIButton {
            eyeButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        }
    }
    
    private func bindViewModel() {
        // Action
        registerBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.viewModel.register(
                    username: self.usernameTF.text ?? "",
                    fullName: self.fullNameTF.text ?? "",
                    email: self.emailTF.text ?? "",
                    phone: self.phoneTF.text ?? "",
                    location: self.locationTF.text ?? "",
                    password: self.passwordTF.text ?? ""
                )
            })
            .disposed(by: disposeBag)
        
        // Output
        viewModel.isLoading
            .bind(onNext: { [weak self] loading in
                loading ? self?.showLoadingHUD() : self?.hideLoadingHUD()
            })
            .disposed(by: disposeBag)
        
        viewModel.successMessage
            .bind(onNext: { [weak self] msg in
                self?.showAlert(title: "Sukses", message: msg) {
                    self?.dismiss(animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.errorMessage
            .bind(onNext: { [weak self] msg in
                self?.showAlert(title: "Error", message: msg)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Actions
    @objc private func togglePasswordVisibility() {
        passwordTF.isSecureTextEntry.toggle()
        if let eyeButton = passwordTF.rightView as? UIButton {
            let imageName = passwordTF.isSecureTextEntry ? "eye.fill" : "eye.slash.fill"
            eyeButton.setImage(UIImage(systemName: imageName), for: .normal)
        }
    }
}
