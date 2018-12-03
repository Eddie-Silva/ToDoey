//
//  TruthsViewController.swift
//  Winning
//
//  Copyright © 2018 burgeoning. All rights reserved.
//

import UIKit
import RealmSwift

class TruthsViewController: UIViewController {
  
  var leftTruths: Results<TruthsLeft>?
  var rightTruths: Results<TruthsRight>?
  
  @IBOutlet weak var leftView: UIView!
  @IBOutlet weak var rightView: UIView!
  @IBOutlet weak var progressView: UIView!
  @IBOutlet weak var leftTableSection: UITableView!
  @IBOutlet weak var rightTableSection: UITableView!
  @IBOutlet weak var leftTitle: UILabel!
  @IBOutlet weak var rightTitle: UILabel!
  
  var selectedTruths : Scenario? {
    didSet{
     // loadItems()
    }
  }
  
    override func viewDidLoad() {
        super.viewDidLoad()

      leftTableSection.delegate = self
      leftTableSection.dataSource = self
      
      rightTableSection.delegate = self
      rightTableSection.dataSource = self
    }
  
  
  //////////////////////////////////////////////////////
  //MARK: - ADD TRUTHS button pressed
  @IBAction func leftButtonPressed(_ sender: UIButton) {
  }
  
  
  @IBAction func rightButtonPressed(_ sender: UIButton) {
  }
  
  
  //MARK: - END TruthsViewController
}

//////////////////////////////////////////////////////

//MARK: - TableView Extention - Delegate Methods

extension TruthsViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell: UITableViewCell?
//    let leftCell = tableView.dequeueReusableCell(withIdentifier: "Lcell", for: indexPath)
//    let rightCell = tableView.dequeueReusableCell(withIdentifier: "Rcell", for: indexPath)
//    if let leftyScenario = leftTruths?[indexPath.row] {
//      leftCell.textLabel?.text = leftyScenario.leftText
//      //cell.accessoryType = leftyScenario.done ? .checkmark : .none
//    } else {
//      leftCell.textLabel?.text = "No Scenarios"
//      }
//
//    return cell
    
    if tableView == self.leftTableSection {
      cell = tableView.dequeueReusableCell(withIdentifier: "Lcell", for: indexPath)
      if let leftyScenario = leftTruths?[indexPath.row] {
        cell!.textLabel?.text = leftyScenario.leftText
      } else {
          cell!.textLabel?.text = "No Scenarios"
        }
    }
    
    
    if tableView == self.rightTableSection {
      cell = tableView.dequeueReusableCell(withIdentifier: "Rcell", for: indexPath)
      if let rightyScenario = rightTruths?[indexPath.row] {
        cell!.textLabel?.text = rightyScenario.rightText
      } else {
        cell!.textLabel?.text = "No Scenarios"
      }
      
    }
      return cell!
    }
  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add Truth", message: "", preferredStyle: .alert)
    let action = UIAlertAction(title: "Add", style: .default) { (action) in
      
      let newTruth = TruthsLeft()
      newTruth.leftText = textField.text!
      //self.save(category: newTruth)
    }
    
    alert.addAction(action)
    
    alert.addTextField { (field) in
      textField = field
      textField.placeholder = "Create category"
    }
    
    present(alert, animated: true, completion: nil)
  }
  
  
}
