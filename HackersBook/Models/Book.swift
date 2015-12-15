//
//  AGTBook.swift
//  HackersBook
//
//  Created by Carlos Padrón on 02/12/15.
//  Copyright © 2015 Carlos Dominguez. All rights reserved.
//

import UIKit

class Book: NSObject {
    
    static let BOOK_FAVOURITE_NOTIFICATION:String = "isFavouriteChanged"
    static let FAVOURITE_TAG:String = "FAVOURITE"
    
    
    let title       : String
    let authors     : [String]
    var tags        : [String]
    var urlImage    : NSURL
    let urlPDF      : NSURL
    
    private var _isFavourite: Bool = false
    var isFavourite : Bool {
        get {
            return self._isFavourite
        }
        set(newValue) {
            self._isFavourite = newValue
            NSNotificationCenter.defaultCenter().postNotificationName(Book.BOOK_FAVOURITE_NOTIFICATION, object: self)
        }
    }
    
    init(title: String,
        authors: [String],
        tags: [String],
        urlImage: NSURL,
        urlPDF: NSURL) {
            
            self.title = title
            self.authors = authors
            self.tags = tags
            self.urlImage = urlImage
            self.urlPDF = urlPDF
    }
    
    
    
    
    
    
    
    
    
}
