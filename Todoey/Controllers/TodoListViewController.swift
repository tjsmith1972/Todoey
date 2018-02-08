//
//  ViewController.swift
//  Todoey
//
//  Created by TJ Smith on 2/8/18.
//  Copyright © 2018 TJ Smith Company. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    @IBOutlet var searchBar: UISearchBar!
    //MARK: DECLARATIONS
    let realm = try! Realm()
    
    var todoItems : Results<Item>?
    
    var selectedCategory : Category? {
        didSet{
            loadData("")
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    //MARK: VIEW EVENTS
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //searchBar.delegate = self
        loadData("")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: ACTIONS
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in

            if let currentCategory = self.selectedCategory{
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print(error)
                }
            }
            
            self.tableView.reloadData()
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField //pass reference out to shared scope
        }

        alert.addAction(action)

        present(alert, animated: true, completion: nil)
        
    }
    
    
    //MARK:  TABLEVIEW OVERRIDES
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //todoItems[indexPath.row].done = !todoItems[indexPath.row].done
        
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
        
        
        //saveData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row]{
        
        cell.textLabel?.text = item.title
        
        cell .accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "no items yet"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    //MARK: UTILITY METHODS
    
    func loadData(_ searchFor : String = ""){
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    
}

//extension TodoListViewController: UISearchBarDelegate{
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        loadData(searchBar.text!)
//    }
//
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        loadData()
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            loadData()
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        }
//    }
//}

