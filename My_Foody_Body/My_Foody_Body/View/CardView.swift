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
                self.usernameLbl.text = self.user.username
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
        likeView.layer.borderColor = UIColor.brown.cgColor
        
        nopeView.layer.borderWidth = 3
        nopeView.layer.cornerRadius = 5
        nopeView.clipsToBounds = true
        nopeView.layer.borderColor = UIColor.brown.cgColor

        likeView.transform = CGAffineTransform(rotationAngle: -.pi / 8)
        nopeView.transform = CGAffineTransform(rotationAngle: .pi / 8)
        
   
        nopeLbl.attributedText = NSAttributedString(string: "NOPE",attributes:[NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 30)])

        nopeView.layer.borderColor = UIColor.brown.cgColor
        nopeLbl.textColor = UIColor.brown
        
        
        likeLbl.attributedText = NSAttributedString(string: "LIKE",attributes:[NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 30)])
        likeView.layer.borderColor = UIColor.brown.cgColor
        likeLbl.textColor =  UIColor.brown
    }
    
    @IBAction func infoBtnDidTap(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        detailVC.user = user
        self.controller.navigationController?.pushViewController(detailVC, animated: true)    }
}

