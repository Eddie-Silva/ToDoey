//
//  TruthsLeft.swift
//  Winning
//
//  Created by Taylor Batch on 11/30/18.
//  Copyright © 2018 burgeoning. All rights reserved.
//

import Foundation
import RealmSwift

class TruthsLeft: Object {
  @objc dynamic var leftText: String = ""
  @objc dynamic var agreedTruth: Bool = false

  let parentScenario = LinkingObjects(fromType: Scenario.self, property: "leftTruth")
}
