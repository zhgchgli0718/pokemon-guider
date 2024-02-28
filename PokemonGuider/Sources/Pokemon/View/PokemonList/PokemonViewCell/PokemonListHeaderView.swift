//
//  PokemonListHeaderView.swift
//  PokemonGuider
//
//  Created by zhgchgli on 2024/2/25.
//

import Foundation
import UIKit

protocol PokemonListHeaderViewDelegate: AnyObject {
    func pokemonListHeaderView(_ view: PokemonListHeaderView, didTapOwned owned: Bool)
    func pokemonListHeaderView(_ view: PokemonListHeaderView, didTapToggleViewStyle grid: Bool)
}

class PokemonListHeaderView: UICollectionReusableView {
    
    private lazy var ownedOnlyButton = makeOwnedOnlyButton()
    private lazy var viewStyleToggleButton = makeViewStyleToggleButton()
    
    weak var delegate: PokemonListHeaderViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(owned: Bool, gridViewStyle: Bool) {
        ownedOnlyButton.isSelected = owned
        viewStyleToggleButton.isSelected = gridViewStyle
    }
}

private extension PokemonListHeaderView {
    func layoutUI () {
        backgroundColor = .black.withAlphaComponent(0.5)
        addSubview(ownedOnlyButton)
        addSubview(viewStyleToggleButton)
        
        ownedOnlyButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().inset(5)
            make.trailing.equalToSuperview().inset(15)
        }
        
        viewStyleToggleButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().inset(5)
            make.trailing.equalTo(ownedOnlyButton.snp.leading).inset(-15)
        }
    }
    
    func makeOwnedOnlyButton() -> UIButton {
        var configuration = UIButton.Configuration.filled()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        let button = UIButton(configuration: configuration)
        button.tintColor = .navy
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        button.setTitle(NSLocalizedString("own", comment: "收藏"), for: .normal)
        button.setTitle(NSLocalizedString("owned", comment: "已收藏"), for: .selected)
        
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.addTarget(self, action: #selector(ownedOnlyButtonDidTap(_:)), for: .touchUpInside)
        return button
    }
    
    func makeViewStyleToggleButton() -> UIButton {
        var configuration = UIButton.Configuration.filled()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        let button = UIButton(configuration: configuration)
        button.tintColor = .navy
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        button.setTitle(NSLocalizedString("grid_view", comment: "格狀檢視"), for: .normal)
        button.setTitle(NSLocalizedString("list_view", comment: "列表檢視"), for: .selected)
        button.isSelected = true
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.addTarget(self, action: #selector(viewStyleToggleButtonDidTap(_:)), for: .touchUpInside)
        return button
    }
}

private extension PokemonListHeaderView {
    @objc func ownedOnlyButtonDidTap(_ button: UIButton) {
        delegate?.pokemonListHeaderView(self, didTapOwned: !button.isSelected)
        button.isSelected = !button.isSelected
    }
    
    @objc func viewStyleToggleButtonDidTap(_ button: UIButton) {
        delegate?.pokemonListHeaderView(self, didTapToggleViewStyle: !button.isSelected)
        button.isSelected = !button.isSelected
    }
}
