//
//  ViewController.swift
//  todoey
//
//  Created by jesus jimenez on 3/9/19.
//  Copyright © 2019 edgysoft. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
class TodoListViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    let realm = try! Realm()
    var todoTasks : Results<TodoTask>?
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory!.name
        guard let colorHex = selectedCategory?.color else {fatalError("category not assigned")}
        updateNavBar(with: colorHex)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let originalColor = HexColor("1D9BF6") else {fatalError()}
        updateNavBar(with: originalColor.hexValue())
        
    }
    
    //MARK:- nav bar color setup methods
    
    func updateNavBar(with colorHexCode: String) {
        guard let navBar = navigationController?.navigationBar else {fatalError("navigation ontroller does not exist.")}
        navBar.barTintColor = HexColor(colorHexCode)
        navBar.tintColor = ContrastColorOf(navBar.barTintColor!, returnFlat: true)
        searchBar.barTintColor = HexColor(colorHexCode)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBar.barTintColor!, returnFlat: true)]
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoTasks?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let task = todoTasks?[indexPath.row] {
            cell.textLabel?.text = task.title
            cell.backgroundColor = HexColor(selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(todoTasks!.count))
            cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
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
    
    //MARK:- delete items
    
    override func updateModel(at indexPath: IndexPath) {
        if let taskForDeletion = self.todoTasks?[indexPath.row]{
            try? self.realm.write {
                self.realm.delete(taskForDeletion)
            }
        }
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

