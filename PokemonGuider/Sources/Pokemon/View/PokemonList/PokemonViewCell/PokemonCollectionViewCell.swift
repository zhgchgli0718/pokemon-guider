//
//  PokemonCollectionViewCell.swift
//  PokemonGuider
//
//  Created by zhgchgli on 2024/2/24.
//

import UIKit
import SnapKit

protocol PokemonCollectionViewCellDelegate: AnyObject {
    func pokemonCollectionViewCell(_ view: PokemonCollectionViewCell, viewDidTap id: String)
    func pokemonCollectionViewCell(_ view: PokemonCollectionViewCell, starDidTap id: String, owned: Bool)
}

class PokemonCollectionViewCell: UICollectionViewCell {
    private lazy var idView = makeIDView()
    private lazy var idLabel = makeIDLabel()
    private lazy var coverImageView = makeCoverImageView()
    private lazy var nameLabel = makeNameLabel()
    private lazy var typesStackView = makeTypesStackView()
    private lazy var ownStarButton = makeOwnStarButton()
    
    weak var delegate: PokemonCollectionViewCellDelegate?
    
    private var viewObject: PokemonCellViewObject?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        // Clean StackView
        typesStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
    }
    
    func configure(viewObject: PokemonCellViewObject) {
        self.viewObject = viewObject
        
        nameLabel.text = viewObject.name
        idLabel.text = viewObject.id
        viewObject.types.forEach { type in
            let button = makeTypeButton()
            button.setTitle(type, for: .normal)
            typesStackView.addArrangedSubview(button)
        }
        typesStackView.addArrangedSubview(UIView())
        
        if let coverImage = viewObject.coverImage {
            coverImageView.setImage(url: coverImage)
            coverImageView.backgroundColor = .clear
        } else {
            coverImageView.image = nil
            coverImageView.backgroundColor = .lightGray
        }
        
        ownStarButton.isSelected = viewObject.owned
    }
}

private extension PokemonCollectionViewCell {
    func layoutUI() {
        backgroundColor = .white
        self.addSubview(coverImageView)
        self.addSubview(nameLabel)
        self.addSubview(typesStackView)
        self.addSubview(idView)
        self.addSubview(idLabel)
        self.addSubview(ownStarButton)
        
        coverImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(coverImageView.snp.bottom).offset(12)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        typesStackView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(12)
            make.bottom.equalToSuperview().inset(12)
            make.height.equalTo(25)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        idView.snp.makeConstraints { make in
            make.top.equalTo(coverImageView.snp.top)
            make.leading.equalTo(coverImageView.snp.leading)
        }
        
        idLabel.snp.makeConstraints { make in
            make.edges.equalTo(idView.snp.edges).inset(5)
        }
        
        ownStarButton.snp.makeConstraints { make in
            make.top.equalTo(coverImageView.snp.top)
            make.trailing.equalTo(coverImageView.snp.trailing)
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func makeIDView() -> UIView {
        let view = UIView()
        view.backgroundColor = .navy.withAlphaComponent(0.5)
        return view
    }
    
    func makeIDLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 12)
        return label
    }
    
    func makeCoverImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        return imageView
    }
    
    func makeNameLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .heavy)
        label.textColor = .navy
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
    
    func makeOwnStarButton() -> UIButton {
        var configuration = UIButton.Configuration.filled()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let button = UIButton(configuration: configuration)
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.setImage(UIImage(systemName: "star.fill"), for: .selected)
        button.addTarget(self, action: #selector(ownedStar(_:)), for: .touchUpInside)
        return button
    }
}

private extension PokemonCollectionViewCell {
    @objc func viewDidTap() {
        guard let id = viewObject?.id else { return }
        delegate?.pokemonCollectionViewCell(self, viewDidTap: id)
    }
    
    @objc func ownedStar(_ button: UIButton) {
        guard let id = viewObject?.id else { return }
        delegate?.pokemonCollectionViewCell(self, starDidTap: id, owned: !button.isSelected)
    }
}
