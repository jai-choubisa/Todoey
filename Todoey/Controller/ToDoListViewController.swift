//
//  ViewController.swift
//  Todoey
//
//  Created by Jai Choubisa on 03/02/18.
//  Copyright © 2018 Jai Choubisa. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var itemArray : Results<Item>?
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - TableView Datasource method
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoListTableView", for: indexPath)
        
        if let item = itemArray?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ?  .checkmark : .none
        }else {
            cell.textLabel?.text = "No item added yet"
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    //MARK: - Table cell selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = itemArray?[indexPath.row] {
            do {
                try realm.write {
                    //update in realm
                    item.done = !item.done
                    
                    //delete using realm
                    //realm.delete(item)
                }
            }catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK: - Add New Item Pressed
    @IBAction func AddNewItemPressed(_ sender: UIBarButtonItem) {
        var itemTextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Add", style: .default) {
            (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = itemTextField.text!
                        newItem.createAt = Date()
                        currentCategory.items.append(newItem)
                    }
                }catch {
                    print("Error in adding new Item, \(error)")
                }
                self.tableView.reloadData()
            }
        }
        
        alert.addTextField { (newItemTextField) in
           itemTextField = newItemTextField
        }
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    
    }
    
    //MARK: - Load Saved Items
    func loadItems(){
        
        itemArray = selectedCategory?.items.sorted(byKeyPath: "createAt", ascending: false)
        
        tableView.reloadData()
    }
}

//MARK: - Search Bar extension
extension ToDoListViewController : UISearchBarDelegate {
    //search button clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Button Pressed");
        itemArray = itemArray?.filter("title CONTAINS[cd] %@",searchBar.text!).sorted(byKeyPath: "title", ascending: true);
        tableView.reloadData()
    }

    //search bar text emtpy
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                //go to original state. closes keyboard
                searchBar.resignFirstResponder()
            }

        }
    }
}

