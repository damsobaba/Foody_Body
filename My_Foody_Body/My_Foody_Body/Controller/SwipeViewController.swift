//
//  SwipeViewController.swift
//  My_Foody_Body
//
//  Created by Adam Mabrouki on 18/02/2021.
//

  

    import UIKit
    import CoreLocation
    import FirebaseDatabase


   
class SwipeViewController:UIViewController   {
        @IBOutlet weak var cardStack: UIView!

       
        @IBOutlet weak var likeImg: UIImageView!
        @IBOutlet weak var boostImg: UIImageView!
    
    var users: [User] = []
    var cards: [CardView] = []
    var cardInitialLocationCenter: CGPoint!
    var panInitialLocation: CGPoint!
    
    
    
    func setupCard(user: User) {
        let card: CardView = UIView.fromNib()
      
        card.frame = CGRect(x: 0, y: 0, width: cardStack.bounds.width, height: cardStack.bounds.height)
        card.user = user
        card.controller = self
        cards.append(card)

        cardStack.addSubview(card)
        cardStack.sendSubviewToBack(card)
       
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        findUsers()
    }
    func findUsers() {
        
        Api.User.observeUsers { (user) in
            self.users.append(user)
            
            self.setupCard(user: user)

        }
}
}
extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}

