//
//  MainViewController.swift
//  PirateTimes
//
//  Created by Edmund Trujillo on 11/18/17.
//  Copyright © 2017 Edmund Trujillo. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UISearchBarDelegate {
    
    @IBAction func languageChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            childTableVC?.languageChoice = .PirateLanguage
        } else if sender.selectedSegmentIndex == 1 {
            childTableVC?.languageChoice = .EnglishLanguage
        } else {
            childTableVC?.languageChoice = .PigLatinLanguage
        }
        childTableVC?.tableView.reloadData()
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // keep a weak reference to our contained child table VC for
    // refreshing on new query terms
    
    weak var childTableVC: MainTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        childTableVC = (segue.destination as? MainTableViewController)
    }
}

extension MainViewController {
    
    // on the search button tap, 1) dismiss the keyboard,
    // 2) put up a spinner, 3) fetch the NY Times for articles
    // matching the search term and fetch the pirate translation then
    // 4) reload the table and close the spinner
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        self.view?.makeToastActivity(.center)
        
        if let searchText = searchBar.text {
            
            fetchArticles(searchText, { (articles) in
                if let articles = articles {
                    self.childTableVC?.articles = articles
                    self.childTableVC?.tableView.reloadData()
                } else {
                    let myAlert: UIAlertController = UIAlertController(title:"Sorry",
                                                                       message:"Unable to get a response. Try again.",
                                                                       preferredStyle: .alert)
                    myAlert.addAction(UIAlertAction(title:"OK", style: .default, handler: nil))
                    self.present(myAlert, animated: true, completion: nil)
                }
                self.view?.hideToastActivity()
            })
        }
    }
}
