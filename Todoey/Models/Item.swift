//
//  Item.swift
//  Todoey
//
//  Created by TJ Smith on 2/8/18.
//  Copyright © 2018 TJ Smith Company. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
