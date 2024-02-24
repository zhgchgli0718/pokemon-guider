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
    private let viewModel: PokemonViewModelSpec
    
    private lazy var collectionView = makeCollectionView()
    
    init(viewModel: PokemonViewModelSpec = PokemonViewModel()) {
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
        cell.configure(viewObject: viewModel.cellViewObjects[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 30) / 2 
        let height = (collectionView.frame.height / 4) - 20.0
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

extension PokemonListViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= scrollView.contentSize.height / 2 {
            viewModel.loadPokemonList()
        }
    }
}

private extension PokemonListViewController {
    func binding() {
        viewModel.loadPokemonList()
        
        viewModel.didLoadPokemonList.sink { result in
            print(result)
        } receiveValue: { _ in
            self.collectionView.reloadData()
        }.store(in: &cancelBag)
        
        viewModel.didLoadPokemonDetail.sink { index in
            self.collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
        }.store(in: &cancelBag)
    }
}

private extension PokemonListViewController {
    func layoutUI() {
        navigationItem.title = NSLocalizedString("pokemon_list", comment: "寶可夢")
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func makeCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 14
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.register(PokemonCollectionViewCell.self, forCellWithReuseIdentifier: PokemonCollectionViewCell.className)
        
        return collectionView
    }
}
