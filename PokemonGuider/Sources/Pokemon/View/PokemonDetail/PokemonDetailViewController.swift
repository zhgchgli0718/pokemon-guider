//
//  PokemonDetailViewController.swift
//  PokemonGuider
//
//  Created by zhgchgli on 2024/2/25.
//

import Foundation
import UIKit
import Combine

protocol PokemonDetailViewControllerDelegate: AnyObject {
    func pokemonDetailViewController(_ viewController: PokemonDetailViewController, pokemonDidTap id: String)
}

final class PokemonDetailViewController: UIViewController {
    
    private lazy var scrollView = makeScrollView()
    private lazy var scrollViewContentView = makeScrollViewContentView()
    private lazy var coverImageViewsScrollView = makeCoverImageViewsScrollView()
    private lazy var coverImageViewsStackView = makeCoverImageViewsStackView()
    private lazy var ownButton = makeOwnButton()
    private lazy var idLabel = makeIDLabel()
    private lazy var typesStackView = makeTypesStackView()
    private lazy var statsStackView = makeStatsStackView()
    private lazy var evolutionChainStackView = makeEvolutionChainStackView()
    private lazy var pokedexLabel = makePokedexLabel()
    private lazy var statTitleLabel = makeStatTitleLabel()
    private lazy var evolutionChainTitleLabel = makeEvolutionChainTitleLabel()
    
    private var cancelBag = Set<AnyCancellable>()
    private let viewModel: PokemonDetailViewModelSpec
    
    weak var delegate: PokemonDetailViewControllerDelegate?
    
    init(viewModel: PokemonDetailViewModelSpec) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        layoutUI()
        binding()
    }
}

private extension PokemonDetailViewController {
    func binding() {
        viewModel.loadPokemonDetail().sink { result in
            //
        } receiveValue: { model in
            self.navigationItem.title = model.name
            model.images.forEach { image in
                if let imageURL = URL(string: image) {
                    let imageView = self.makeCoverImage()
                    imageView.setImage(url: imageURL)
                    self.coverImageViewsStackView.addArrangedSubview(imageView)
                    imageView.snp.makeConstraints { make in
                        make.width.equalTo(self.view.snp.width)
                    }
                }
            }
            
            model.types.forEach { type in
                let button = self.makeTypeButton()
                button.setTitle(type.name, for: .normal)
                self.typesStackView.addArrangedSubview(button)
            }
            self.typesStackView.addArrangedSubview(UIView())
            
            self.configureStatsView(stats: model.staus)
        }.store(in: &cancelBag)
        //
        viewModel.loadPokemonPokedex().sink { result in
            //
        } receiveValue: { model in
            self.pokedexLabel.text = model.currentLanguageDescription?.description
        }.store(in: &cancelBag)
        //
        viewModel.loadPokemonEvolutionChain().sink { result in
            //
        } receiveValue: { model in
            self.configureEvolutionChainStackView(models: model)
        }.store(in: &cancelBag)
        //
        ownButton.isSelected = viewModel.isOwnedPokemon()
        //
        viewModel.ownedPokemonChanges().sink { owned in
            self.ownButton.isSelected = owned
        }.store(in: &cancelBag)
        
    }
}

private extension PokemonDetailViewController {
    func layoutUI() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        view.addSubview(ownButton)
        scrollView.addSubview(scrollViewContentView)
        scrollViewContentView.addSubview(coverImageViewsScrollView)
        coverImageViewsScrollView.addSubview(coverImageViewsStackView)
        
