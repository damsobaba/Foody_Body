//
//  CardView.swift
//  My_Foody_Body
//
//  Created by Adam Mabrouki on 19/02/2021.


import Foundation
import UIKit
import CoreLocation
class CardView: UIView {
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var likeView: UIView!
    @IBOutlet weak var likeLbl: UILabel!
    @IBOutlet weak var nopeView: UIView!
    @IBOutlet weak var nopeLbl: UILabel!
    
    var controller: SwipeViewController!
    
    var user: User! {
        didSet {
            photo.loadImage(user.profileImageUrl) {
                (image) in
                self.user.profileImage = image
//            photo.image = UIImage(named: "taylor_swift")
            
                let attributedUsernameText = NSMutableAttributedString(string: "\(self.user.username)  ", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 30),
                                                                                                              NSAttributedString.Key.foregroundColor : UIColor.white                                                                     ])
            
            let attributedAgeText = NSMutableAttributedString(string: "", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 22),
                                                                                                   NSAttributedString.Key.foregroundColor : UIColor.white                                                                     ])
            attributedUsernameText.append(attributedAgeText)
            
        }
    }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        let frameGradient = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: bounds.height)
        
        photo.layer.cornerRadius = 10
        photo.clipsToBounds = true
        
    }
        
    @IBAction func infoBtnDidTap(_ sender: Any) {
       
    }
}

