//
//  SettingsViewCtr.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 03/09/25.
//

import UIKit
import SnapKit

class SettingsViewCtr: BaseViewController {
    
    private let auth: AuthRepositoryProtocol = AuthRepositoryService()
    private let topBarView = TopBarView()
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private let sections: [[String]] = [
        ["Ubah Profil", "Daftar Alamat", "Keamanan Akun", "Notifikasi", "Privasi Akun"],
        ["Keluar Akun"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        topBarView.backgroundColor = tableView.backgroundColor
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(topBarView)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        topBarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(topBarView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.snp.bottom)
        }
        
        topBarView.setRightVisibility()
        topBarView.setLeftVisibility(showBack: true, showTitle: true)
        topBarView.setTitle("Settings")
        
        topBarView.onBackButtonTapped = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    private func logout() {
        auth.logout()
        let signInVC = SignInViewCtr()
        let nav = UINavigationController(rootViewController: signInVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
}

extension SettingsViewCtr: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = sections[indexPath.section][indexPath.row]
        cell.textLabel?.text = item
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = sections[indexPath.section][indexPath.row]
        print("Tapped: \(item)")
        
        if item == "Keluar Akun" {
            logout()
        }
    }
}
