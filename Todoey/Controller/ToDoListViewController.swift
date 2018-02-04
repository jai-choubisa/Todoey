//
//  ViewController.swift
//  Todoey
//
//  Created by Jai Choubisa on 03/02/18.
//  Copyright © 2018 Jai Choubisa. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    //MARK - Store Data using UserDefaults
    //To store data with persistence, we can use UserDefaults to store data in user's device with key value pair.
    //var delfaults = UserDefaults.standard
    
    //MARK - Store Data using custom Plist
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //print(dataFilePath)
        
        //get data from UserDefaults storages
//        if let item = delfaults.array(forKey: "toDoListArray") as? [Item] {
//            itemArray = item
//        }
        
        //Method 2- Custom plist storage
        loadItems()
    }
    
    //MARK - TableView Datasource method
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
    
    //MARK - Table cell selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK - Add New Item Pressed
    @IBAction func AddNewItemPressed(_ sender: UIBarButtonItem) {
        var itemTextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Add", style: .default) {
            (action) in
            
            if let newItemTitle = itemTextField.text {
                let newItem = Item()
                
                newItem.title = newItemTitle
                
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
    
    //MARK - Save New Item
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch {
            print("Error in encoding item - \(error)")
        }
        
        tableView.reloadData()
    }
    
    //MARK - Load Saved Items
    func loadItems(){
        let decoder = PropertyListDecoder()
        
        do {
            if let data = try? Data(contentsOf : dataFilePath!) {
                itemArray = try decoder.decode([Item].self, from: data)
            }
        }catch {
            print("Error in decoding item - \(error)")
        }
        
    }
}

