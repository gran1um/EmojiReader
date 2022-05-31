//
//  EmojiTableViewController.swift
//  EmojiReader
//
//  Created by Alexander Popov on 28.05.2022.
//

import UIKit
import RealmSwift

class EmojiTableViewController: UITableViewController {
    
    var objects = [Emoji]()
    
    private var emojis: Results<Emoji>!

    override func viewDidLoad() {
        super.viewDidLoad()
        emojis = realm.objects(Emoji.self)
        objects = [Emoji](emojis)
        self.title = "EmojiReader"
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }

    
    @IBAction func unwindSegue(segue: UIStoryboardSegue){

        guard segue.identifier == "saveSegue" else {return}
        let sourceVC = segue.source as! NewEmojiTableViewController
        let emoji = sourceVC.emoji
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            let object = [Emoji](realm.objects(Emoji.self))[selectedIndexPath.row]
        try! realm.write{
            object.emoji = emoji.emoji
            object.name = emoji.name
            object.desc = emoji.desc
        }
            
            tableView.reloadRows(at: [selectedIndexPath], with: .fade)
        }
        else {
            StorageManager.saveObject(emoji)
            tableView.reloadData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "editEmoji" else {return}
        let indexPath = tableView.indexPathForSelectedRow!
        let emoji = emojis[indexPath.row]
        let navigationVC = segue.destination as! UINavigationController
        let newEmojiVC = navigationVC.topViewController as! NewEmojiTableViewController
        newEmojiVC.emoji = emoji
        newEmojiVC.title = "Edit"
    }
    // MARK: - Table view data source544

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emojis.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "emojiCell", for: indexPath) as! EmojiTableViewCell

        let object = emojis[indexPath.row]

        cell.set(object: object)

        return cell
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    override func tableView(_ tableView: UITableView, commit editingStyle:UITableViewCell.EditingStyle,forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var object = [Emoji](realm.objects(Emoji.self))[indexPath.row]
            StorageManager.deleteObject(object)
            tableView.deleteRows(at: [indexPath], with: .fade)
           
        }
        else {
            print("321")
        }
    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

//    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        let movedEmoji = objects.remove(at: sourceIndexPath.row)
//        objects.insert(movedEmoji, at: destinationIndexPath.row)
//        tableView.reloadData()
//    }

    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let done = doneAction(at: indexPath)
        let like = favouriteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [done,like])
    }

    func doneAction(at indexPath: IndexPath) -> UIContextualAction{
        let action = UIContextualAction(style: .destructive, title: "done") { action, view, completion in
            StorageManager.deleteObject(self.objects.remove(at: indexPath.row))
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        action.backgroundColor = .systemGreen
        action.image = UIImage(systemName: "checkmark.circle")
        return action
    }

    func favouriteAction(at indexPath: IndexPath) -> UIContextualAction{
        var object = [Emoji](realm.objects(Emoji.self))[indexPath.row]
        
        let action = UIContextualAction(style: .normal, title: "like") { action, view, completion in
           
            try! realm.write{
                object.isFavourite = !object.isFavourite
            }
            
            completion(true)
        }
        action.backgroundColor = object.isFavourite ? .systemPurple : .systemGray
        action.image = UIImage(systemName: "heart")
        return action

    }
}
