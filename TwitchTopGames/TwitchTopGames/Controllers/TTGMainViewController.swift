//
//  TTGMainViewController.swift
//  TwitchTopGames
//
//  Created by Victor tavares on 25/04/17.
//  Copyright © 2017 Victor Tavares. All rights reserved.
//

import UIKit
import SVProgressHUD

class TTGMainViewController: UITableViewController {

    var gamesArray:[TTGGame] = [TTGGame]()
    
    var selectedGame:TTGGame?
    
    let twitchAPI:TwitchApiManager = TwitchApiManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadTwitchGames();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func loadTwitchGames()
    {
        SVProgressHUD.show(withStatus: "Loading")
        self.twitchAPI.fetchTwitchGames { (result, error) in
            if error != nil {
            }
            self.gamesArray = result!
            self.tableView.reloadData()
            SVProgressHUD.dismiss()
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
        
        if let link = game.box?.small {
            gameCell.uiimgGameBox.isHidden = true
            gameCell.uiIndLoading.isHidden = false
            gameCell.uiIndLoading.startAnimating()
            gameCell.uiimgGameBox?.downloadedFrom(link:link, completion: { result in
                gameCell.uiimgGameBox.isHidden = false
                gameCell.uiIndLoading.isHidden = true
                gameCell.uiIndLoading.stopAnimating()
            })
        }

        gameCell.uilblPosition?.text = "\(indexPath.row + 1)"

        return gameCell
    }
    
    // MARK: -  UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:true)
        self.selectedGame = self.gamesArray[indexPath.row]
        self.performSegue(withIdentifier: "showDetailsSegueID", sender: self)
    }
    

    // MARK: -  UIStoryboardSegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if(segue.identifier == "showDetailsSegueID") {
            let vcDetails = (segue.destination as! TTGDetailsViewController)
            vcDetails.game = self.selectedGame
        }
    }
}

// MARK: -  Extensions

extension UIImageView {
   
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit, completion: @escaping (Bool) -> Void) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {
                    completion(false)
                    return
            }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
                completion(true)
            }
            }.resume()
    }
    
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode, completion:completion)
    }
}
