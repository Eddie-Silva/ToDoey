//
//  TruthsViewController.swift
//  Winning
//
//  Copyright © 2018 burgeoning. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class TruthsViewController: UIViewController {
  
  
  
  var leftTruths: Results<TruthsLeft>?
  var rightTruths: Results<TruthsRight>?
  let realm = try! Realm()
  
  var selectedTruth : Scenario? {
    didSet{
      loadTruths()
    }
  }
  
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
    func addTruths() {
      var textField = UITextField()
      let alert = UIAlertController(title: "Add Truth", message: "", preferredStyle: .alert)
      let action = UIAlertAction(title: "Add", style: .default) { (action) in
        
        if let currentScenario = self.selectedTruth {
          do {
            try self.realm.write {
              let newLeftTruth = TruthsLeft()
              newLeftTruth.text = textField.text!
              currentScenario.leftTruth.append(newLeftTruth)
            }
            
          } catch {
            print("Error\(error)")
          }
        }
        
        self.leftTableSection.reloadData()
      }
      
      alert.addTextField { (alertTextField) in
        alertTextField.placeholder = "Add Text"
        print(alertTextField.text!)
        textField = alertTextField
      }
      
      alert.addAction(action)
      self.present(alert, animated: true, completion: nil)
    }
  }
  
  
  @IBAction func rightButtonPressed(_ sender: UIButton) {
    func addTruths() {
      var textField = UITextField()
      let alert = UIAlertController(title: "Add Truth", message: "", preferredStyle: .alert)
      let action = UIAlertAction(title: "Add", style: .default) { (action) in
        
        if let currentScenario = self.selectedTruth {
          do {
            try self.realm.write {
              let newRightTruth = TruthsRight()
              newRightTruth.text = textField.text!
              currentScenario.rightTruth.append(newRightTruth)
            }
            
          } catch {
            print("Error\(error)")
          }
        }
        
        self.rightTableSection.reloadData()
      }
      
      alert.addTextField { (alertTextField) in
        alertTextField.placeholder = "Add Text"
        print(alertTextField.text!)
        textField = alertTextField
      }
      
      alert.addAction(action)
      self.present(alert, animated: true, completion: nil)
    }
  }
  
  
  
  
  //////////////////////////////////////////////////////////
  //MARK: - LOAD and SAVE Data Methods
  
  func loadTruths() {
    self.leftTruths = selectedTruth?.leftTruth.sorted(byKeyPath: "text", ascending: false)
    self.rightTruths = selectedTruth?.rightTruth.sorted(byKeyPath: "text", ascending: false)
    rightTableSection.reloadData()
  }
  
  
  func updateModel(at indexPath: IndexPath) {
    //calls from superclass
    //super.updateModel(at: indexPath)
    if let leftItemForDeletion = leftTruths?[indexPath.row] {
      do {
        try self.realm.write {
          self.realm.delete(leftItemForDeletion)
        }
      } catch {
        print("ERROR \(error)")
      }
    }
    
    if let rightItemForDeletion = rightTruths?[indexPath.row] {
      do {
        try self.realm.write {
          self.realm.delete(rightItemForDeletion)
        }
      } catch {
        print("ERROR \(error)")
      }
    }
  }
  
  
  func save(scenario: Scenario) {
    do {
      try realm.write {
        realm.add(scenario)
      }
    } catch {
      print("Saving Error \(error)")
    }
    
    leftTableSection.reloadData()
    rightTableSection.reloadData()
  }
  
  
  
  //MARK: - END TruthsViewController
}

//////////////////////////////////////////////////////

//MARK: - TableView Extention - Delegate Methods

extension TruthsViewController: UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {
  
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
        cell!.textLabel?.text = leftyScenario.text
      } else {
          cell!.textLabel?.text = "No Scenarios"
        }
    }
    
    
    if tableView == self.rightTableSection {
      cell = tableView.dequeueReusableCell(withIdentifier: "Rcell", for: indexPath)
      if let rightyScenario = rightTruths?[indexPath.row] {
        cell!.textLabel?.text = rightyScenario.text
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
      newTruth.text = textField.text!
      //self.save(category: newTruth)
    }
    
    alert.addAction(action)
    
    alert.addTextField { (field) in
      textField = field
      textField.placeholder = "Create category"
    }
    
    present(alert, animated: true, completion: nil)
  }
  
  
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
    guard orientation == .right else { return nil }
    
    let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
      // handle action by updating model with deletion
      
      self.updateModel(at: indexPath)
    }
    
    // customize the action appearance
    deleteAction.image = UIImage(named: "delete-icon")
    
    return [deleteAction]
  }
  
  
}
