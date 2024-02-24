//
//  PokemonCollectionViewCell.swift
//  PokemonGuider
//
//  Created by zhgchgli on 2024/2/24.
//

import UIKit
import SnapKit

class PokemonCollectionViewCell: UICollectionViewCell {
    private lazy var idView = makeIDView()
    private lazy var idLabel = makeIDLabel()
    private lazy var coverImageView = makeCoverImageView()
    private lazy var nameLabel = makeNameLabel()
    private lazy var typesStackView = makeTypesStackView()
    
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
        nameLabel.text = viewObject.name
        idLabel.text = viewObject.id
        viewObject.types.forEach { type in
            let button = makeTypeButton()
            button.setTitle(type, for: .normal)
            typesStackView.addArrangedSubview(button)
        }
        typesStackView.addArrangedSubview(UIView())
        coverImageView.setImage(url: viewObject.coverImage)
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
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .lightGray
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
}
