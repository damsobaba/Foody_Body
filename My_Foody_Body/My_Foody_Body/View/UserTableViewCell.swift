//
//  UserTableViewCell.swift
//  My_Foody_Body
//
//  Created by Adam Mabrouki on 17/02/2021.
//
import UIKit
import Firebase

protocol UpdateTableProtocol {
    func reloadData()
}
class UserTableViewCell: UITableViewCell {

    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    
    var user: User!
  
    var inboxChangedProfileHandle: DatabaseHandle!
    var controller: PeopleTableViewController!
    var delegate: UpdateTableProtocol!
   
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatar.layer.cornerRadius = 30
        avatar.clipsToBounds = true
        
    }
    
    // load data from database 
    func loadData(_ user: User) {
        self.user = user
        self.usernameLbl.text = user.username
        self.statusLbl.text = user.status
        self.avatar.loadImage(user.profileImageUrl)
        
        let refUser = Reference().databaseSpecificUser(uid: user.uid)
        if inboxChangedProfileHandle != nil {
            refUser.removeObserver(withHandle: inboxChangedProfileHandle)
        }
        
        inboxChangedProfileHandle = refUser.observe(.childChanged, with: { (snapshot) in
            if let snap = snapshot.value as? String {
                self.user.updateData(key: snapshot.key, value: snap)
                self.delegate.reloadData()
            }
        })
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        
        let refUser = Reference().databaseSpecificUser(uid: self.user.uid)
        if inboxChangedProfileHandle != nil {
            refUser.removeObserver(withHandle: inboxChangedProfileHandle)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
