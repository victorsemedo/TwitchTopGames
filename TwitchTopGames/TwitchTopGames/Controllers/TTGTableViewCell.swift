//
//  TTGTableViewCell.swift
//  TwitchTopGames
//
//  Created by Victor tavares on 26/04/17.
//  Copyright © 2017 Victor Tavares. All rights reserved.
//

import UIKit

class TTGTableViewCell: UITableViewCell {
    
    @IBOutlet weak var uilblPosition: UILabel!
    
    @IBOutlet weak var uiimgGameBox: UIImageView!
    
    @IBOutlet weak var uilblGameTitle: UILabel!
    
    @IBOutlet weak var uiIndLoading: UIActivityIndicatorView!
    
    let borderColor = UIColor(red: 100.0/255.0, green: 65.0/255.0, blue: 165.0/255.0, alpha: 1.0)
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        uilblPosition.layer.cornerRadius = self.uilblPosition.frame.size.height / 2
        uilblPosition.layer.borderWidth = 3.0
        uilblPosition.layer.borderColor = self.borderColor.cgColor
    }
    
    
    
}
