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
                
                
                let attributedUsernameText = NSMutableAttributedString(string: "\(self.user.username)  ", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 30),
                                                                                                                       NSAttributedString.Key.foregroundColor : UIColor.white                                                                     ])
                
       
                self.usernameLbl.attributedText = attributedUsernameText
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        let frameGradient = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: bounds.height)
        photo.addBlackGradientLayer(frame: frameGradient, colors: [ UIColor.clear, UIColor.brown])
        
        photo.layer.cornerRadius = 10
        photo.clipsToBounds = true
        
        likeView.alpha = 0
        nopeView.alpha = 0
        
        likeView.layer.borderWidth = 3
        likeView.layer.cornerRadius = 5
        likeView.clipsToBounds = true
        likeView.layer.borderColor = UIColor(red: 0.101, green: 0.737, blue: 0.611, alpha: 1).cgColor
        
        nopeView.layer.borderWidth = 3
        nopeView.layer.cornerRadius = 5
        nopeView.clipsToBounds = true
        nopeView.layer.borderColor = UIColor(red: 0.9, green: 0.29, blue: 0.23, alpha: 1).cgColor

        likeView.transform = CGAffineTransform(rotationAngle: -.pi / 8)
        nopeView.transform = CGAffineTransform(rotationAngle: .pi / 8)
        
   
        nopeLbl.attributedText = NSAttributedString(string: "NOPE",attributes:[NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 30)])

        nopeView.layer.borderColor = UIColor(red: 0.9, green: 0.29, blue: 0.23, alpha: 1).cgColor
        nopeLbl.textColor = UIColor(red: 0.9, green: 0.29, blue: 0.23, alpha: 1)
        
        
        likeLbl.attributedText = NSAttributedString(string: "LIKE",attributes:[NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 30)])
        likeView.layer.borderColor = UIColor(red: 0.101, green: 0.737, blue: 0.611, alpha: 1).cgColor
        likeLbl.textColor = UIColor(red: 0.101, green: 0.737, blue: 0.611, alpha: 1)
    }
    
    @IBAction func infoBtnDidTap(_ sender: Any) {
        
    }
}

