//
//  TodoListViewCOntrollerViewController.swift
//  ToDoey
//
//  Created by Taylor Batch on 9/10/18.
//  Copyright © 2018 burgeoning. All rights reserved.
//

import UIKit
import RealmSwift

class ScenarioListViewController: SwipeTableViewController {

   @IBOutlet weak var searchBar: UISearchBar!
   let realm = try! Realm()
  
   var scenarioList: Results<Scenario>?
   var selectedCategory : Category? {
      didSet{
         loadScenarios()
      }
   }
  
   override func viewDidLoad() {
      super.viewDidLoad()
      tableView.separatorStyle = .none
   }
  
   override func viewWillAppear(_ animated: Bool) {
       title = selectedCategory?.name
   }
   
   override func viewWillDisappear(_ animated: Bool) {
   }
  
  
//////////////////////////////////////////////////////////////
   //MARK:- TableView Delegate Methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return scenarioList?.count ?? 1
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = super.tableView(tableView, cellForRowAt: indexPath)
    if let item = scenarioList?[indexPath.row] {
      cell.textLabel?.text = item.title
      cell.accessoryType = item.done ? .checkmark : .none
    } else {
      cell.textLabel?.text = "No Scenarios"
    }
    
    return cell
  }
  
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "ToTruths", sender: self)
    if let scenario = scenarioList?[indexPath.row] {
      do {
        //to delete data from realm object
        // try realm.delete(item)
        try realm.write {
          scenario.done = !scenario.done
        }
      } catch {
          print("Error \(error)")
        }
    }
   
    tableView.reloadData()
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destinationVC = segue.destination as! TruthsViewController
    if let indexPath = tableView.indexPathForSelectedRow {
      //switched scenarioList from scenarioArray
      destinationVC.selectedScenario = scenarioList?[indexPath.row]
    }
  }
  
//  func loadItems() {
//    scenarioList = realm.objects(Scenario.self)
//
//    tableView.reloadData()
//
//  }
  
//////////////////////////////////////////////////////////////
   //MARK:- Add New Scenario
   
   @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
      var textField = UITextField()
      let alert = UIAlertController(title: "Add New Scenario", message: "", preferredStyle: .alert)
      let action = UIAlertAction(title: "Add", style: .default) { (action) in
        
         if let currentCategory = self.selectedCategory {
            do {
              try self.realm.write {
                let newScenario = Scenario()
                newScenario.title = textField.text!
                newScenario.dateCreated = Date()
                currentCategory.scenario.append(newScenario)
              }
              
            } catch {
                print("Error\(error)")
              }
         }
        
        self.tableView.reloadData()
    }
    
    alert.addTextField { (alertTextField) in
      alertTextField.placeholder = "Create Scenario"
      print(alertTextField.text!)
      textField = alertTextField
    }
    
    alert.addAction(action)
    self.present(alert, animated: true, completion: nil)
  }
  
  
//////////////////////////////////////////////////////////
  //MARK: - LOAD and SAVE Data Methods
  
   func loadScenarios() {
      scenarioList = selectedCategory?.scenario.sorted(byKeyPath: "title", ascending: true)
      tableView.reloadData()
   }
  
   
   override func updateModel(at indexPath: IndexPath) {
      //calls from superclass
      //super.updateModel(at: indexPath)
    if let itemForDeletion = scenarioList?[indexPath.row] {
      do {
        try self.realm.write {
          self.realm.delete(itemForDeletion)
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
    
    tableView.reloadData()
  }
   
   
///END OF TodoListViewController///
}


//////////////////
//MARK:- EXTENSIONS

extension ScenarioListViewController: UISearchBarDelegate {

   func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      scenarioList = scenarioList?.filter("title CONTAINS %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
      
      tableView.reloadData()
   }

   func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      if searchBar.text?.count == 0 {
         loadScenarios()

         DispatchQueue.main.async {
            searchBar.resignFirstResponder()
         }


      }
   }
}

