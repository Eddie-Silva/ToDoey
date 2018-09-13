//
//  CategoryVC.swift
//  ToDoey
//
//  Created by Taylor Batch on 9/12/18.
//  Copyright © 2018 burgeoning. All rights reserved.
//

import UIKit
import CoreData

class CategoryVC: UITableViewController {

   var categoryArray = [Category]()
   
   let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
   
    override func viewDidLoad() {
        super.viewDidLoad()
      
      loadCategory()
   }
   
   //MARK:- datasource Methods
   
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return categoryArray.count
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
      
     // let category = categoryArray[indexPath.row]
      
      cell.textLabel?.text = categoryArray[indexPath.row].name
      
//      cell.accessoryType = category.done ? .checkmark : .none
      
      return cell
   }
   
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
      performSegue(withIdentifier: "goToItems", sender: self)
//      categoryArray[indexPath.row].done = !categoryArray[indexPath.row].done
      
      saveCategory()
      
      tableView.deselectRow(at: indexPath, animated: true)
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      let destinationVC = segue.destination as! TodoListViewController
      
      if let indexPath = tableView.indexPathForSelectedRow {
         destinationVC.selectedCategory = categoryArray[indexPath.row]
      }
   }

   
   
   //MARK:- Data Manipulation methods ( Save and load)
   
   func saveCategory() {
      
      do {
         try context.save()
      } catch {
         print("Saving Error \(error)")
      }
      
      tableView.reloadData()
   }
   
   
   //function has default value "= Item.featch...()
   func loadCategory() {
      let request: NSFetchRequest<Category> = Category.fetchRequest()
      
      do {
         categoryArray =  try context.fetch(request)
      } catch {
         print("error\(error)")
      }
      tableView.reloadData()
      
   }
   
   
   //Mark:- Add new Categories when button pressed
   
   
   
   @IBAction func addItemPressed(_ sender: Any) {
      var textField = UITextField()
      
      let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
      
      let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
         
         let newCategory = Category(context: self.context)
         newCategory.name = textField.text!

         self.categoryArray.append(newCategory)
         
         self.saveCategory()
      }
      
      alert.addAction(action)
      
      alert.addTextField { (field) in
         textField = field
         textField.placeholder = "Create category"
      }
   
      present(alert, animated: true, completion: nil)
   }
   
   
   //MARK:- TableviewDelegate
   
   
}
