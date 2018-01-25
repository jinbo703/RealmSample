//
//  ViewController.swift
//  RealmSample
//
//  Created by John Nik on 11/15/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift

class ViewController: UITableViewController {

    let cellId = "cellId"
    
    var users: Results<User>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.title = "Realm Sample"
        navigationController?.navigationBar.prefersLargeTitles = true
        
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        fetchData()
    }

    func reloadData() {

//        users = uiRealm.objects(User.self)
        users = uiRealm.objects(User.self).sorted(byKeyPath: "age", ascending: true)
//        users = uiRealm.objects(User.self).filter("age == 1")
        
//        let name = "taewon"
//        users = uiRealm.objects(User.self).filter("name == %@", name)
        tableView.reloadData()
        
    }
    
    func fetchData() {
        
        let databaseRef = Database.database().reference()
        databaseRef.child("users").observe(.value, with: { (snapshot) in
            
            for snap in snapshot.children.allObjects as! [DataSnapshot] {
                
                guard let dictionary = snap.value as? [String: AnyObject] else { return }
                let name = dictionary["name"] as? String
                let age = dictionary["age"] as? Int
                
                let user = User()
                user.name = name
                user.age.value = age
                user.writeToRealm()
                
                
            }
            self.reloadData()
            
        }, withCancel: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if users == nil {
            return 0
        } else {
            return users.count
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        if let age = user.age.value {
            cell.detailTextLabel?.text = String(describing: age)
        }
        
        
        return cell
    }

}

