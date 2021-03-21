//
//  ChatViewController.swift
//  My_Foody_Body
//
//  Created by Adam Mabrouki on 17/02/2021.
//

import UIKit
import MobileCoreServices
import AVFoundation


class ChatViewController: UIViewController {
    
    let authService: AuthService = AuthService()

    
    @IBOutlet weak var mediaButton: UIButton!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var imagePartner: UIImage!
    var detailImageView:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
    var avatarImageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
    var topLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
    var partnerUsername: String!
    var partnerId: String!
    var placeholderLbl = UILabel()
    var picker = UIImagePickerController()
    var messages = [Message]()
    var partnerUser: User? {
        didSet {
            avatarImageView.loadImage(partnerUser?.profileImageUrl) {
                (image) in
                self.partnerUser?.profileImage = image


            }
        }
    }
    
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        inputTextView.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPicker()
        setupInputContainer()
        
        setupNativationBar()
        setupTableView()
        observeMessages()
    }
    
  
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func sendBtnDidTapped(_ sender: Any) {
        if let text = inputTextView.text, text != "" {
            inputTextView.text = ""
            self.textViewDidChange(inputTextView)
            sendToFirebase(dict: ["text": text as Any])
        }
    }
    
    @IBAction func mediaBtnDidTapped(_ sender: Any) {
        let alert = UIAlertController(title: "My_Foody_Body", message: "Select source", preferredStyle: UIAlertController.Style.actionSheet)

        
        let library = UIAlertAction(title: "Choose an Image ", style: UIAlertAction.Style.default) { (_) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                self.picker.sourceType = .photoLibrary
                self.picker.mediaTypes = [String(kUTTypeImage), String(kUTTypeMovie)]
                
                self.present(self.picker, animated: true, completion: nil)
            } else {
                print("Unavailable")
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)

        alert.addAction(cancel)

        alert.addAction(library)
        
        present(alert, animated: true, completion: nil)
        
    
    }
    
}

