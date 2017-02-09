//
//  ListTableViewController.swift
//  iOSProject
//
//  Created by クリス on 2017/01/21.
//  Copyright © 2017年 SystemStudio. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ListTableViewController: UITableViewController {
    
    // MARK: Constants
    let listToUsers = "ListToUsers"
    
    // MARK: Properties
    let usersRef = FIRDatabase.database().reference(withPath: "online")
    let word = FIRDatabase.database().reference(withPath: "posts")
    let userWord = FIRDatabase.database().reference(withPath: "user-posts")
    let meaning = FIRDatabase.database().reference(withPath: "body")
    var items: [Item] = []
    var user: User!
    var userCountBarButtonItem: UIBarButtonItem!
    
    // MARK: UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
            let currentUserRef = self.usersRef.child(self.user.uid)
            currentUserRef.setValue(self.user.email)
            currentUserRef.onDisconnectRemoveValue()
        }
        
        usersRef.observe(.value, with: { snapshot in
            if snapshot.exists() {
                self.userCountBarButtonItem?.title = snapshot.childrenCount.description
            } else {
                self.userCountBarButtonItem?.title = "0"
            }
        })
        
        tableView.allowsMultipleSelectionDuringEditing = false
        
        userCountBarButtonItem = UIBarButtonItem(title: "1",
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(userCountButtonDidTouch))
        userCountBarButtonItem.tintColor = UIColor.white
        navigationItem.leftBarButtonItem = userCountBarButtonItem
        
        user = User(id: "ASDF45GG", uid: "FakeId", email: "hungry@person.food")
        
        word.queryOrdered(byChild: "completed").observe(.value, with: { snapshot in
            var newItems: [Item] = []
            
            for item in snapshot.children {
                let item = Item(snapshot: item as! FIRDataSnapshot)
                newItems.append(item)
            }
            
            self.items = newItems
            self.tableView.reloadData()
        })
    }
    
    // MARK: UITableView Delegate methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.word
        cell.detailTextLabel?.text = item.meaning
        
        toggleCellCheckbox(cell, isCompleted: item.completed)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = items[indexPath.row]
            item.ref?.removeValue()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let item = items[indexPath.row]
        let toggledCompletion = !item.completed
        toggleCellCheckbox(cell, isCompleted: toggledCompletion)
        item.ref?.updateChildValues([
            "completed": toggledCompletion
            ])
    }
    
    func toggleCellCheckbox(_ cell: UITableViewCell, isCompleted: Bool) {
        if !isCompleted {
            cell.accessoryType = .none
            cell.textLabel?.textColor = UIColor.black
            cell.detailTextLabel?.textColor = UIColor.black
        } else {
            cell.accessoryType = .checkmark
            cell.textLabel?.textColor = UIColor.gray
            cell.detailTextLabel?.textColor = UIColor.gray
        }
    }
    
    // MARK: Add Item
    
    @IBAction func addButtonDidTouch(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Item",
                                      message: "Add a Slang",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { _ in
                                        
            let text = alert.textFields![0].text
            let meaningField = alert.textFields![1].text
                                        
            let item = Item(word: text!,
                            addedByUser: self.user.email,
                            meaning: meaningField!,
                            completed: false,
                            starCount: 0,
                            uid: self.user.uid)
            if alert.textFields?.first?.text != "" {
                let wordUi = UUID().uuidString
                let itemRef = self.word.child(wordUi)
                let userItem = self.userWord.child(self.user.uid + "/" + wordUi)
                itemRef.setValue(item.toAnyObject())
                userItem.setValue(item.toAnyObject())
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField{ word in
            word.placeholder = "Slang"
        }
        alert.addTextField { meaning in
            meaning.placeholder = "Enter the meaning"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func userCountButtonDidTouch() {
        performSegue(withIdentifier: listToUsers, sender: nil)
    }
    
}
