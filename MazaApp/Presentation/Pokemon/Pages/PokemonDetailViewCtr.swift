//
//  PokemonDetailViewCtr.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 12/09/25.
//

import UIKit

final class PokemonDetailViewCtr: BaseViewController {
    
    private let pokemon: Pokemon
    private let stats: PokemonStats
    
    // MARK: - UI
    private let topBarView = TopBarView()
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    
    private let imageView = UIImageView()
    private let numberLabel = UILabel()
    private let nameLabel = UILabel()
    private let typeLabel = UILabel()
    
    private let segmentedControl: UISegmentedControl = {
        let seg = UISegmentedControl(items: ["About", "Stats", "Moves", "Evolutions"])
        seg.selectedSegmentIndex = 1
        return seg
    }()
    
    private let statsStack = UIStackView()
    
    // MARK: - Init
    init(pokemon: Pokemon, stats: PokemonStats) {
           self.pokemon = pokemon
           self.stats = stats
           super.init(nibName: nil, bundle: nil)
       }
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupStats()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.addSubview(topBarView)
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)
        
        topBarView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBarView.heightAnchor.constraint(equalToConstant: 44),

            scrollView.topAnchor.constraint(equalTo: topBarView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        contentStack.axis = .vertical
        contentStack.spacing = 16
        contentStack.alignment = .center
        
        numberLabel.text = "#\(pokemon.id)"
        numberLabel.font = .boldSystemFont(ofSize: 18)
        
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        if let imageUrl = pokemon.imageUrl, let url = URL(string: imageUrl) {
            loadImage(from: url, into: imageView)
        }
        
        nameLabel.text = pokemon.name.capitalized
        nameLabel.font = .boldSystemFont(ofSize: 24)
        
        typeLabel.text = pokemon.types.joined(separator: ", ")
        typeLabel.font = .systemFont(ofSize: 16)
        typeLabel.textColor = .secondaryLabel
        
        segmentedControl.addTarget(self, action: #selector(segChanged), for: .valueChanged)
        
        statsStack.axis = .vertical
        statsStack.spacing = 12
        statsStack.alignment = .fill
        
        contentStack.addArrangedSubview(numberLabel)
        contentStack.addArrangedSubview(imageView)
        contentStack.addArrangedSubview(nameLabel)
        contentStack.addArrangedSubview(typeLabel)
        contentStack.addArrangedSubview(segmentedControl)
        contentStack.addArrangedSubview(statsStack)
        
        topBarView.setLeftVisibility(showBack: true)
        topBarView.onBackButtonTapped = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    private func setupStats() {
           statsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
           
           let statValues: [(String, Int)] = [
               ("HP", stats.hp),
               ("Attack", stats.attack),
               ("Defence", stats.defense),
               ("Sp. Atk", stats.spAttack),
               ("Sp. Def", stats.spDefense),
               ("Speed", stats.speed)
           ]
           
           for (title, value) in statValues {
               let row = makeStatRow(title: title, value: value)
               statsStack.addArrangedSubview(row)
           }
       }
    
    private func makeStatRow(title: String, value: Int) -> UIView {
        let row = UIStackView()
        row.axis = .horizontal
        row.spacing = 8
        row.alignment = .center
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        let valueLabel = UILabel()
        valueLabel.text = "\(value)"
        valueLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        let barStack = UIStackView()
        barStack.axis = .horizontal
        barStack.spacing = 4
        for i in 0..<15 {
            let bar = UIView()
            bar.layer.cornerRadius = 3
            bar.backgroundColor = i < value/10 ? .systemYellow : .systemGray4
            bar.widthAnchor.constraint(equalToConstant: 10).isActive = true
            bar.heightAnchor.constraint(equalToConstant: 20).isActive = true
            barStack.addArrangedSubview(bar)
        }
        
        row.addArrangedSubview(titleLabel)
        row.addArrangedSubview(valueLabel)
        row.addArrangedSubview(barStack)
        return row
    }
    
    @objc private func segChanged() {
        if segmentedControl.selectedSegmentIndex == 1 {
            setupStats()
        } else {
            statsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
            let label = UILabel()
            label.text = "Content for \(segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex) ?? "")"
            statsStack.addArrangedSubview(label)
        }
    }
    
    private func loadImage(from url: URL, into imageView: UIImageView) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let img = UIImage(data: data) {
                DispatchQueue.main.async {
                    imageView.image = img
                }
            }
        }
    }
}

