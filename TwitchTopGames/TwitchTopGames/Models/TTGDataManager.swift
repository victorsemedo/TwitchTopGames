//
//  TTGDataManager.swift
//  TwitchTopGames
//
//  Created by Victor Tavares on 27/04/17.
//  Copyright © 2017 Victor Tavares. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class TTGDataManager {
    
    // MARK: Save data
    func saveData(gamesArray:[TTGGame]) -> Int{
        var i = 0
        var newGame:Game
        
        for game:TTGGame in gamesArray {
            i += 1
            if let fetchGame = self.fetchGame(rank:i) {
                newGame = fetchGame
            }else{
                newGame = NSEntityDescription.insertNewObject(forEntityName: "Game", into: self.getContext()) as! Game
            }
            
            if let saveGame = self.saveGame(newGame: newGame, game: game, rank: i) {
                newGame = saveGame
            }
        }
        
        return i
    }
    
    
    // MARK: Save Game
    func saveGame(newGame:Game, game:TTGGame, rank:Int) -> Game? {
        
        newGame.setValue(game.name, forKey: TTGTAG.name)
        newGame.setValue(game.channels, forKey: TTGTAG.channels)
        newGame.setValue(game.viewers, forKey: TTGTAG.viewers)
        newGame.setValue(rank, forKey: TTGTAG.rank)
        
        if game.largeBox != nil {
            newGame.setValue(game.largeBox, forKey: TTGTAG.largeBox)
        }
        if game.largeBox != nil {
            newGame.setValue(game.smallBox, forKey: TTGTAG.smallBox)
        }
        
        do {
            try self.getContext().save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
            return nil
        } catch {
            return nil
        }
        
        return newGame
    }
    
    // MARK: Fetching Game with rank
    func fetchGame(rank:Int) -> Game?
    {
        let context = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Game")
        
        fetchRequest.predicate = NSPredicate(format: "rank == %d", rank)
        let result = try? context.fetch(fetchRequest)
        let resultData = result as! [Game]
        if resultData.count > 0 {
            return resultData[0]
        }else {
            return nil
        }
    }
    
    // MARK: Fetching Data
    func fetchData() -> [TTGGame]
    {
        let context = getContext()
        var gamesArray:[TTGGame] = [TTGGame]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Game")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "rank", ascending: true)]
        
        do {
            let games = try context.fetch(fetchRequest) as! [Game]
            for game in games {
                gamesArray.append(TTGGame.init(game:game))
            }
        } catch {
            gamesArray = [TTGGame]()
            print("Failed to fetch employees: \(error)")
        }
        
        return gamesArray
    }
    
    // MARK: Update Data
    func updateGame(game:TTGGame, rank:Int) -> Game? {
        
        if  let newGame = self.fetchGame(rank:rank) {
            newGame.setValue(game.name, forKey: TTGTAG.name)
            newGame.setValue(game.channels, forKey: TTGTAG.channels)
            newGame.setValue(game.viewers, forKey: TTGTAG.viewers)
            newGame.setValue(rank, forKey: TTGTAG.rank)
            if game.largeBox != nil {
                newGame.setValue(game.largeBox, forKey: TTGTAG.largeBox)
            }
            if game.smallBox != nil {
                newGame.setValue(game.smallBox, forKey: TTGTAG.smallBox)
            }
            
            do{
                try self.getContext().save()
                print("saved")
            }catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)")
            }
            
            return newGame
        }else {
            return nil
        }
    }
    
    // MARK: Get Context
    func getContext () -> NSManagedObjectContext {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        return appDel.managedObjectContext
    }
}