        scrollViewContentView.addSubview(idLabel)
        scrollViewContentView.addSubview(typesStackView)
        scrollViewContentView.addSubview(statsStackView)
        scrollViewContentView.addSubview(evolutionChainStackView)
        scrollViewContentView.addSubview(pokedexLabel)
        scrollViewContentView.addSubview(statTitleLabel)
        scrollViewContentView.addSubview(evolutionChainTitleLabel)
        
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        
        scrollViewContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view.snp.width)
        }
        
        ownButton.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(12)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        coverImageViewsScrollView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(250)
        }
        
        coverImageViewsStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(250)
        }
        
        idLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.top.equalTo(coverImageViewsScrollView.snp.bottom).offset(12)
        }
        
        pokedexLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.top.equalTo(idLabel.snp.bottom).offset(12)
        }
        
        typesStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.top.equalTo(pokedexLabel.snp.bottom).offset(12)
        }
        
        statTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.top.equalTo(typesStackView.snp.bottom).offset(12)
        }
        
        statsStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.top.equalTo(statTitleLabel.snp.bottom).offset(12)
        }
        
        evolutionChainTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.top.equalTo(statsStackView.snp.bottom).offset(12)
        }
        
        evolutionChainStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.top.equalTo(evolutionChainTitleLabel.snp.bottom).offset(12)
            make.bottom.equalToSuperview().inset(12)
        }
    }
    
    func makeScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        
        return scrollView
    }
    
    func makeScrollViewContentView() -> UIView {
        let view = UIView()
        return view
    }
    
    func makeCoverImageViewsScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = true
        scrollView.alwaysBounceVertical = false
        scrollView.isPagingEnabled = true
        return scrollView
    }
    
    func makeOwnButton() -> UIButton {
        var configuration = UIButton.Configuration.filled()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15)
        let button = UIButton(configuration: configuration)
        button.backgroundColor = .salmon
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .systemFont(ofSize: 18)
        
        button.setTitleColor(.white, for: .normal)
        button.setTitle(NSLocalizedString("own", comment: "收錄"), for: .normal)
        button.setTitle(NSLocalizedString("owned", comment: "已收錄"), for: .selected)

        button.addTarget(self, action: #selector(ownButtonDidTap(_:)), for: .touchUpInside)
        return button
    }
    
    func makeCoverImageViewsStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }
    
    func makeCoverImage() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = .add
        return imageView
    }
    
    func makeIDLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        label.textColor = .navy
        label.text = "ID: \(viewModel.id)"
        return label
    }
    
    func makeTypesStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.spacing = 3
        stackView.distribution = .fill
        return stackView
    }
    
    func makeTypeButton() -> UIButton {
        var configuration = UIButton.Configuration.filled()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        let button = UIButton(configuration: configuration)
        button.backgroundColor = .salmon
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .systemFont(ofSize: 12)
        return button
    }
    
    func makeStatsStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }
    
    func configureStatsView(stats: [PokemonDetailModel.Stats]) {
        self.statsStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        //
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(self.makeStatLabel(text: NSLocalizedString("stat", comment: "屬性")))
        stackView.addArrangedSubview(self.makeStatLabel(text: NSLocalizedString("stat_base", comment: "數值")))
        stackView.addArrangedSubview(self.makeStatLabel(text: NSLocalizedString("stat_effort", comment: "效果")))
        self.statsStackView.addArrangedSubview(stackView)
        
        stats.forEach { stats in
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            stackView.addArrangedSubview(self.makeStatLabel(text: stats.stat.name))
            stackView.addArrangedSubview(self.makeStatLabel(text: String(describing: stats.base_stat)))
            stackView.addArrangedSubview(self.makeStatLabel(text: String(describing: stats.effort)))
            self.statsStackView.addArrangedSubview(stackView)
        }
        
    }
    
    func makeStatTitleLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .navy
        label.font = .systemFont(ofSize: 24, weight: .heavy)
        label.text = NSLocalizedString("stat", comment: "屬性")
        return label
    }
    
    func makeStatLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        return label
    }
    
    func makeEvolutionChainStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }
    
    func makeEvolutionChainTitleLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .navy
        label.font = .systemFont(ofSize: 24, weight: .heavy)
        label.text = NSLocalizedString("evolution", comment: "進化")
        return label
    }
    
    func makeEvolutionChainButton(text: String) -> ClickableButton {
        let button = ClickableButton(type: .custom)
        button.setTitleColor(.navy, for: .normal)
        button.setTitle(text, for: .normal)
        button.addTarget(self, action: #selector(evolutionChainButtonDidTap(_:)), for: .touchUpInside)
        return button
    }
    
    func configureEvolutionChainStackView(models: [PokemonDetailModel]) {
        self.evolutionChainStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        //
        
        for (index, model) in models.enumerated() {
            let button = self.makeEvolutionChainButton(text: model.name)
            button.id = model.id
            self.evolutionChainStackView.addArrangedSubview(button)
            if index < models.count - 1 {
                self.evolutionChainStackView.addArrangedSubview(self.makeStatLabel(text: "⬇️"))
            }
        }
    }
    
    func makePokedexLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }
}

private extension PokemonDetailViewController {
    @objc func evolutionChainButtonDidTap(_ button: ClickableButton) {
        guard let id = button.id else { return }
        delegate?.pokemonDetailViewController(self, pokemonDidTap: id)
    }
    
    @objc func ownButtonDidTap(_ button: UIButton) {
        viewModel.ownPokemon(owned: !button.isSelected)
    }
}

fileprivate class ClickableButton: UIButton {
    var id: String?
}

