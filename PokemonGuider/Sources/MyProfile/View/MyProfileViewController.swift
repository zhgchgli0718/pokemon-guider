//
//  MyProfileViewController.swift
//  PokemonGuider
//
//  Created by zhgchgli on 2024/2/24.
//

import Foundation
import UIKit
import SnapKit

final class MyProfileViewController: UIViewController {
    
    private lazy var coverImageView = makeImageView()
    private lazy var subTitleLabel = makeSubTitleLabel()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        layoutUI()
    }
}

private extension MyProfileViewController {
    func layoutUI() {
        view.addSubview(coverImageView)
        view.addSubview(subTitleLabel)

        coverImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 100, height: 100))
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(coverImageView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    func makeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "hammer.circle")
        return imageView
    }
    
    func makeSubTitleLabel() -> UILabel {
        let label = UILabel()
        label.text = NSLocalizedString("to_be_continuted", comment: "敬請期待")
        label.textColor = .salmon
        label.textAlignment = .center
        return label
    }
}
