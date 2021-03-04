//
//  DetailViewController.swift
//  My_Foody_Body
//
//  Created by Adam Mabrouki on 19/02/2021.
//
import UIKit

import Firebase

class DetailViewController: UIViewController {

    @IBOutlet weak var foodDescription3Label: UILabel!
    @IBOutlet weak var foodDesciption2Label: UILabel!
    @IBOutlet weak var foodDescriptionLabel: UILabel!
    @IBOutlet weak var foodImage1: UIImageView!
    @IBOutlet weak var foodImage2: UIImageView!
    @IBOutlet weak var foddImage3: UIImageView!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var genderImage: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var backBtn: UIButton!
   
    @IBOutlet weak var statusLabel: UILabel!
    

var inboxChangedProfileHandle: DatabaseHandle!
    
    var controller: DetailViewController!
    
    
    var user: User!
    var isMatch = false
    
    override func viewDidLoad() {
        
        setUpImageView()
      
    }
    
   
    func loadData(_ user: User) {
        usernameLbl.text = user.username
        avatar.image = user.profileImage
        if user.age != nil {
            ageLbl.text = " \(user.age!)"
        } else {
            ageLbl.text = ""
        }
        
        if let isMale = user.isMale {
            let genderImgName = (isMale == true) ? "icon-male" : "icon-female"
            genderImage.image = UIImage(named: genderImgName)?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            
        } else {
            genderImage.image = UIImage(named: "icon-gender")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        }
        
        genderImage.tintColor = .white
        
        statusLabel.text = user.status
        foodImage1.loadImage(user.foodImage)
        foodImage2.loadImage(user.foodImage2)
        foddImage3.loadImage(user.foodImage3)
        foodDescriptionLabel.text = user.foodDescription
        foodDesciption2Label.text = user.foodDesciption2
        foodDescription3Label.text = user.foodDescription3
        
        
        
        
        
        
    }
    
    
    
    
    func setUpImageView() {
        
        avatar.clipsToBounds = true 
        foodImage1.layer.cornerRadius = 10
        [foodImage1,foodImage2,foddImage3].forEach { $0?.layer.cornerRadius = 10 }
        [foodImage1,foodImage2,foddImage3].forEach { $0?.clipsToBounds = true }
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        
        loadData(user)
        
        let refUser = Ref().databaseSpecificUser(uid: user.uid)
        if inboxChangedProfileHandle != nil {
            refUser.removeObserver(withHandle: inboxChangedProfileHandle)
        }
        inboxChangedProfileHandle = refUser.observe(.childChanged, with: { (snapshot) in
            if let snap = snapshot.value as? String {
                self.user.updateData(key: snapshot.key, value: snap)
                
            }
        })
      
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    
    @IBAction func backBtnDidTap(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
  
}


    
    


