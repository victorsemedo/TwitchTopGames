//
//  TwitchApiManager.swift
//  TwitchTopGames
//
//  Created by Victor tavares on 25/04/17.
//  Copyright © 2017 Victor Tavares. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class TwitchApiManager: NSObject {

    let TWITCH_API_URL = "https://api.twitch.tv/kraken/games/top?limit=50&client_id=pn4ywuv1h97kslj0a1zygtbsduek4b"
    
    private func loadGameArrayFromJSON(_ json: JSON) -> [TTGGame] {
        var gamesArray = [TTGGame]()
        var game:TTGGame
        
        if let games = json.array {
            for jsonGame in games {
                game = TTGGame.init(json: jsonGame)
                gamesArray.append(game)
            }
        }
        
        return gamesArray
    }
    
    
    func fetchTwitchGames(completionHandler: @escaping ([TTGGame]?, String?) -> Void) {
        Alamofire.request(TWITCH_API_URL).responseJSON { response in
            
            guard response.result.isSuccess else {
                completionHandler([TTGGame](), "Error while fetching remote rooms: \(String(describing: response.result.error))")
                return
            }
            
            if let result = response.result.value {
                let jsonObj = JSON(result)
                
                if jsonObj[TTGTAG.top].exists() {
                    let json = jsonObj[TTGTAG.top]
                    let gamesArray = self.loadGameArrayFromJSON(json)
                    completionHandler(gamesArray, nil)
                    return
                }else {
                    completionHandler([TTGGame](), "Malformed data received from Twitch service")
                    return
                }
            }else {
                completionHandler([TTGGame](), "Malformed data received from Twitch service")
                return
            }
        }
    }
    
}
