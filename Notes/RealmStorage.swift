//
//  Storage.swift
//  Notes
//
//  Created by Timur Mannapov on 2023/2/17.
//

import Foundation
import RealmSwift

class RealmNote: Object {
    
    @objc dynamic var identifier = ""
    @objc dynamic var content = ""
    @objc dynamic var lastEdited: Date = Date()
    
    override class func primaryKey() -> String? {
        return "identifier"
    }
}

//transfet RealmNotes to Notes
extension RealmNote {
    
    convenience init(note: Note) {
        self.init()
        
        self.identifier = note.identifier
        self.content = note.content
        self.lastEdited = note.lastEdited
    }
    
    var note: Note {
        return Note(realmNote: self)
    }
}
