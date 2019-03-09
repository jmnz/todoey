//
//  ViewController.swift
//  todoey
//
//  Created by jesus jimenez on 3/9/19.
//  Copyright © 2019 edgysoft. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController{
    
    let itemArray = ["Find Mike", "Buy Eggs", "Destroy Demogorgon"  ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }

}

