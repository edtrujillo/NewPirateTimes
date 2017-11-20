//
//  MainTableViewController.swift
//  PirateTimes
//
//  Created by Edmund Trujillo on 11/18/17.
//  Copyright © 2017 Edmund Trujillo. All rights reserved.
//

import UIKit
import Kingfisher

fileprivate struct Constants {
    static let SegueIdentifier = "DetailSegue"
    static let PirateTableCellIdentifier = "PirateTableCell"
    static let DefaultThumbNailFileName = "pirate75"
    static let NYTimesURLPrefix = "http://nytimes.com/"
}

class MainTableViewController: UITableViewController {
    
    var articles = [Article]()
    var languageChoice: LanguageConversion = .PirateLanguage
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.PirateTableCellIdentifier,
                                                 for: indexPath) as! MainTableViewCell

        let article = articles[indexPath.row]
        
        if languageChoice == .PirateLanguage {
            cell.snippetLabel.text = article.pirateText
        } else if languageChoice == .EnglishLanguage {
            cell.snippetLabel.text = article.englishText
        } else {
            cell.snippetLabel.text = convertEnglishToPigLatin(sentence: article.englishText)
        }
        
        cell.thumbNail.image = UIImage (named: Constants.DefaultThumbNailFileName)
        
        if let thumbURL = article.thumbUrl {
            let thumbNail = Constants.NYTimesURLPrefix + thumbURL
            cell.thumbNail.kf.setImage(with: URL(string:thumbNail))
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.SegueIdentifier, sender: self)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueIdentifier {
            guard let indexPath = self.tableView.indexPathForSelectedRow else { return }
            let webviewVC = segue.destination as? WebViewController
            webviewVC?.webUrl = articles[indexPath.row].webUrl
        }
    }

}
