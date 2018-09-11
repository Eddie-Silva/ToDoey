//
//  TodoListViewCOntrollerViewController.swift
//  ToDoey
//
//  Created by Taylor Batch on 9/10/18.
//  Copyright © 2018 burgeoning. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

   
   var itemArray = [Item()]
   
   let defaults = UserDefaults.standard
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      let newItem = Item()
      newItem.title = "Find Mike"
      itemArray.append(newItem)
      
      if let items = defaults.array(forKey: "TodoListArry") as? [Item] {
         itemArray = items
      }
   }

   
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return itemArray.count
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
      
      let item = itemArray[indexPath.row]
      
      cell.textLabel?.text = item.title
      
      cell.accessoryType = item.done ? .checkmark : .none
      
      return cell
   }
   
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     // print(itemArray[indexPath.row])
   
   itemArray[indexPath.row].done = !itemArray[indexPath.row].done
   
   
  tableView.reloadData()
   
   tableView.deselectRow(at: indexPath, animated: true)
   }

   //MARK:- Add new actions
   
   @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
      
      var textField = UITextField()
      
      let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
      
      let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
         
         let newItem = Item()
         newItem.title = textField.text!
         
         self.itemArray.append(newItem)
         
         self.defaults.set(self.itemArray, forKey: "TodoListArry")
         
         self.tableView.reloadData()
      }
      
      alert.addTextField { (alertTextField) in
         alertTextField.placeholder = "Create item"
         print(alertTextField.text)
         textField = alertTextField
      }
      alert.addAction(action)
      
      present(alert, animated: true, completion: nil)
   }
   
}

