//
//  cacheHandler.swift
//  Countries
//
//  Created by admin on 21/05/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class cacheHandler {
    static let shared = cacheHandler()
    
    let cache = NSCache<NSString, UIImage>()
    
    func imageForKey(_ key: String) -> UIImage?
    {
        return cache.object(forKey: key as NSString)
    }
    
    func setImage(image: UIImage, forKey key: String)
    {
        cache.setObject(image, forKey: key as NSString)
    }
}
