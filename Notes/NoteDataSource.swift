//
//  NOte.swift
//  Notes
//
//  Created by Timur Mannapov on 2023/2/17.
//

import Foundation
import RealmSwift

protocol DataSource {
    
    func store<T>(object: T)
    func delete<T>(object: T)
}

class NoteDataSource: DataSource {
    
    var notes: [Note] {
        let objects = realm.objects(RealmNote.self).sorted(byKeyPath: "lastEdited", ascending: true)
        
        return objects.map {
            return $0.note
        }
    }
    
    var realm: Realm
    
    init() {
        //Realm
        realm = try! Realm()
    }
    
    func store<T>(object: T) {
        guard let note = object as? Note else { return }
        
        // Save our note
        try? self.realm.write {
            realm.add(note.realmNote, update: .all)
        }
        
        NotificationCenter.default.post(name: .noteDataChanged, object: nil)
    }
    
    func delete<T>(object: T) {
        guard let note = object as? Note else { return }
        
        // Delete our note
        if let realmNote = realm.object(ofType: RealmNote.self, forPrimaryKey: note.identifier) {
            self.realm.beginWrite()
            self.realm.delete(realmNote)
            try? self.realm.commitWrite()
//            realm.delete(realmNote)
        }
        
        NotificationCenter.default.post(name: .noteDataChanged, object: nil)
    }
}

extension Notification.Name {
    static let noteDataChanged = Notification.Name(rawValue: "noteDataChanged")
}
