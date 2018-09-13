//
//  TodoListViewCOntrollerViewController.swift
//  ToDoey
//
//  Created by Taylor Batch on 9/10/18.
//  Copyright © 2018 burgeoning. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

   
   var itemArray = [Item]()
   
   var selectedCategory : Category? {
      didSet{
         loadItems()
      }
   }
   
   let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
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
/////////////////////////////////////////////////////////////////
   
   //MARK:- TableView Delegate Methods
   
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     // print(itemArray[indexPath.row])
   
  ////context.delete should be first
  // context.delete(itemArray[indexPath.row])
   //itemArray.remove(at: indexPath.row)
   
   ///Another option to update
  // itemArray[indexPath.row].setValue("Completed", forKey: "title")
   
   itemArray[indexPath.row].done = !itemArray[indexPath.row].done
   
   saveItems()
   
   tableView.deselectRow(at: indexPath, animated: true)
   }

   //MARK:- Add new actions
   
   @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
      
      var textField = UITextField()
      
      let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
      
      let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
         
        
         
         let newItem = Item(context: self.context)
         newItem.title = textField.text!
         newItem.done = false
         newItem.parentCategory = self.selectedCategory
         self.itemArray.append(newItem)
         
         self.saveItems()
      }
      alert.addTextField { (alertTextField) in
         alertTextField.placeholder = "Create item"
         print(alertTextField.text)
         textField = alertTextField
      }
      alert.addAction(action)
      
      self.present(alert, animated: true, completion: nil)
   }
   
   
   func saveItems() {
     
      
      do {
       try context.save()
      } catch {
         print("Saving Error \(error)")
      }
      
      self.tableView.reloadData()
      }
   
   
   //function has default value "= Item.featch...()
   func loadItems(with request: NSFetchRequest<Item>  = Item.fetchRequest(), predicate: NSPredicate? = nil) {
      
      let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
      
      
      if let additionalPredicate = predicate {
         request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
      } else {
         request.predicate = categoryPredicate
      }
      
      do {
        itemArray =  try context.fetch(request)
      } catch {
         print("error\(error)")
      }
      tableView.reloadData()
      
   }


}

//////////////////
//MARK:- EXTENSIONS

extension TodoListViewController: UISearchBarDelegate {
   
   func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      
      let request : NSFetchRequest<Item> = Item.fetchRequest()
      
      let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
      
      request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
      
      loadItems(with: request, predicate: predicate)
      
   }
   
   func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      if searchBar.text?.count == 0 {
         loadItems()
         
         DispatchQueue.main.async {
            searchBar.resignFirstResponder()
         }
         
         
      }
   }
}

