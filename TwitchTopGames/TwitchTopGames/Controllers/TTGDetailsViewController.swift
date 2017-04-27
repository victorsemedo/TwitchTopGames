//
//  TTGDetailsViewController.swift
//  TwitchTopGames
//
//  Created by Victor tavares on 25/04/17.
//  Copyright © 2017 Victor Tavares. All rights reserved.
//

import UIKit
import SVProgressHUD

class TTGDetailsViewController: UIViewController {

    var game:TTGGame?
    
    var rank:Int?
    
    @IBOutlet weak var uiLblViewers: UILabel!
    
    @IBOutlet weak var uiLblChannels: UILabel!
    
    @IBOutlet weak var uiImgGameBox: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let link = self.game?.box?.large {
            SVProgressHUD.show(withStatus: NSLocalizedString("STR_LOADING", comment:""))
            self.uiImgGameBox.downloadedFrom(link: link, completion: {result in
               
                if result != nil {
                    self.game?.largeBox = NSData.init(data: result!)
                    _ = TTGDataManager().updateGame(game:self.game!, rank:self.rank!)
                }
                SVProgressHUD.dismiss()
            })
        }else if let imageData = self.game?.largeBox{
             self.uiImgGameBox.image = UIImage(data:imageData as Data)
        }else if let imageData = self.game?.smallBox {
             self.uiImgGameBox.image = UIImage(data:imageData as Data)
        }
        
        if let viewers = self.game?.viewers {
            self.uiLblViewers.text = NSLocalizedString("STR_VIEWERS", comment:"") + "\(viewers)"
        }else {
            self.uiLblViewers.text = ""
        }
        
        if let channels = self.game?.viewers {
            self.uiLblChannels.text = NSLocalizedString("STR_CHANNELS", comment:"") + "\(channels)"
        }else {
            self.uiLblChannels.text = ""
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
