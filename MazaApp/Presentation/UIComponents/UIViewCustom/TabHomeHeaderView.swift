//
//  TabHomeHeaderView.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 29/07/25.
//

import Foundation
import UIKit
import SnapKit

class TabMenuHeaderView: UIView {

    var didSelectTab: ((Int) -> Void)?

    private var tabLabels: [UILabel] = []
    private var underlineView = UIView()
    private var selectedIndex: Int = 0

    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 0
        sv.alignment = .fill
        sv.distribution = .fillEqually
        sv.backgroundColor = .clear
        return sv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.05
        layer.shadowOffset = CGSize(width: 0, height: 2)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        addSubview(stackView)
        stackView.snp.makeConstraints { $0.edges.equalToSuperview() }

        // underline setup
        underlineView.backgroundColor = .systemGreen
        underlineView.layer.cornerRadius = 1.5
        underlineView.clipsToBounds = true
        addSubview(underlineView)
    }

    func configureTabs(_ tabs: [TabsHomeMenu]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        tabLabels.removeAll()

        for (index, tab) in tabs.enumerated() {
            let label = UILabel()
            label.text = tab.tabName
            label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            label.textColor = .label
            label.textAlignment = .center
            label.isUserInteractionEnabled = true
            label.tag = index

            let tap = UITapGestureRecognizer(target: self, action: #selector(tabTapped(_:)))
            label.addGestureRecognizer(tap)

            stackView.addArrangedSubview(label)
            tabLabels.append(label)
        }

        layoutIfNeeded()
        setSelectedTab(0, animated: false)
    }

    @objc private func tabTapped(_ gesture: UITapGestureRecognizer) {
        guard let index = gesture.view?.tag else { return }
        setSelectedTab(index, animated: true)
        didSelectTab?(index)
    }

    func setSelectedTab(_ index: Int, animated: Bool = true) {
        selectedIndex = index
        for (i, label) in tabLabels.enumerated() {
            label.textColor = i == index ? .systemGreen : .label
            label.font = i == index
                ? UIFont.systemFont(ofSize: 14, weight: .semibold)
                : UIFont.systemFont(ofSize: 14, weight: .regular)
        }

        guard index < tabLabels.count else { return }
        let selectedLabel = tabLabels[index]
        let labelFrame = selectedLabel.superview!.convert(selectedLabel.frame, to: self)

        // ukur teks
        let textSize = selectedLabel.intrinsicContentSize
        let underlineHeight: CGFloat = 2
        let padding: CGFloat = 8

        // ambil tinggi teks sesuai font → baseline + descender
        let font = selectedLabel.font!
        let textY = labelFrame.midY - textSize.height / 2
        let baselineOffset = font.ascender + font.descender  // total tinggi
        let yPosition = textY + baselineOffset + 8 // +2 biar ada sedikit spasi tipis

        // hitung posisi underline di tengah teks
        let textX = labelFrame.midX - (textSize.width + padding) / 2

        let newFrame = CGRect(
            x: textX,
            y: yPosition,
            width: textSize.width + padding,
            height: underlineHeight
        )

        if animated {
            UIView.animate(withDuration: 0.25,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0.5,
                           options: .curveEaseInOut) {
                self.underlineView.frame = newFrame
            }
        } else {
            underlineView.frame = newFrame
        }
    }
}

