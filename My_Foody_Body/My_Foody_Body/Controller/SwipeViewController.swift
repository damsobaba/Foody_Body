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
    @IBOutlet weak var nopeImg: UIImageView!
   
    var queryHandle: DatabaseHandle?
    var users: [User] = []
    var cards: [CardView] = []
    var cardInitialLocationCenter: CGPoint!
    var panInitialLocation: CGPoint!
    var distance: Double = 500
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
       
        nopeImg.isUserInteractionEnabled = true
        let tapNopeImg = UITapGestureRecognizer(target: self, action: #selector(nopeImgDidTap))
        nopeImg.addGestureRecognizer(tapNopeImg)
        
        likeImg.isUserInteractionEnabled = true
        let tapLikeImg = UITapGestureRecognizer(target: self, action: #selector(likeImgDidTap))
        likeImg.addGestureRecognizer(tapLikeImg)
        findUsers()

    }
    
  
    @objc func nopeImgDidTap() {
        guard let firstCard = cards.first else {
            return
        }
      saveToFirebase(like: false, card: firstCard)
        swipeAnimation(translation: 750, angle: -15)
        self.setupTransforms()
    }
    
    @objc func likeImgDidTap() {
        guard let firstCard = cards.first else {
            return
        }
       saveToFirebase(like: true, card: firstCard)
        swipeAnimation(translation: -750, angle: 15)
        self.setupTransforms()
    }
    
    
    func setupCard(user: User) {
        let card: CardView = UIView.fromNib()
        
        card.frame = CGRect(x: 0, y: 0, width: cardStack.bounds.width, height: cardStack.bounds.height)
        card.user = user
        card.controller = self
        cards.append(card)
        
        cardStack.addSubview(card)
        cardStack.sendSubviewToBack(card)
        setupTransforms()
        
        if cards.count == 1 {
            cardInitialLocationCenter = card.center
            card.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(pan(gesture:))))
        }
    }
    
    
    func findUsers() {
        Api.User.observeUsers { (user) in
            self.users.append(user)
            
            self.setupCard(user: user)
        }
    }
    
    func swipeAnimation(translation: CGFloat, angle: CGFloat) {
        let duration = 0.5
        let translationAnimation = CABasicAnimation(keyPath: "position.x")
        translationAnimation.toValue = translation
        translationAnimation.duration = duration
        translationAnimation.fillMode = .forwards
        translationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        translationAnimation.isRemovedOnCompletion = false
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = angle * CGFloat.pi / 180
        rotationAnimation.duration = duration
        guard let firstCard = cards.first else {
            return
        }
        for (index, c) in self.cards.enumerated() {
            if c.user.uid == firstCard.user.uid {
                self.cards.remove(at: index)
                self.users.remove(at: index)
            }
        }
        
        self.setupGestures()
        
        CATransaction.setCompletionBlock {
            firstCard.removeFromSuperview()
        }
        firstCard.layer.add(translationAnimation, forKey: "translation")
        firstCard.layer.add(rotationAnimation, forKey: "rotation")
        CATransaction.commit()
    }
    
    
    func setupGestures() {
        for card in cards {
            let gestures = card.gestureRecognizers ?? []
            for g in gestures {
                card.removeGestureRecognizer(g)
            }
        }
        
        if let firstCard = cards.first {
            firstCard.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(pan(gesture:))))
        }
    }

    @objc func pan(gesture: UIPanGestureRecognizer) {
        let card = gesture.view! as! CardView
        let translation = gesture.translation(in: cardStack)
        
        switch gesture.state {
        case .began:
            panInitialLocation = gesture.location(in: cardStack)
            print("began")
            print("panInitialLocation")
           

        case .changed:
            print("changed")
            print("x: \(translation.x)")
            print("y: \(translation.y)")

            card.center.x = cardInitialLocationCenter.x + translation.x
            card.center.y = cardInitialLocationCenter.y + translation.y
            
            if translation.x > 0 {
                // show like icon
                // 0<= alpha <=1
                card.likeView.alpha = abs(translation.x * 2) / cardStack.bounds.midX
                card.nopeView.alpha = 0
            } else {
                // show unlike icon
                card.nopeView.alpha = abs(translation.x * 2) / cardStack.bounds.midX
                card.likeView.alpha = 0
            }
            
            card.transform = self.transform(view: card, for: translation)

        case .ended:
            
            if translation.x > 75 {
                UIView.animate(withDuration: 0.3, animations: {
                    card.center = CGPoint(x: self.cardInitialLocationCenter.x + 1000, y: self.cardInitialLocationCenter.y + 1000)
                }) { (bool) in
                    // remove card
                    card.removeFromSuperview()
                }
               saveToFirebase(like: true, card: card)
                self.updateCards(card: card)

                return
            } else if translation.x < -75 {
                UIView.animate(withDuration: 0.3, animations: {
                    card.center = CGPoint(x: self.cardInitialLocationCenter.x - 1000, y: self.cardInitialLocationCenter.y + 1000)
                }) { (bool) in
                    // remove card
                    card.removeFromSuperview()
                }
                
               saveToFirebase(like: false, card: card)
                self.updateCards(card: card)
                
                return
            }
            
            
            UIView.animate(withDuration: 0.3) {
                card.center = self.cardInitialLocationCenter
                card.likeView.alpha = 0
                card.nopeView.alpha = 0
                card.transform = CGAffineTransform.identity
            }
        default:
            break
        }
    }
    
    
    func transform(view: UIView, for translation: CGPoint) -> CGAffineTransform {
        let moveBy = CGAffineTransform(translationX: translation.x, y: translation.y)
        let rotation = -translation.x / (view.frame.width / 2)
        return moveBy.rotated(by: rotation)
    }
    
    
    func updateCards(card: CardView) {
        for (index, c) in self.cards.enumerated() {
            if c.user.uid == card.user.uid {
                self.cards.remove(at: index)
                self.users.remove(at: index)
            }
        }
        
        setupGestures()
        setupTransforms()
    }
    
    func setupTransforms() {
        for (i, card) in cards.enumerated() {
            if i == 0 { continue; }
            
            if i > 3 { return }
            
            var transform = CGAffineTransform.identity
            if i % 2 == 0 {
                transform = transform.translatedBy(x: CGFloat(i)*4, y: 0)
                transform = transform.rotated(by: CGFloat(Double.pi)/150*CGFloat(i))
            } else {
                transform = transform.translatedBy(x: -CGFloat(i)*4, y: 0)
                transform = transform.rotated(by: -CGFloat(Double.pi)/150*CGFloat(i))
            }
            card.transform = transform
        }
    }
    
    func saveToFirebase(like: Bool, card: CardView) {
        Ref().databaseActionForUser(uid: Api.User.currentUserId)
            .updateChildValues([card.user.uid: like]) { (error, ref) in
                if error == nil, like == true {
            
                    self.checkIfMatchFor(card: card)
                }
        }
    }
    
    func checkIfMatchFor(card: CardView) {
        Ref().databaseActionForUser(uid: card.user.uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? [String: Bool] else { return }
            if dict.keys.contains(Api.User.currentUserId), dict[Api.User.currentUserId] == true {
            Ref().databaseRoot.child("newMatch").child(Api.User.currentUserId).updateChildValues([card.user.uid: true])
            Ref().databaseRoot.child("newMatch").child(card.user.uid).updateChildValues([Api.User.currentUserId: true])
                
                Api.User.getUserInforSingleEvent(uid: Api.User.currentUserId, onSuccess: { (user) in
                    self.presentAlert(title: "Notification", message: "you have a new match ! ")
                    
                })
            }
        }
    }

    
}

