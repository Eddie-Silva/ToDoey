//
//  Item.swift
//  ToDoey
//
//  Created by Taylor Batch on 9/13/18.
//  Copyright © 2018 burgeoning. All rights reserved.
//

import Foundation
import RealmSwift

class Scenario: Object {
   
  @objc dynamic var title: String = ""
  @objc dynamic var done: Bool = false
  @objc dynamic var dateCreated: Date?
  
  let leftTruth = List<TruthsLeft>()
  let rightTruth = List<TruthsRight>()
  
   var parentCategory = LinkingObjects(fromType: Category.self, property: "scenario")
}
