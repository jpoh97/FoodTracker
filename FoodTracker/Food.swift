//
//  Food.swift
//  FoodTracker
//
//  Created by Internship on 2/27/18.
//  Copyright © 2018 Internship. All rights reserved.
//

import UIKit

class Food : NSObject, NSCoding {

    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("foods")
    
    let name : String
    let image : UIImage?
    let rating : Int
    
    struct FoodPropertyKey {
        static let name = "name"
        static let image = "image"
        static let rating = "rating"
    }
    
    init?(name : String, image : UIImage?, rating : Int) {
        print("Docs dir: \(Food.DocumentsDirectory) archivesURL: \(Food.ArchiveURL)")
        if rating < 0 || rating > 5 {
            return nil
        }
        if name.isEmpty {
            return nil
        }
        
        self.name = name
        self.image = image
        self.rating = rating
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey : FoodPropertyKey.name) as? String else {
            fatalError("The match has been corrupted")
        }
        let image = aDecoder.decodeObject(forKey : FoodPropertyKey.image) as? UIImage
        let rating = aDecoder.decodeInteger(forKey : FoodPropertyKey.rating)
        
        self.init(name : name, image : image, rating : rating)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: FoodPropertyKey.name)
        aCoder.encode(image, forKey: FoodPropertyKey.image)
        aCoder.encode(rating, forKey: FoodPropertyKey.rating)
    }
    
}
