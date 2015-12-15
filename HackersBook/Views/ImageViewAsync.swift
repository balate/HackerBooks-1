//
//  UIImageViewAsync.swift
//  HackersBook
//
//  Created by Carlos Padrón on 08/12/15.
//  Copyright © 2015 Carlos Dominguez. All rights reserved.
//

import UIKit



class ImageViewAsync: UIImageView {

    
    var loaderInficatorView: UIActivityIndicatorView? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override init(image: UIImage?) {
        super.init(image: image)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func loadImageWithUrl(url: NSURL) {
        self.image = nil
        
        
        
        self.configureLoaderIndicator()
        
        
        let fileManager = NSFileManager.defaultManager()
        if let localPath = self.localPathForRemoteUrl(url) {
            if (fileManager.fileExistsAtPath(localPath)) {
                self.image = UIImage.init(contentsOfFile: localPath)!
                self.loaderInficatorView?.stopAnimating()

            }
            else {
                self.downloadImage(url, localPath: localPath)
            }
        }
        else {
            print("Failed to get image path.\n")
        }
    }
    
    
    func configureLoaderIndicator() {
        self.loaderInficatorView = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        let heightIndicator = self.loaderInficatorView?.frame.size.height
        let widthIndicator = self.loaderInficatorView?.frame.size.width
        let centerY = self.frame.size.height / 2
        let centerX = self.frame.size.width / 2
        let frameLoader = CGRectMake(centerX - (heightIndicator! / 2), centerY - (widthIndicator!/2), widthIndicator!, heightIndicator!)
        loaderInficatorView?.frame = frameLoader;
        self.loaderInficatorView?.hidesWhenStopped = true
        self.addSubview(loaderInficatorView!)
        self.loaderInficatorView?.startAnimating()
    }
    
    
    func localPathForRemoteUrl(url:NSURL) -> String? {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentDirectory = paths[0]
        let imageFileName = url.path?.componentsSeparatedByString("/")
        if let imagePath = imageFileName?.last {
            return documentDirectory.stringByAppendingString("/" + imagePath)
        }
        return nil
    }
    
    
    func downloadImage(url:NSURL, localPath:String) {
        let session = NSURLSession.init(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        let task  = session.dataTaskWithURL(url) { (data, response:NSURLResponse?, error) -> Void in
            self.loaderInficatorView?.stopAnimating()
            
            if (error != nil || data == nil)  {
                print("Failed to download image.\n")
                return
            }
            self.image = UIImage.init(data: data!)!
            
            if let result = data?.writeToFile(localPath, atomically: true) {
                if !result {
                    print("Failed to save file locally.\n")
                }
            }
            
        }
        task.resume()
    }
}
