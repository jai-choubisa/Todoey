//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Jai Choubisa on 14/03/18.
//  Copyright © 2018 Jai Choubisa. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categories = [Category]()
    
    //MARK: - Store Data using CoreData
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
    }
    
    //MARK: - TableView Datasource method
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let item = categories[indexPath.row]
        
        cell.textLabel?.text = item.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    //MARK: - Table cell selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let itemsViewObject = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            itemsViewObject.selectedCategory = categories[indexPath.row]
        }
        
    }
    
    //MARK: - Save New Item
    func saveItems() {
        //Method 3 - Core Data
        do {
            try context.save()
        }catch {
            print("Error in saving core data in saveItems - \(error)")
        }
        
        tableView.reloadData()
    }
    
    //MARK: - Load Saved Items
    func loadItems(with request : NSFetchRequest<Category> = Category.fetchRequest()){
        //let request : NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categories = try context.fetch(request)
        }catch {
            print("Error in fetch Category - \(error)")
        }
        
        tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var itemTextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Add", style: .default) {
            (action) in
            
            if let newItemTitle = itemTextField.text {
                //let newItem = Category()
                
                //M3 - Using Core Data
                let newItem = Category(context: self.context)
                
                newItem.name = newItemTitle
                
                self.categories.append(newItem)
                
                self.saveItems()
                
                //save data using UserDefaults - can string array but not custom class array
                //self.delfaults.set(self.categories, forKey: "toDoListArray")
                
                self.tableView.reloadData()
            }
        }
        
        alert.addTextField { (newItemTextField) in
            itemTextField = newItemTextField
        }
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}

