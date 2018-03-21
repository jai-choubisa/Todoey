//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Jai Choubisa on 14/03/18.
//  Copyright © 2018 Jai Choubisa. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    
    var categories : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
    }
    
    //MARK: - TableView Datasource method
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "Category not added yet"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    //MARK: - Table cell selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let itemsViewObject = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            itemsViewObject.selectedCategory = categories?[indexPath.row]
        }
        
    }
    
    //MARK: - Save New Item
    func saveItems(category : Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        }catch {
            print("Error adding category \(error)")
        }
        
        tableView.reloadData()
    }
    
    //MARK: - Load Saved Items
    func loadItems(){
        
        categories = realm.objects(Category.self)
        
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
                let newItem = Category()
                
                newItem.name = newItemTitle
                
                self.saveItems(category : newItem)
                
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

