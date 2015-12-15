//
//  AGTDetailViewController.swift
//  HackersBook
//
//  Created by Carlos Padrón on 04/12/15.
//  Copyright © 2015 Carlos Dominguez. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var book:Book?
    
    
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBAction func markAsFavourite(sender: AnyObject) {
        if let fav = self.book?.isFavourite {
            self.book?.isFavourite = !fav
            self.setBookState(!fav)
        }
    }

    
    @IBOutlet weak var imageBook: ImageViewAsync!
    
    @IBOutlet weak var labelAuthors: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var buttonRead: UIBarButtonItem!

    var delegate: BookProtocol?
    

    func setBookState(isFavourite: Bool) {
        if (isFavourite) {
            likeButton.setBackgroundImage(UIImage.init(named: "Like"), forState: UIControlState.Normal)
            
        }
        else {
            likeButton.setBackgroundImage(UIImage.init(named: "NoLike"), forState: UIControlState.Normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        
        labelTitle.text = book?.title
        labelAuthors.text = book?.authors.joinWithSeparator(",")
        if let url = book?.urlImage {
            imageBook.loadImageWithUrl(url)
        }
        self.setBookState((book?.isFavourite)!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var detailItem: AnyObject? {
        didSet {
            
        }
    }
    

   
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showPDF" {
            let webViewController = segue.destinationViewController as? WebViewController
            webViewController?.book = self.book
        }
    }


   
    

}
