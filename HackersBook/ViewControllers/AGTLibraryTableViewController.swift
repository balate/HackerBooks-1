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
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.library.books.count
    }
    
    
    
    func didLibraryFinishedLoad(books: [AGTBook]) {
        self.tableView.reloadData()
        self.activityIndicator.stopAnimating()
        self.activityIndicator.hidden = true
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("bookCell", forIndexPath: indexPath) as! AGTBookTableViewCell
        let book = self.library.books[indexPath.row];
        
    
        cell.labelTitle.text = book.title
        cell.labelAuthors.text = book.authors.joinWithSeparator(",")
        
        if let imageKey = getKey(book.urlImage) {
            
            if let path = self.library.imagesDictionary[imageKey] {
                cell.imageBook.image = UIImage(contentsOfFile: path)
            }
            
        }

        
        return cell
    }
    
    
    func getKey(urlImage: NSURL) -> String?{
        let imageFileName = urlImage.path?.componentsSeparatedByString("/")
        if let imagePath = imageFileName?.last {
            // Remove the file extension
            return imagePath.componentsSeparatedByString(".").first
        }
        return nil
    }
    
    


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
