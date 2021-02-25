//
//  DetailViewController.swift
//  My_Foody_Body
//
//  Created by Adam Mabrouki on 19/02/2021.
//
import UIKit
import CoreLocation


class DetailViewController: UIViewController {

    @IBOutlet var foodDescription1: UITextField!
    @IBOutlet weak var foodImage1: UIImageView!
    @IBOutlet weak var foodImage2: UIImageView!
    @IBOutlet weak var foddImage3: UIImageView!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var genderImage: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var backBtn: UIButton!
   
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var sendBtn: UIButton!
    var user: User!
    var isMatch = false
    
    override func viewDidLoad() {

        usernameLbl.text = user.username
        avatar.image = user.profileImage
        if user.age != nil {
            ageLbl.text = " \(user.age!)"
        } else {
            ageLbl.text = ""
        }
        
        statusLabel.text = user.status
        foodImage1.loadImage(user.foodImage)
        foodDescription1.text =  user.foodDescription
        
       
      
    }
    func setUpImageView() {
        
        avatar.clipsToBounds = true 
        foodImage1.layer.cornerRadius = 10
        
        foodImage1.clipsToBounds = true
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    
    @IBAction func backBtnDidTap(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
  
}


    
    


