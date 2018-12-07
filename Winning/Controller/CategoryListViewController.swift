//
//  CategoryVC.swift
//  ToDoey
//
//  Created by Taylor Batch on 9/12/18.
//  Copyright © 2018 burgeoning. All rights reserved.
//

import UIKit
import RealmSwift


class CategoryListViewController: SwipeTableViewController {
   
   let realm = try! Realm()

   var categoryList: Results<Category>?

    override func viewDidLoad() {
      super.viewDidLoad()
      loadCategory()
      tableView.rowHeight = 75.0
   }
   
   //MARK:- datasource Methods
   
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return categoryList?.count ?? 1
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = super.tableView(tableView, cellForRowAt: indexPath)
      if let category = categoryList?[indexPath.row] {
        cell.textLabel?.text = category.name
      }
    
      return cell
   }
   
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
      performSegue(withIdentifier: "goToItems", sender: self)
//    categoryList[indexPath.row].done = !categoryList[indexPath.row].done
      tableView.deselectRow(at: indexPath, animated: true)
   }
  
  
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      let destinationVC = segue.destination as! ScenarioListViewController
      if let indexPath = tableView.indexPathForSelectedRow {
         destinationVC.selectedCategory = categoryList?[indexPath.row]
         
      }
   }

   
   
   //MARK:- Data Manipulation methods ( Save and load)
   
   func save(category: Category) {
      do {
         try realm.write {
         realm.add(category)
         }
      } catch {
         print("Saving Error \(error)")
      }
      
      tableView.reloadData()
   }
  
  
   //function has default value "= Item.featch...()
   func loadCategory() {
      categoryList = realm.objects(Category.self)
      
      tableView.reloadData()
   }
  
   
   //MARK:- Delete data with swipe
   
   override func updateModel(at indexPath: IndexPath) {
      
      //calls from superclass
      //super.updateModel(at: indexPath)
      
      if let categoryForDeletion = self.categoryList?[indexPath.row] {
         do {
            try self.realm.write {
              self.realm.delete(categoryForDeletion.scenario)
               self.realm.delete(categoryForDeletion)
            }
         } catch {
            print("ERROR \(error)")
         }
      }
   }
   
   
   //MARK:- Add new Categories when button pressed
   
   
   @IBAction func addItemPressed(_ sender: Any) {
      var textField = UITextField()
      
      let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
      let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
         
        let newCategory = Category()
        newCategory.name = textField.text!
        self.save(category: newCategory)
      }
      
      alert.addAction(action)
      
      alert.addTextField { (field) in
        textField.placeholder = "Create category"
        textField = field
      }
   
      present(alert, animated: true, completion: nil)
   }
   

}
