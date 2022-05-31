//
//  StorageManager.swift
//  EmojiReader
//
//  Created by Alexander Popov on 31.05.2022.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    static func saveObject(_ emoji: Emoji){
        
        try! realm.write{
            realm.add(emoji)
        }
    }
    
    static func deleteObject(_ emoji: Emoji){
        try! realm.write{
            realm.delete(emoji)
        }
    }
}
