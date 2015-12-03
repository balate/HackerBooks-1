//
//  AGTBook.swift
//  HackersBook
//
//  Created by Carlos Padrón on 02/12/15.
//  Copyright © 2015 Carlos Dominguez. All rights reserved.
//

import UIKit

class AGTBook: NSObject {
    let title       : String
    let authors     : [String]
    let tags        : [String]
    var urlImage    : NSURL
    let urlPDF      : NSURL
    
    
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
