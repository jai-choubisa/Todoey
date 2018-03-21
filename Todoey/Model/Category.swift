//
//  Category.swift
//  Todoey
//
//  Created by Jai Choubisa on 20/03/18.
//  Copyright © 2018 Jai Choubisa. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    
    //forward relationship
    let items = List<Item>()
}
