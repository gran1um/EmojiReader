//
//  EmojiModal.swift
//  EmojiReader
//
//  Created by Alexander Popov on 28.05.2022.
//

import Foundation
import RealmSwift


class Emoji: Object{
    @objc dynamic var emoji = ""
    @objc dynamic var name: String?
    @objc dynamic var desc: String?
    @objc dynamic var isFavourite = false
    
    convenience init(emoji: String, name:String?, desc:String?, isFavourite: Bool){
        self.init()
        self.emoji = emoji
        self.name = name
        self.desc = desc
        self.isFavourite = isFavourite
    }
        
}


