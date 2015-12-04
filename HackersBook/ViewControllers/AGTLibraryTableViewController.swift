//
//  AGTLibraryTableViewController.swift
//  HackersBook
//
//  Created by Carlos Padrón on 02/12/15.
//  Copyright © 2015 Carlos Dominguez. All rights reserved.
//

import UIKit

class AGTLibraryTableViewController: UITableViewController, AGTLibraryProtocol {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    let library = AGTLibrary()

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.library.delegate = self
        self.activityIndicator.stopAnimating()
        self.library.loadData()
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.library.tags.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let tag = self.library.tags[section]
        if let booksForTag = self.library.booksForTag(tag) {
           return booksForTag.count
        }
        return 0
    }
    
    
    
    func didLibraryFinishedLoad(books: [AGTBook]) {
        self.tableView.reloadData()
        self.activityIndicator.stopAnimating()
        self.activityIndicator.hidden = true
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.library.tags[section]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let tag = self.library.tags[indexPath.section]
        let booksForTag = self.library.booksForTag(tag)
        let book = booksForTag?[indexPath.row];
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("bookCell", forIndexPath: indexPath) as! AGTBookTableViewCell
        
    
        cell.labelTitle.text = book?.title
        cell.labelAuthors.text = book?.authors.joinWithSeparator(",")
        if let imagePath = getPath((book?.urlImage)!) {
            cell.imageBook.image = UIImage(contentsOfFile: imagePath)
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frameLabel = CGRectMake(10, 0, tableView.frame.size.width, 50.0)
        let vw = UIView()
        let labelTitle = UILabel(frame: frameLabel)
        labelTitle.textColor = UIColor.whiteColor()
        labelTitle.text = self.library.tags[section].uppercaseString
        vw.backgroundColor = UIColor(colorLiteralRed: 52.0/255.0, green: 73.0/255.0, blue: 94.0/255.0, alpha: 1)
        vw.addSubview(labelTitle)
        return vw
    }
    
    func getPath(urlImage: NSURL) -> String?{
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentDirectory = paths[0]
        let imageFileName = urlImage.path?.componentsSeparatedByString("/")
        if let imagePath = imageFileName?.last {
            // Remove the file extension
            return documentDirectory.stringByAppendingString("/" + imagePath)
        }
        return nil
    }
    


}
