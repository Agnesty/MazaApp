//
//  SignInViewCtr.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 08/02/25.
//

import UIKit
import RealmSwift
import RxSwift
import MBProgressHUD

class SignInViewCtr: BaseViewController {
    private let auth: AuthRepositoryProtocol = AuthRepositoryService()
    private let disposeBag = DisposeBag()
    
    private let titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Maza")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupUI()
        bindActions()
    }
    
    private func setupUI() {
        let stack = UIStackView(arrangedSubviews: [titleImageView, subtitleLabel, emailTF, passwordTF, loginBtn, registerBtn])
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
    
    private func bindActions() {
        loginBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                MBProgressHUD.showAdded(to: self.view, animated: true)
                
                let email = self.emailTF.text ?? ""
                let password = self.passwordTF.text ?? ""
                
                self.auth.login(email: email, password: password)
                    .asObservable()
                    .observe(on: MainScheduler.instance)
                    .subscribe(
                        onError: { error in
                            MBProgressHUD.hide(for: self.view, animated: true)
                            print("Login gagal: \(error.localizedDescription)")
                            self.showAlert(title: "Gagal Login", message: "Username atau password salah")
                        }, onCompleted: {
                            MBProgressHUD.hide(for: self.view, animated: true)
                            print("Login berhasil")
                            self.presentMain()
                        }
                    )
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
        
        registerBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.present(UINavigationController(rootViewController: SignUpViewCtr()), animated: true)
            }).disposed(by: disposeBag)
    }
    
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
