//
//  FilterViewCtr.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 12/09/25.
//

import UIKit

final class FilterPokemonViewCtr: BaseViewController {
    
    // MARK: - UI Components
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Filters"
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()
    
    private let generationsStack = UIStackView()
    private let typesStack = UIStackView()
    private let weaknessStack = UIStackView()
    
    private let weightLabel = UILabel()
    private let weightSlider = UISlider()
    
    private let heightLabel = UILabel()
    private let heightSlider = UISlider()
    
    private let orderPicker = UIPickerView()
    private let orderLabel = UILabel()
    
    private let applyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("APPLY", for: .normal)
        button.backgroundColor = .systemYellow
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        return button
    }()
    
    // Data for picker
    private let orderOptions = ["A - Z", "Z - A", "Weight ↑", "Weight ↓", "Height ↑", "Height ↓"]
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupUI()
        setupActions()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        let scrollView = UIScrollView()
        let contentStack = UIStackView()
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
        
        contentStack.axis = .vertical
        contentStack.spacing = 24
        
        // Title
        contentStack.addArrangedSubview(titleLabel)
        
        // Generations
        let genLabel = UILabel()
        genLabel.text = "Generations"
        genLabel.font = .boldSystemFont(ofSize: 18)
        contentStack.addArrangedSubview(genLabel)
        setupButtonStack(generationsStack, titles: ["Generation I", "Generation II", "Generation III", "Generation IV"])
        contentStack.addArrangedSubview(generationsStack)
        
        // Types
        let typesLabel = UILabel()
        typesLabel.text = "Types"
        typesLabel.font = .boldSystemFont(ofSize: 18)
        contentStack.addArrangedSubview(typesLabel)
        setupButtonStack(typesStack, titles: ["Bug", "Dark", "Dragon", "Electric"])
        contentStack.addArrangedSubview(typesStack)
        
        // Weakness
        let weaknessLabel = UILabel()
        weaknessLabel.text = "Weakness"
        weaknessLabel.font = .boldSystemFont(ofSize: 18)
        contentStack.addArrangedSubview(weaknessLabel)
        setupButtonStack(weaknessStack, titles: ["Bug", "Dark", "Dragon", "Electric"])
        contentStack.addArrangedSubview(weaknessStack)
        
        // Weight
        weightLabel.text = "Weight: 50 kg"
        contentStack.addArrangedSubview(weightLabel)
        weightSlider.minimumValue = 0
        weightSlider.maximumValue = 200
        weightSlider.value = 50
        contentStack.addArrangedSubview(weightSlider)
        
        // Height
        heightLabel.text = "Height: 170 cm"
        contentStack.addArrangedSubview(heightLabel)
        heightSlider.minimumValue = 0
        heightSlider.maximumValue = 300
        heightSlider.value = 170
        contentStack.addArrangedSubview(heightSlider)
        
        // Order
        orderLabel.text = "Order"
        orderLabel.font = .boldSystemFont(ofSize: 18)
        contentStack.addArrangedSubview(orderLabel)
        
        orderPicker.dataSource = self
        orderPicker.delegate = self
        contentStack.addArrangedSubview(orderPicker)
        
        // Apply Button
        applyButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        contentStack.addArrangedSubview(applyButton)
    }
    
    private func setupButtonStack(_ stack: UIStackView, titles: [String]) {
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        
        for title in titles {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.setTitleColor(.label, for: .normal)
            button.layer.borderColor = UIColor.systemGray4.cgColor
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 8
            button.titleLabel?.font = .systemFont(ofSize: 14)
            stack.addArrangedSubview(button)
        }
    }
    
    private func setupActions() {
        weightSlider.addTarget(self, action: #selector(weightChanged), for: .valueChanged)
        heightSlider.addTarget(self, action: #selector(heightChanged), for: .valueChanged)
        applyButton.addTarget(self, action: #selector(applyTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func weightChanged() {
        weightLabel.text = "Weight: \(Int(weightSlider.value)) kg"
    }
    
    @objc private func heightChanged() {
        heightLabel.text = "Height: \(Int(heightSlider.value)) cm"
    }
    
    @objc private func applyTapped() {
        dismiss(animated: true)
    }
}

// MARK: - UIPickerView DataSource & Delegate

extension FilterPokemonViewCtr: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        orderOptions.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        orderOptions[row]
    }
}

