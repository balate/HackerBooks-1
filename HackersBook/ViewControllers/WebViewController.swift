//
//  WebViewController.swift
//  HackersBook
//
//  Created by Carlos Padrón on 15/12/15.
//  Copyright © 2015 Carlos Dominguez. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var webView: UIWebView!
    var book: Book!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.title = book?.title
        
        let urlRequest = NSURLRequest(URL: (book?.urlPDF)!)
        self.webView.loadRequest(urlRequest)
        
        
        
        self.webView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func webViewDidFinishLoad(webView: UIWebView) {
        self.activityIndicatorView.stopAnimating()
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        self.activityIndicatorView.startAnimating()

    }
}
