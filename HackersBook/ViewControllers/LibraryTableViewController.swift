//
//  AGTLibraryTableViewController.swift
//  HackersBook
//
//  Created by Carlos Padrón on 02/12/15.
//  Copyright © 2015 Carlos Dominguez. All rights reserved.
//

import UIKit

extension UISplitViewController {
    func toggleMasterView() {
        let barButtonItem = self.displayModeButtonItem()
        UIApplication.sharedApplication().sendAction(barButtonItem.action, to: barButtonItem.target, from: nil, forEvent: nil)
    }
}

class LibraryTableViewController: UITableViewController, BookLibraryProtocol {
    
    let library = BookLibrary.sharedLibrary
    
    
    // MARK: - View Controllers

    override func viewDidLoad() {
        super.viewDidLoad()
        self.library.delegate = self
        self.library.loadData()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if (self.library.favouritesBooks.count > 0) {
            return self.library.tags.count + 1
        }
        return self.library.tags.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (self.library.favouritesBooks.count > 0) {
            if (section == 0) {
                return self.library.favouritesBooks.count
            }
            else {
                let tag = self.library.tags[self.library.tags.startIndex.advancedBy(section-1)]
                if let booksForTag = self.library.booksForTag(tag) {
                    return booksForTag.count
                }
            }
        }
        else {
        
            let tag = self.library.tags[self.library.tags.startIndex.advancedBy(section)]
            if let booksForTag = self.library.booksForTag(tag) {
                return booksForTag.count
            }
        }
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let book = getBookAtIndexPath(indexPath)
        
        let cell:BookTableViewCell? = tableView.dequeueReusableCellWithIdentifier("bookCell", forIndexPath: indexPath) as? BookTableViewCell
        
        
        cell?.labelTitle.text = book.title
        cell?.labelAuthors.text = book.authors.joinWithSeparator(",")
        cell?.imageBook.loadImageWithUrl(book.urlImage)
        
        return cell!
    }
    
   
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frameLabel = CGRectMake(10, 0, tableView.frame.size.width, 50.0)
        let vw = UIView()
        let labelTitle = UILabel(frame: frameLabel)
        labelTitle.textColor = UIColor.whiteColor()
        
        if (self.library.favouritesBooks.count > 0) {
            if (section == 0) {
                labelTitle.text = "FAVOURITES"
            }
            else {
                labelTitle.text =  self.library.tags[self.library.tags.startIndex.advancedBy(section-1)].uppercaseString
            }
        }
        else {
            labelTitle.text = self.library.tags[self.library.tags.startIndex.advancedBy(section)].uppercaseString
        }
        
        //labelTitle.text = self.library.tags[self.library.tags.startIndex.advancedBy(section)].uppercaseString
        vw.backgroundColor = UIColor(colorLiteralRed: 52.0/255.0, green: 73.0/255.0, blue: 94.0/255.0, alpha: 1)
        vw.addSubview(labelTitle)
        return vw
    }
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // We need to deselect the row
        
         NSNotificationCenter.defaultCenter().addObserver(self, selector: "bookChanged:", name: Book.BOOK_FAVOURITE_NOTIFICATION, object: nil)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.splitViewController?.toggleMasterView()
    }
    
    @objc func bookChanged(notification:NSNotification) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Book.BOOK_FAVOURITE_NOTIFICATION, object: nil)
        let currentBook = (notification.object as! Book)
        if currentBook.isFavourite {
            self.library.favouritesBooks.append(notification.object as! Book)
        }
        else {
            var count = -1
            for book in self.library.favouritesBooks {
                if (book.title == currentBook.title) {
                    count++
                    break
                }
            }
            if (count >= 0) {
                self.library.favouritesBooks.removeAtIndex(count)
            }
        }
        tableView.reloadData()
    }
    
    // MARK: - AGTLibraryProtocol
    
    func didLibraryFinishedLoad(books: [Book]) {
        self.tableView.reloadData()
        
        var detailViewController: DetailViewController!
        
        if let detailNavigationController = self.splitViewController?.viewControllers.last as? UINavigationController {
            detailViewController = detailNavigationController.topViewController as? DetailViewController
            
            let indexPath = NSIndexPath(forRow: 0, inSection: 1)
            detailViewController.book = getBookAtIndexPath(indexPath)
        }
    }
    
    
    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showDetail" {
            
            var detailViewController: DetailViewController!
            

            if let detailNavigationController = segue.destinationViewController as? UINavigationController {
                detailViewController = detailNavigationController.topViewController as? DetailViewController
            }
            else {
                detailViewController = segue.destinationViewController as? DetailViewController
            }
            
            if let selectedRowIndexPath = tableView.indexPathForSelectedRow {
                let book  = getBookAtIndexPath(selectedRowIndexPath)
                detailViewController.book = book
            }
            
        }
        
        
    }
    

    // MARK: Helpers
    
    func getBookAtIndexPath(indexPath: NSIndexPath) -> Book {
        if (self.library.favouritesBooks.count > 0) {
            if (indexPath.section == 0) {
                let book = self.library.favouritesBooks[indexPath.row]
                return book

            }
            else {
                let tag = self.library.tags[self.library.tags.startIndex.advancedBy(indexPath.section-1)]
                let booksForTag = self.library.booksForTag(tag)
                let book = booksForTag?[indexPath.row]
                return book!
            }
        }
        else {
            let tag = self.library.tags[self.library.tags.startIndex.advancedBy(indexPath.section)]
            let booksForTag = self.library.booksForTag(tag)
            let book = booksForTag?[indexPath.row]
            return book!

        
        
        }
    }
    
    
    
    
    


}
