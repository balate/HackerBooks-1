//
//  AGTLibrary.swift
//  HackersBook
//
//  Created by Carlos Padrón on 02/12/15.
//  Copyright © 2015 Carlos Dominguez. All rights reserved.
//

import UIKit



class BookLibrary {
    var books: [Book]
    var tags: Set<String>
    var delegate: BookLibraryProtocol?
    var favouritesBooks: [Book]
    
    
    static let URL_SERVICE      = "https://t.co/K9ziV0z3SJ";
    static let LOCAL_DATA_KEY   = "booksData";

    static var sharedLibrary = BookLibrary()
    
    
    
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
                
                let book = Book(title: element["title"] as! String,
                    authors: authors,
                    tags:tags,
                    urlImage: NSURL(string: element["image_url"] as! String)!,
                    urlPDF:  NSURL(string: element["pdf_url"] as! String)!)
                
                for tag in tags {
                    self.tags.insert(tag)
                }
                self.books.append(book)
                
            }
        } catch let error as NSError {
            NSLog("%@", error)
        }
    }
    

    
    init() {
        self.books = [Book]()
        self.favouritesBooks = [Book]()
        self.tags = Set<String>()
    }
    
    

    
    func loadData() -> Void {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let data = userDefaults.dataForKey(BookLibrary.LOCAL_DATA_KEY) {
            self.getJSON(data)
           // self.tags.sort()
            self.books.sortInPlace({ (a, b) -> Bool in
                return a.title.compare(b.title) == NSComparisonResult.OrderedAscending
            })
            self.delegate?.didLibraryFinishedLoad(self.books)
        }
        else {
            let priority = DISPATCH_QUEUE_PRIORITY_BACKGROUND
            dispatch_async(dispatch_get_global_queue(priority, 0), {
                
                if let url =  NSURL(string: BookLibrary.URL_SERVICE) {
                    
                    let data : NSData = NSData(contentsOfURL: url)!
                    
                    self.getJSON(data)
                    self.books.sortInPlace({ (a, b) -> Bool in
                        return a.title.compare(b.title) == NSComparisonResult.OrderedAscending
                    })
                
                    // Save data
                    dispatch_async(dispatch_get_main_queue(), {
                        userDefaults.setValue(data, forKey: BookLibrary.LOCAL_DATA_KEY)
                        userDefaults.synchronize()
                        self.delegate?.didLibraryFinishedLoad(self.books)
                    });

                }
            });
        }
    
    }
    
    
    
    func booksForTag (tag:String) -> [Book]? {
        var booksFoundForTag : [Book] = [Book]()
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
