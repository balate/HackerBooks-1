//
//  AGTLibrary.swift
//  HackersBook
//
//  Created by Carlos Padrón on 02/12/15.
//  Copyright © 2015 Carlos Dominguez. All rights reserved.
//

import UIKit



class AGTLibrary {
    var books: [AGTBook]
    var tags: [String]
    var delegate: AGTLibraryProtocol?
    
    
    static let URL_SERVICE      = "https://t.co/K9ziV0z3SJ";
    static let LOCAL_DATA_KEY   = "booksData";

    var booksCount:Int {
        get {
            let count: Int = self.books.count
            return count
        }
    }
    
    func getJSON(data: NSData) {
        do {
            let serializer = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSArray
            
            
            for element in serializer  {
                
                let authors = (element["authors"] as! String).componentsSeparatedByString(",")
                let tags = (element["tags"] as! String).componentsSeparatedByString(",")
                
                let book = AGTBook(title: element["title"] as! String,
                    authors: authors,
                    tags:tags,
                    urlImage: NSURL(string: element["image_url"] as! String)!,
                    urlPDF:  NSURL(string: element["pdf_url"] as! String)!)
            
                self.tags.appendContentsOf(tags)
                self.books.append(book)
                
            }
            self.tags = self.removeDuplicateTags()
        } catch let error as NSError {
            NSLog("%@", error)
        }
    }
    
    
    init() {
        self.books = [AGTBook]()
        self.tags = [String]()
    }
    
    
    func removeDuplicateTags() -> [String] {
        var newTags = [String]()
        
        for tag in self.tags {
            let cleanTag = tag.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            if !newTags.contains(cleanTag) {
                newTags.append(cleanTag)
            }
        }
        return newTags
    }
    
    
    func loadData() -> Void {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let data = userDefaults.dataForKey(AGTLibrary.LOCAL_DATA_KEY) {
            self.getJSON(data)
            self.tags.sortInPlace()
            self.books.sortInPlace({ (a, b) -> Bool in
                return a.title.compare(b.title) == NSComparisonResult.OrderedAscending
            })
            self.delegate?.didLibraryFinishedLoad(self.books)
        }
        else {
            let priority = DISPATCH_QUEUE_PRIORITY_BACKGROUND
            dispatch_async(dispatch_get_global_queue(priority, 0), {
                
                if let url =  NSURL(string: AGTLibrary.URL_SERVICE) {
                    
                    let data : NSData = NSData(contentsOfURL: url)!
                    
                    self.getJSON(data)
                    self.books.sortInPlace({ (a, b) -> Bool in
                        return a.title.compare(b.title) == NSComparisonResult.OrderedAscending
                    })
                    self.tags.sortInPlace()
                    


                    
                    // Save all images locally
                    for book in self.books {
                        
                        let imageData : NSData = NSData(contentsOfURL: book.urlImage)!
                        let imageFileName = book.urlImage.path?.componentsSeparatedByString("/")
                        if let imagePath = imageFileName?.last {
                            AGTHelper.sharedHelper.saveImage(imagePath, data: imageData)
                        }
                    }
                    // Save data
                    dispatch_async(dispatch_get_main_queue(), {
                        userDefaults.setValue(data, forKey: AGTLibrary.LOCAL_DATA_KEY)
                        userDefaults.synchronize()
                        self.delegate?.didLibraryFinishedLoad(self.books)
                    });

                }
            });
        }
    
    }
    
    
    func bookCountForTag (tag:String) -> Int {
        if let index = tags.indexOf(tag) {
            return index
        }
        return 0
    }
    
    
    func booksForTag (tag:String) -> [AGTBook]? {
        var booksFoundForTag : [AGTBook] = [AGTBook]()
        for book in self.books {
            if (book.tags.contains(tag)  || book.tags.contains(" " + tag)) {
                booksFoundForTag.append(book)
            }
        }
        if booksFoundForTag.count > 0 {
            return booksFoundForTag
        }
        return nil
    }
    
    
    

    
}
