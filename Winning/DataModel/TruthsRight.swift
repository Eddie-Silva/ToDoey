//
//  TruthsRight.swift
//  Winning
//
//  Created by Taylor Batch on 11/30/18.
//  Copyright © 2018 burgeoning. All rights reserved.
//

import Foundation
import RealmSwift

class TruthsRight: Object {
  @objc dynamic var text: String = ""
  @objc dynamic var agreedTruth: Bool = false
  
 var parentScenario = LinkingObjects(fromType: Scenario.self, property: "rightTruth")
}
