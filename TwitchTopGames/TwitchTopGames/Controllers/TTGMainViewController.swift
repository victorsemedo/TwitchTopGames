//
//  TTGMainViewController.swift
//  TwitchTopGames
//
//  Created by Victor tavares on 25/04/17.
//  Copyright © 2017 Victor Tavares. All rights reserved.
//

import UIKit
import SVProgressHUD
import CoreData

class TTGMainViewController: UITableViewController {

    var gamesArray:[TTGGame] = [TTGGame]()
    
    var selectedRow:Int?
    
    let twitchAPI:TwitchApiManager = TwitchApiManager()
    
    let dataManager:TTGDataManager = TTGDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action: #selector(TTGMainViewController.handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
        self.loadTwitchGames(refreshControl: nil);
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func loadTwitchGames(refreshControl:UIRefreshControl?)
    {
        if refreshControl == nil {
            SVProgressHUD.show(withStatus: NSLocalizedString("STR_LOADING", comment:""))
        }
        self.twitchAPI.fetchTwitchGames {(result, error) in
            if error != nil {
                self.showAlertWithError(message:error!)
                self.gamesArray = self.dataManager.fetchData()
            }else {
                self.gamesArray = result!
                _ = self.dataManager.saveData(gamesArray:self.gamesArray)
            }
            self.tableView.reloadData()
            
            if refreshControl != nil {
                refreshControl?.endRefreshing()
            }else {
                SVProgressHUD.dismiss()
            }

        }
    }
    
    // MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gamesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let gameCell = tableView.dequeueReusableCell(withIdentifier: "TTGTableViewCell", for: indexPath) as! TTGTableViewCell
        let game = self.gamesArray[indexPath.row]

        gameCell.uilblGameTitle?.text = game.name
        
        if game.useImgData {
            if let imageData = game.smallBox {
                gameCell.uiimgGameBox.image = UIImage(data:imageData as Data)
            }else {
                
            }
            gameCell.uiimgGameBox.isHidden = false
            gameCell.uiIndLoading.isHidden = true
            gameCell.uiIndLoading.stopAnimating()
        }else {
            if let link = game.box?.small{
                gameCell.uiimgGameBox.isHidden = true
                gameCell.uiIndLoading.isHidden = false
                gameCell.uiIndLoading.startAnimating()
                gameCell.uiimgGameBox?.downloadedFrom(link:link, completion: { result in
                    gameCell.uiimgGameBox.isHidden = false
                    gameCell.uiIndLoading.isHidden = true
                    gameCell.uiIndLoading.stopAnimating()
                    
                    if(result != nil) {
                        game.smallBox = NSData.init(data:result!)
                        _ = self.dataManager.updateGame(game:game, rank: indexPath.row+1)
                    }else {
                        
                    }
                })
            }
        }
        
        gameCell.uilblPosition?.text = "\(indexPath.row + 1)"

        return gameCell
    }
    
    // MARK - UIRefreshControl
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        self.loadTwitchGames(refreshControl:refreshControl)
    }
    
    // MARK: -  UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:true)
        self.selectedRow = indexPath.row
        self.performSegue(withIdentifier: "showDetailsSegueID", sender: self)
    }
    

    // MARK: -  UIStoryboardSegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if(segue.identifier == "showDetailsSegueID") {
            let vcDetails = (segue.destination as! TTGDetailsViewController)
            vcDetails.game = self.gamesArray[self.selectedRow!]
            vcDetails.rank = self.selectedRow! + 1
        }
    }
    
    // MARK - UIAlertController
    
    func showAlertWithError(message:String) {
        let alert = UIAlertController(title: NSLocalizedString("STR_ERROR", comment: ""), message:message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("STR_OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

// MARK: -  Extensions

extension UIImageView {
   
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit, completion: @escaping (Data?) -> Void) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {
                    completion(nil)
                    return
            }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
                completion(data)
            }
            }.resume()
    }
    
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit, completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode, completion:completion)
    }
    
}
