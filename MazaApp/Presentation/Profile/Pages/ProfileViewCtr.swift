//
//  ProfileViewCtr.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 08/02/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ProfileViewCtr: BaseViewController {
    
    private let headerContainer = UIView()
    private let contentStack = UIStackView()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Profile"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    private let settingsIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "gearshape")
        imageView.tintColor = .black
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let avatarImageView = UIImageView()
    private let editButton = UIButton()
    
    private let nameLabel = UILabel()
    private let nameField = CustomTextField(placeholder: "Your Name")
    
    private let emailLabel = UILabel()
    private let emailField = CustomTextField(placeholder: "Your Email")
    
    private let phoneLabel = UILabel()
    private let phoneStack = UIStackView()
    private let countryCodeView = UIButton()
    private let phoneField = CustomTextField(placeholder: "Your Phone Number")
    
    private let locationLabel = UILabel()
    private let locationField = CustomTextField(placeholder: "Your Location")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        loadUserData()
    }
    
    private func setupUI() {
        // Stack utama
        view.addSubview(headerContainer)
        headerContainer.addSubview(titleLabel)
        headerContainer.addSubview(settingsIcon)
        view.addSubview(contentStack)
        contentStack.axis = .vertical
        contentStack.spacing = 20
        contentStack.alignment = .fill
        
        headerContainer.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        settingsIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.size.equalTo(26)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        contentStack.snp.makeConstraints { make in
            make.top.equalTo(headerContainer.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        let avatarContainer = UIView()
        avatarContainer.snp.makeConstraints { make in
            make.height.equalTo(120)
        }
        
        avatarContainer.addSubview(avatarImageView)
        avatarContainer.addSubview(editButton)
        
        avatarImageView.image = UIImage(systemName: "person.circle.fill")
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.cornerRadius = 50
        avatarImageView.clipsToBounds = true
        
        avatarImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(100)
        }
        
        editButton.setImage(UIImage(systemName: "pencil.circle.fill"), for: .normal)
        editButton.tintColor = .systemRed
        editButton.snp.makeConstraints { make in
            make.size.equalTo(28)
            make.bottom.right.equalTo(avatarImageView).inset(4)
        }
        
        contentStack.addArrangedSubview(avatarContainer)
        
        nameLabel.text = "Name"
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        contentStack.addArrangedSubview(nameLabel)
        contentStack.addArrangedSubview(nameField)
        
        emailLabel.text = "E-mail"
        emailLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        contentStack.addArrangedSubview(emailLabel)
        contentStack.addArrangedSubview(emailField)
        
        phoneLabel.text = "Phone Number"
        phoneLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        contentStack.addArrangedSubview(phoneLabel)
        
        phoneStack.axis = .horizontal
        phoneStack.spacing = 8
        phoneStack.distribution = .fill
        
        countryCodeView.setTitle("🇮🇩 +62", for: .normal)
        countryCodeView.setTitleColor(.black, for: .normal)
        countryCodeView.backgroundColor = UIColor.systemGray6
        countryCodeView.layer.cornerRadius = 10
        
        countryCodeView.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
        
        phoneField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        phoneStack.addArrangedSubview(countryCodeView)
        phoneStack.addArrangedSubview(phoneField)
        
        contentStack.addArrangedSubview(phoneStack)
        
        locationLabel.text = "Location"
        locationLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        contentStack.addArrangedSubview(locationLabel)
        contentStack.addArrangedSubview(locationField)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(settingsTapped))
        settingsIcon.addGestureRecognizer(tapGesture)
    }
    
    private func loadUserData() {
        if let user = AuthRepositoryService.shared.currentUser() {
            nameField.text = user.fullName
            emailField.text = user.email
            phoneField.text = user.phone
            locationField.text = user.location
        }
    }
    
    @objc private func settingsTapped() {
        let settingsVC = SettingsViewCtr()
        settingsVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(settingsVC, animated: true)
    }
}

class CustomTextField: UITextField {
    init(placeholder: String) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        self.borderStyle = .none
        self.backgroundColor = UIColor.systemGray6
        self.layer.cornerRadius = 10
        self.setLeftPaddingPoints(12)
        self.setRightPaddingPoints(12)
        
        self.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
