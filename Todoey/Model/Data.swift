//
//  Data.swift
//  Todoey
//
//  Created by Jai Choubisa on 18/03/18.
//  Copyright © 2018 Jai Choubisa. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var age : Int = 0
}
