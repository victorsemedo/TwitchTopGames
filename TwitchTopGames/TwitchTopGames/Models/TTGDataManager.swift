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
    func saveData(gamesArray:[TTGGame]) {
        var i = 0
        let context = getContext()
        var newGame:Game
        
        for game:TTGGame in gamesArray {
            i += 1
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Game")
            fetchRequest.predicate = NSPredicate(format: "rank == %d", i)
            let result = try? context.fetch(fetchRequest)
            
            let resultData = result as! [Game]
            
            if resultData.count > 0 {
                newGame = resultData[0]
            }else {
                newGame = NSEntityDescription.insertNewObject(forEntityName: "Game", into: context) as! Game
            }
            
            newGame.setValue(game.name, forKey: TTGTAG.name)
            newGame.setValue(game.channels, forKey: TTGTAG.channels)
            newGame.setValue(game.viewers, forKey: TTGTAG.viewers)
            newGame.setValue(i, forKey: TTGTAG.rank)
            
            if game.largeBox != nil {
                newGame.setValue(game.largeBox, forKey: TTGTAG.largeBox)
            }
            if game.largeBox != nil {
                newGame.setValue(game.smallBox, forKey: TTGTAG.smallBox)
            }
        }
        
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
    }
    
    // MARK: Fetching Data
    func fetchData() -> [TTGGame] {
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
            fatalError("Failed to fetch employees: \(error)")
        }
        
        return gamesArray
    }
    
    // MARK: Update Data
    func updateGame(game:TTGGame, rank:Int) -> Void {
        let context = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Game")
        
        fetchRequest.predicate = NSPredicate(format: "rank == %d", rank)
        let result = try? context.fetch(fetchRequest)
        
        let resultData = result as! [Game]
        
        if resultData.count > 0 {
            let newGame = resultData[0]
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
        }
        
        do{
            try context.save()
            print("saved")
        }catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    // MARK: Get Context
    func getContext () -> NSManagedObjectContext {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        return appDel.managedObjectContext
    }
}
