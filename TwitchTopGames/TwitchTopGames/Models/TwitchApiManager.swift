//
//  TwitchApiManager.swift
//  TwitchTopGames
//
//  Created by Victor tavares on 25/04/17.
//  Copyright © 2017 Victor Tavares. All rights reserved.
//

import Foundation
import Alamofire

class TwitchApiManager: NSObject {

    let TWITCH_API_URL = "https://api.twitch.tv/kraken/games/top?limit=10&client_id=pn4ywuv1h97kslj0a1zygtbsduek4b"
    
    static let sharedInstance = TwitchApiManager()
    
}
