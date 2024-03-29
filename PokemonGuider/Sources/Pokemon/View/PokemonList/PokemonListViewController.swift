//
//  PokemonListViewController.swift
//  PokemonGuider
//
//  Created by zhgchgli on 2024/2/24.
//

import Foundation
import UIKit
import Combine

final class PokemonListViewController: UIViewController {
    
    private var cancelBag = Set<AnyCancellable>()
    private var viewModel: PokemonListViewModelSpec
    
    private lazy var collectionView = makeCollectionView()
    
    init(viewModel: PokemonListViewModelSpec = PokemonListViewModel()) {
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

extension PokemonListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cellViewObjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCollectionViewCell.className, for: indexPath)
        guard let cell = cell as? PokemonCollectionViewCell else { return cell }
        let viewObject = viewModel.cellViewObjects[indexPath.row]
        cell.delegate = self
        cell.configure(viewObject: viewObject)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat
        let height: CGFloat
        if viewModel.girdViewStyle {
            width = (collectionView.frame.width - 30) / 2
            height = (collectionView.frame.height / 4) - 20.0
        } else {
            width = collectionView.frame.width - 20
            height = (collectionView.frame.height / 2) - 20.0
        }
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            return UICollectionReusableView(frame: .zero)
        } else {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PokemonListHeaderView.className, for: indexPath)
            if let header = header as? PokemonListHeaderView {
                header.configure(owned: viewModel.onlyDisplayOwnedPokemon, gridViewStyle: viewModel.girdViewStyle)
                header.delegate = self
            }
            return header
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
}

extension PokemonListViewController: PokemonListHeaderViewDelegate {
    func pokemonListHeaderView(_ view: PokemonListHeaderView, didTapOwned owned: Bool) {
        viewModel.onlyDisplayOwnedPokemon = owned
    }
    
    func pokemonListHeaderView(_ view: PokemonListHeaderView, didTapToggleViewStyle grid: Bool) {
        viewModel.girdViewStyle = grid
        collectionView.reloadData()
    }
}

extension PokemonListViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Trigger Load More...
        if maximumOffset - currentOffset <= scrollView.contentSize.height / 2 {
            viewModel.loadPokemonList()
        }
    }
}

extension PokemonListViewController: PokemonCollectionViewCellDelegate {
    func pokemonCollectionViewCell(_ view: PokemonCollectionViewCell, viewDidTap id: String) {
        viewModel.tapPokemon(id: id)
    }
    
    func pokemonCollectionViewCell(_ view: PokemonCollectionViewCell, starDidTap id: String, owned: Bool) {
        viewModel.ownPokemon(id: id, owned: owned)
    }
}


private extension PokemonListViewController {
    func binding() {
        viewModel.loadPokemonList()
        
        viewModel.didLoadPokemonList.sink { result in
            //
        } receiveValue: { [weak self] _ in
            guard let self = self else { return }
            self.collectionView.reloadData()
        }.store(in: &cancelBag)
        
        viewModel.ownedPokemonChanges().sink(receiveValue: { [weak self] indexPath in
            guard let self = self else { return }
            (self.collectionView.cellForItem(at: indexPath) as? PokemonCollectionViewCell)?.configure(viewObject: self.viewModel.cellViewObjects[indexPath.row])
            self.collectionView.reloadItems(at: [indexPath])
        }).store(in: &cancelBag)
    }
}

private extension PokemonListViewController {
    func layoutUI() {
        navigationItem.title = NSLocalizedString("pokemon_list", comment: "所有寶可夢")
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func makeCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 14
        layout.sectionHeadersPinToVisibleBounds = true
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.register(PokemonCollectionViewCell.self, forCellWithReuseIdentifier: PokemonCollectionViewCell.className)
        collectionView.register(PokemonListHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PokemonListHeaderView.className)
        return collectionView
    }
}
