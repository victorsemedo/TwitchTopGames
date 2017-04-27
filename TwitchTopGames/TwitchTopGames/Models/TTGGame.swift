//
//  TTGGame.swift
//  TwitchTopGames
//
//  Created by Victor tavares on 26/04/17.
//  Copyright © 2017 Victor Tavares. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit

class TTGGame{
    
    var id: String?
    var name: String?
    var channels: Int?
    var viewers: Int?
    var box: TTGBox?
    
    init(json: JSON) {
        self.id = json[TTGTAG.game][TTGTAG.id].stringValue
        self.name = json[TTGTAG.game][TTGTAG.name].stringValue
        self.channels = json[TTGTAG.channels].intValue
        self.viewers = json[TTGTAG.viewers].intValue
        self.box = TTGBox.init(json: json[TTGTAG.game][TTGTAG.box])
    }
    
}
