//
//  Item.swift
//  Todoey
//
//  Created by Jai Choubisa on 20/03/18.
//  Copyright © 2018 Jai Choubisa. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var createAt : Date?
    
    //reverse relationship
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
