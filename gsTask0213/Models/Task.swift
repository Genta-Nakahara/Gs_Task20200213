//
//  Task.swift
//  gsTask0213
//
//  Created by hdymacuser on 2020/02/13.
//  Copyright © 2020 GentaNakahara. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


class Task: Codable {
    var id: String
    var title: String = ""
    var memo: String = ""
    var createdAt: Timestamp
    var updatedAt: Timestamp
    
   
    init(id: String) {
        self.id = id
        self.createdAt = Timestamp()
        self.updatedAt = Timestamp()
    }
}

