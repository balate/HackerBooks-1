//
//  AGTHelper.swift
//  HackersBook
//
//  Created by Carlos Padrón on 02/12/15.
//  Copyright © 2015 Carlos Dominguez. All rights reserved.
//

import UIKit

class AGTHelper: NSObject {
    
    static var sharedHelper = AGTHelper()
    
    
        
    func saveImage(fileName: String, data: NSData) ->  String {
        
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentDirectory = paths[0]
        let path = documentDirectory.stringByAppendingString("/" + fileName)
        let success = data.writeToFile(path, atomically: false)
        return path;
    }
    
    


}