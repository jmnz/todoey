//
//  TodoTask.swift
//  todoey
//
//  Created by jesus jimenez on 3/27/19.
//  Copyright © 2019 edgysoft. All rights reserved.
//

import Foundation
import RealmSwift

class TodoTask: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    let parentCategory = LinkingObjects(fromType: Category.self, property: "tasks")
    
}
