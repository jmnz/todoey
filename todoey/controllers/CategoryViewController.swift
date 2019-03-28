//
//  CategoryViewController.swift
//  todoey
//
//  Created by jesus jimenez on 3/22/19.
//  Copyright © 2019 edgysoft. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var categoryArray : Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        tableView.separatorStyle = .none
        tableView.rowHeight = 80.0
    }
    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No categories added yet"
        cell.backgroundColor = HexColor(categoryArray?[indexPath.row].color ?? UIColor.flatWhite.hexValue())
        cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
        return cell
    }
    //MARK: - Data Manipulation Methods
    
    func saveData(category:Category) {
        try? realm.write {
            realm.add(category)
        }
        tableView.reloadData()
    }
    func loadCategories() {
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    // MARK:- delete data from swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categoryArray?[indexPath.row] {
            try? self.realm.write {
                self.realm.delete(categoryForDeletion)
            }
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "add category", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textfield.text ?? ""
            newCategory.color = UIColor.randomFlat.hexValue()
            self.saveData(category: newCategory)
        }
        alert.addTextField { (AlertTextField) in
            AlertTextField.placeholder = "new category"
            textfield = AlertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexpath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = self.categoryArray?[indexpath.row]
        }
    }
    
}


