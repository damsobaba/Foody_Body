//
//  PeopleTableViewController.swift
//  My_Foody_Body
//
//  Created by Adam Mabrouki on 17/02/2021.
//

import UIKit

class PeopleTableViewController: UITableViewController {

    var users: [User] = []
    var searchController: UISearchController = UISearchController(searchResultsController: nil)
    var searchResults: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        setupNavigationBar()
        observeUsers()
        setupTableView()
    }
    
    func setupTableView() {
        tableView.tableFooterView = UIView()
    }
    
    
   
    
    
    func setupNavigationBar() {
        navigationItem.title = "People"
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    func observeUsers() {
        Api.User.observeUsers { (user) in
            self.users.append(user)
            self.tableView.reloadData()
        }
    }
    
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! UserTableViewCell
        let user = users[indexPath.row]
        cell.loadData(user)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? UserTableViewCell {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let chatVC = storyboard.instantiateViewController(withIdentifier: IDENTIFIER_CHAT) as! ChatViewController
            chatVC.imagePartner = cell.avatar.image
            chatVC.partnerUsername = cell.usernameLbl.text
            chatVC.partnerId = cell.user.uid
            self.navigationController?.pushViewController(chatVC, animated: true)
            
            // utiliser la methode du P10
            
        }

}
    
}
