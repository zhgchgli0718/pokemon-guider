//
//  PokemonGuiderSnapshotTests.swift
//  PokemonGuiderSnapshotTests
//
//  Created by zhgchgli on 2024/2/24.
//

import XCTest
@testable import PokemonGuider
import SnapshotTesting

final class PokemonGuiderSnapshotTests: XCTestCase {
    func testPokemonCollectionViewCell() {
        let viewObject = PokemonCellViewObject(name: "李奧納多皮卡丘", id: "5566", types: ["flying", "ghost"], coverImage: URL(string: "https://zhgchg.li/fake.png")!)
        let cellView = PokemonCollectionViewCell()
        cellView.configure(viewObject: viewObject)
        cellView.frame.size = CGSize(width: 350, height: 350)
        cellView.layoutIfNeeded()
        assertSnapshot(matching: cellView, as: .image(traits: .init(userInterfaceStyle: .light)), record: false)
    }
}
