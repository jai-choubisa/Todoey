//
//  ViewController.swift
//  Todoey
//
//  Created by Jai Choubisa on 03/02/18.
//  Copyright © 2018 Jai Choubisa. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    //MARK: - Store Data using UserDefaults
    //To store data with persistence, we can use UserDefaults to store data in user's device with key value pair.
    //var delfaults = UserDefaults.standard
    
    //MARK: - Store Data using custom Plist
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //MARK: - Store Data using CoreData
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        
        //print(filePath)
        
        //get data from UserDefaults storages
//        if let item = delfaults.array(forKey: "toDoListArray") as? [Item] {
//            itemArray = item
//        }
        
        //Method 2- Custom plist storage
        //loadItems()
    }
    
    //MARK: - TableView Datasource method
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoListTableView", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ?  .checkmark : .none
        
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK: - Table cell selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK: - Add New Item Pressed
    @IBAction func AddNewItemPressed(_ sender: UIBarButtonItem) {
        var itemTextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Add", style: .default) {
            (action) in
            
            if let newItemTitle = itemTextField.text {
                //let newItem = Item()
                
                //M3 - Using Core Data
                let newItem = Item(context: self.context)
                
                newItem.title = newItemTitle
                newItem.done = false
                newItem.parentCategory = self.selectedCategory
                
                self.itemArray.append(newItem)
                
                self.saveItems()
                
                //save data using UserDefaults - can string array but not custom class array
                //self.delfaults.set(self.itemArray, forKey: "toDoListArray")
                
                self.tableView.reloadData()
            }
        }
        
        alert.addTextField { (newItemTextField) in
           itemTextField = newItemTextField
        }
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    
    }
    
    //MARK: - Save New Item
    func saveItems() {
        //Method 2 - Codable protocol
        /*let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch {
            print("Error in encoding item - \(error)")
        }*/
        
        //Method 3 - Core Data
        do {
            try context.save()
        }catch {
            print("Error in saving core data in saveItems - \(error)")
        }
        
        tableView.reloadData()
    }
    
    //MARK: - Load Saved Items
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(),predicate : NSPredicate? = nil){
        //Method 2 - Codable Protocol
        /*let decoder = PropertyListDecoder()
        
        do {
            if let data = try? Data(contentsOf : dataFilePath!) {
                itemArray = try decoder.decode([Item].self, from: data)
            }
        }catch {
            print("Error in decoding item - \(error)")
        }*/
        
        //print("Loading Items")
        
        //Method 3 - CoreData
        //let request : NSFetchRequest<Item> = Item.fetchRequest()
//        print("selectedCategory name = \(selectedCategory!.name!)")
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)

        if let receivedPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [receivedPredicate,categoryPredicate])
        }else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        }catch {
            print("Error in fetch item - \(error)")
        }
        
        tableView.reloadData()
    }
}

//MARK: - Search Bar extension
extension ToDoListViewController : UISearchBarDelegate {
    //search button clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //to fetch data use NSFetchRequest
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        //to filter data use NSPredicate
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@",searchBar.text!)
        
        //to sort data use NSSortDescriptor
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request,predicate: predicate)
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

