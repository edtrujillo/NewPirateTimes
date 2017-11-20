//
//  WebViewController.swift
//  PirateTimes
//
//  Created by Edmund Trujillo on 11/18/17.
//  Copyright © 2017 Edmund Trujillo. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    var webUrl: String?
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        
        if let webUrl = self.webUrl {
            self.view?.makeToastActivity(.center)

            let url = URL(string:webUrl)
            let request = URLRequest(url: url!)
            self.webView!.load(request)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.view?.hideToastActivity()
    }
}
