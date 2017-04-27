//
//  TwitchApiTests.swift
//  TwitchTopGames
//
//  Created by Victor tavares on 27/04/17.
//  Copyright © 2017 Victor Tavares. All rights reserved.
//

import XCTest
import SwiftyJSON

@testable import TwitchTopGames

class TwitchApiTests: XCTestCase {
    
    var gamesArray:[TTGGame] = [TTGGame]()
    var api:TwitchApiManager = TwitchApiManager()
    var dataManager:TTGDataManager = TTGDataManager()

    var json:JSON?

    override func setUp() {
        super.setUp()
        
        let masterDataUrl: URL = Bundle.main.url(forResource: "test", withExtension: "json")!
        let jsonData: Data = try! Data(contentsOf: masterDataUrl)
        self.json = JSON(data: jsonData)[TTGTAG.top]
        self.gamesArray = api.loadGameArrayFromJSON(self.json!)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testParserError() {
        XCTAssertNotNil(self.json)
        XCTAssertNotNil(self.gamesArray)
    }
    
    func testTwitchAPIManager(){
        
        self.api.fetchTwitchGames { (games, error) in
            XCTAssertNil(error)
            XCTAssertEqual(games?.count, 50)
        }
    }
    
    func testJsonParser() {
        let game = gamesArray[0]

        XCTAssertEqual(self.gamesArray.count, 2)
        XCTAssertEqual(game.name, "World of Warships")
        XCTAssertEqual(game.viewers, 1748)
        XCTAssertEqual(game.channels, 77)
        XCTAssertEqual(game.box?.small, "https://static-cdn.jtvnw.net/ttv-boxart/World%20of%20Warships-52x72.jpg")
        XCTAssertEqual(game.box?.large, "https://static-cdn.jtvnw.net/ttv-boxart/World%20of%20Warships-272x380.jpg")
    }
    
    
    func testDataManagerSave(){
        let count = self.dataManager.saveData(gamesArray:self.gamesArray)
        let gamesArray = self.dataManager.fetchData()
        let game = self.dataManager.fetchGame(rank: 1)
        XCTAssertEqual(count, 2)
        XCTAssertEqual(gamesArray.count, 50)
        XCTAssertEqual(gamesArray[0].name, self.gamesArray[0].name)
        XCTAssertEqual(game?.name, self.gamesArray[0].name)
    }
    

    
    
    
}
