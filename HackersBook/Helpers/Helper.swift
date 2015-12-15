//
//  AGTHelper.swift
//  HackersBook
//
//  Created by Carlos Padrón on 02/12/15.
//  Copyright © 2015 Carlos Dominguez. All rights reserved.
//

import UIKit

class Helper: NSObject {
    
    static var sharedHelper = Helper()
    
    
    // TODO: Refactor this to use getPath
    func saveImage(fileName: String, data: NSData) ->  Bool {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentDirectory = paths[0]
        let path = documentDirectory.stringByAppendingString("/" + fileName)
        return data.writeToFile(path, atomically: true)
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
