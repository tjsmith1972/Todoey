//
//  CategoryViewController.swift
//  Todoey
//
//  Created by TJ Smith on 2/8/18.
//  Copyright © 2018 TJ Smith Company. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    //MARK: DECLARATIONS
    
    let realm = try! Realm()
    
    static var selectedCategory : Int = 0
    
    var categories : Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData("")
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let item = categories?[indexPath.row]
        
        cell.textLabel?.text = item?.name ?? "No categories added yet"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    @IBAction func addCategoryPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            
            let newItem = Category()
            newItem.name = textField.text!
            
            self.saveData(category: newItem)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField //pass reference out to shared scope
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: UTILITY METHODS
    func saveData(category : Category){
        do {
            try realm.write {
                realm.add(category)
            }
            
        }catch{
            print(error)
        }
        tableView.reloadData()
    }
    
    func loadData(_ searchFor : String){
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
}
