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
  
  
   let realm = try! Realm()
  
  var leftTruths: Results<TruthsLeft>?
  var rightTruths: Results<TruthsRight>?
  var selectedScenario : Scenario? {
    didSet{
      loadTruths()
    }
  }
  
  @IBOutlet weak var leftView: UIView!
  @IBOutlet weak var rightView: UIView!
  @IBOutlet weak var leftTableSection: UITableView!
  @IBOutlet weak var rightTableSection: UITableView!
  
  
    override func viewDidLoad() {
        super.viewDidLoad()

      leftTableSection.delegate = self
      leftTableSection.dataSource = self
      leftTableSection.reloadData()
      leftTableSection.register(UINib(nibName: "TruthCell", bundle: nil), forCellReuseIdentifier: "truthCell")
      
      rightTableSection.delegate = self
      rightTableSection.dataSource = self
      rightTableSection.reloadData()
      rightTableSection.register(UINib(nibName: "TruthCell", bundle: nil), forCellReuseIdentifier: "truthCell")
     
      
    }
  
  
  //////////////////////////////////////////////////////
  //MARK: - ADD TRUTHS button pressed
  @IBAction func leftButtonPressed(_ sender: UIButton) {
      var textField = UITextField()
      let alert = UIAlertController(title: "Add Truth", message: "", preferredStyle: .alert)
      let action = UIAlertAction(title: "Add", style: .default) { (action) in
        
        if let currentScenario = self.selectedScenario {
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
  
  
  @IBAction func rightButtonPressed(_ sender: UIButton) {
      var textField = UITextField()
      let alert = UIAlertController(title: "Add Truth", message: "", preferredStyle: .alert)
      let action = UIAlertAction(title: "Add", style: .default) { (action) in
        
        if let currentScenario = self.selectedScenario {
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
  
  
  
  
  //////////////////////////////////////////////////////////
  //MARK: - LOAD and SAVE Data Methods
  
  func loadTruths() {
    self.leftTruths = selectedScenario?.leftTruth.sorted(byKeyPath: "text", ascending: false)
    self.rightTruths = selectedScenario?.rightTruth.sorted(byKeyPath: "text", ascending: false)
    
    rightTableSection?.reloadData()
    leftTableSection?.reloadData()
  }
  
  
  func updateModel(at indexPath: IndexPath) {
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
  
  
  //MARK: - END TruthsViewController
}

//////////////////////////////////////////////////////

//MARK: - TableView Extention - Delegate Methods

extension TruthsViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if tableView == leftTableSection {
      return leftTruths?.count ?? 1
    } else if tableView == rightTableSection {
      return rightTruths?.count ?? 1
    } else {
      print("Error no rows in section")
    }
    tableView.reloadData()
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCell(withIdentifier: "truthCell", for: indexPath) as? TruthCell

    
    if tableView == self.leftTableSection {
      cell = tableView.dequeueReusableCell(withIdentifier: "truthCell", for: indexPath) as? TruthCell
      if let leftyScenario = leftTruths?[indexPath.row] {
        cell?.truthCellText?.text = leftyScenario.text
        cell?.backgroundColor = leftyScenario.agreedTruth ? #colorLiteral(red: 0.8329799486, green: 1, blue: 0.3445181094, alpha: 1) : #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
      }
    }
    if tableView == self.rightTableSection {
      cell = tableView.dequeueReusableCell(withIdentifier: "truthCell", for: indexPath) as? TruthCell
      if let rightyScenario = rightTruths?[indexPath.row] {
        cell?.truthCellText?.text = rightyScenario.text
         cell?.backgroundColor = rightyScenario.agreedTruth ? #colorLiteral(red: 0.8329799486, green: 1, blue: 0.3445181094, alpha: 1) : #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        
      }
      
    }
   
    return cell!
  }
  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if tableView == rightTableSection {
      if let truth = rightTruths?[indexPath.row] {
        do {
          try realm.write {
            truth.agreedTruth = !truth.agreedTruth
          }
        } catch {
          print("Error \(error)")
        }
      }
    }
    if tableView == leftTableSection {
      if let truth = leftTruths?[indexPath.row] {
        do {
          try realm.write {
            truth.agreedTruth = !truth.agreedTruth
            
          }
        } catch {
          print("Error \(error)")
      }
    }
    }
    tableView.deselectRow(at: indexPath, animated: true)
    tableView.reloadData()
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      
      if tableView == leftTableSection {
      if let truthForDeletion = leftTruths?[indexPath.row] {
        do {
          try self.realm.write {
            self.realm.delete(truthForDeletion)
            
          }
        } catch {
          print("ERROR \(error)")
        }
      }
      
      }
      if tableView == rightTableSection {
        if let truthForDeletion = rightTruths?[indexPath.row] {
          do {
            try self.realm.write {
              self.realm.delete(truthForDeletion)
            }
          } catch {
            print("ERROR \(error)")
          }
        }
      }
    }
    tableView.reloadData()
  }
  
}
