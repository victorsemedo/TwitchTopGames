//
//  TTGBox.swift
//  TwitchTopGames
//
//  Created by Victor tavares on 26/04/17.
//  Copyright © 2017 Victor Tavares. All rights reserved.
//

import Foundation
import SwiftyJSON

class TTGBox {
    
    var large: String?
    var medium: String?
    var small: String?
    
    init(json: JSON) {
        self.large = json[TTGTAG.large].stringValue
        self.medium = json[TTGTAG.medium].stringValue
        self.small = json[TTGTAG.small].stringValue
    }
}
