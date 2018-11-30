//
//  Item.swift
//  ToDoey
//
//  Created by Taylor Batch on 9/13/18.
//  Copyright © 2018 burgeoning. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
   
   @objc dynamic var title: String = ""
  @objc dynamic var done: Bool = false
   @objc dynamic var dateCreated: Date?
  
  let rightTruth = List<TruthsRight>()
  let leftTruth = List<TruthsLeft>()
  
   var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
