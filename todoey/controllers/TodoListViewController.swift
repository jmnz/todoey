//
//  ViewController.swift
//  todoey
//
//  Created by jesus jimenez on 3/9/19.
//  Copyright © 2019 edgysoft. All rights reserved.
//

import UIKit
import RealmSwift
class TodoListViewController: UITableViewController {
    
    let realm = try! Realm()
    var todoTasks : Results<TodoTask>?
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoTasks?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let task = todoTasks?[indexPath.row] {
            cell.textLabel?.text = task.title
            cell.accessoryType = task.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "no items yet"
        }
        
        return cell
    }
    
    //MARK: - tableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let task = selectedCategory?.tasks[indexPath.row] {
            try? realm.write {
                task.done = !task.done
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Add new Items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Item", message: "", preferredStyle: .alert)
        let action   = UIAlertAction(title: "Add Item", style: .default) { (action) in
            print("success")
            print(textField.text!)
            
            if let currentCategory = self.selectedCategory {
                try? self.realm.write {
                    let newTask = TodoTask()
                    newTask.title = textField.text!
                    newTask.dateCreated = Date()
                    currentCategory.tasks.append(newTask)
                }
            }
            self.tableView.reloadData()

        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func loadItems() {
        todoTasks = selectedCategory?.tasks.sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    

}

// MARK: - Search Bar Method

extension TodoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoTasks = todoTasks?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        print("searching \(searchBar.text!)")
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
}

