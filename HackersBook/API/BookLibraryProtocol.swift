//
//  AGTLibraryProtocol.swift
//  HackersBook
//
//  Created by Carlos Padrón on 02/12/15.
//  Copyright © 2015 Carlos Dominguez. All rights reserved.
//

import UIKit

protocol BookLibraryProtocol {
    func didLibraryFinishedLoad(books: [Book])
}

protocol BookProtocol {
    func didBookChangedStatus(book: Book)
}