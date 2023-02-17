//
//  Note.swift
//  Notes
//
//  Created by Timur Mannapov on 2023/2/17.
//

import Foundation

protocol NoteProtocol {
    
    func write(dataSource: DataSource)
    func delete(dataSource: DataSource)
}

class Note {
    
    var identifier: String
    var content: String
    var lastEdited: Date
    
    init(identifier: String = UUID().uuidString, content: String, lastEdited: Date = Date()) {
        self.identifier = identifier
        self.content = content
        self.lastEdited = lastEdited
    }
}

extension Note {
    
    convenience init(realmNote: RealmNote) {
        self.init(identifier: realmNote.identifier, content: realmNote.content, lastEdited: realmNote.lastEdited)
    }
    
    var realmNote: RealmNote {
        return RealmNote(note: self )
    }
}
   
extension Note: NoteProtocol {
    
    func write(dataSource: DataSource) {
        self.lastEdited = Date()
        
        dataSource.store(object: self)
    }
    
    func delete(dataSource: DataSource) {
        dataSource.delete(object: self)
    }
}


