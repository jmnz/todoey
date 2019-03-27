//  File.swift
//  todoey
//
//  Created by jesus jimenez on 3/27/19.
//  Copyright © 2019 edgysoft. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    let tasks = List<TodoTask>()
}
