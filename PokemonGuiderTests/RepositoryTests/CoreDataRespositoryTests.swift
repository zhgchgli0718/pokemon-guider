//
//  CoreDataRespositoryTests.swift
//  PokemonGuiderTests
//
//  Created by zhgchgli on 2024/2/28.
//

import XCTest
@testable import PokemonGuider
import Combine
import CoreData

final class CoreDataRespositoryTests: XCTestCase {
    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataManager.modelName)
        
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error {
                print(error)
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    private var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    override func setUp() {
        viewContext.reset()
    }
    
    func testSaveAndGetPokemon() {
        let coreDataRespository = CoreDataRespository(context: self.viewContext)
        let detailModel = makeSUT()
        
        // Save
        coreDataRespository.savePokemon(detailModel)
        
        // Test Get
        let coreDataDetailModel = coreDataRespository.getPokemonDetail(id: detailModel.id)!
        
        XCTAssertEqual(coreDataDetailModel.id, detailModel.id)
        XCTAssertEqual(coreDataDetailModel.name, detailModel.name)
        XCTAssertEqual(coreDataDetailModel.coverImage, detailModel.coverImage)
        XCTAssertEqual(coreDataDetailModel.owned, detailModel.owned)
        XCTAssertEqual(coreDataDetailModel.types.map { $0.name }.sorted(), detailModel.types.map { $0.name }.sorted())
        XCTAssertEqual(coreDataDetailModel.stats.map { $0.name }.sorted(), detailModel.stats.map { $0.name }.sorted())
    }
    
    func testOwnPokemon() {
        let coreDataRespository = CoreDataRespository(context: self.viewContext)
        let detailModel = makeSUT()
        detailModel.owned = false
        
        // Save
        coreDataRespository.savePokemon(detailModel)
        XCTAssertEqual(coreDataRespository.getPokemonDetail(id: detailModel.id)!.owned, false)
        XCTAssertEqual(coreDataRespository.isOwnedPokemon(id: detailModel.id), false)
        
        // mark own
        coreDataRespository.ownPokemon(id: detailModel.id, owned: true)
        XCTAssertEqual(coreDataRespository.getPokemonDetail(id: detailModel.id)!.owned, true)
        XCTAssertEqual(coreDataRespository.isOwnedPokemon(id: detailModel.id), true)
    }
}

private extension CoreDataRespositoryTests {
    func makeSUT() -> PokemonDetailModel {
        return PokemonDetailModel(id: "5566", name: "李奧納多皮卡丘", types: [PokemonDetailModel.PokemonType.init(name: "flying", url: ""), PokemonDetailModel.PokemonType.init(name: "ghost", url: "")], coverImage: "https://zhgchg.li/fake.png", images: [ "https://zhgchg.li/fake.png"], stats: [], owned: false)
    }
}
