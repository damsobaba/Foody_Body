//
//  File.swift
//  My_Foody_Body
//
//  Created by Adam Mabrouki on 17/02/2021.
//

import Foundation
import UIKit

extension ChatViewController {
    
   

    
    func observeMessages() {
        Api.Message.receiveMessage(from: Api.User.currentUserId, to: partnerId) { (message) in
            self.messages.append(message)
            self.sortMessages()
        }
        Api.Message.receiveMessage(from: partnerId, to: Api.User.currentUserId) { (message) in
            self.messages.append(message)
            self.sortMessages()
        }
    }
    
    func sortMessages() {
        messages = messages.sorted(by: { $0.date < $1.date })
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func setupPicker() {
        picker.delegate = self
    }
    
    func setupTableView() {
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    
    func setupInputContainer() {
        setupInputTextView()
    }
    
    
    /// manualy changing the input of the text view
    func setupInputTextView() {
        
        inputTextView.delegate = self
        
        placeholderLbl.isHidden = false
        sendBtn.isEnabled = false
        sendBtn.setTitleColor(.lightGray, for: UIControl.State.normal)
        
        let placeholderX: CGFloat = self.view.frame.size.width / 75
        let placeholderY: CGFloat = 0
        let placeholderWidth: CGFloat = inputTextView.bounds.width - placeholderX
        
        let placeholderHeight: CGFloat = inputTextView.bounds.height
        
        let placeholderFontSize = self.view.frame.size.width / 25
        
        placeholderLbl.frame = CGRect(x: placeholderX, y: placeholderY, width: placeholderWidth, height: placeholderHeight)
        placeholderLbl.text = "Write a message"
        placeholderLbl.font = UIFont(name: "HelveticaNeue", size: placeholderFontSize)
        placeholderLbl.textColor = .lightGray
        placeholderLbl.textAlignment = .left
        
        inputTextView.addSubview(placeholderLbl)
        
    }

    
    /// navigation bar set up
    func setupNativationBar() {
        navigationItem.largeTitleDisplayMode = .never
        

        
        let containView = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 36));     avatarImageView.image = imagePartner
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.cornerRadius = 18
        avatarImageView.clipsToBounds = true
        containView.addSubview(avatarImageView)


        let rightBarButton = UIBarButtonItem(customView: containView)
        let detailButton = UIBarButtonItem(title: "Detail" , style: UIBarButtonItem.Style.plain, target: self, action: #selector(detailDidtaped))
        navigationItem.rightBarButtonItems = [detailButton, rightBarButton]
     
        
        
        topLabel.textAlignment = .center
        topLabel.numberOfLines = 0
        
        let attributed = NSMutableAttributedString(string: partnerUsername , attributes: [.font : UIFont.systemFont(ofSize: 17), .foregroundColor: UIColor.black])
        

        topLabel.attributedText = attributed
        self.navigationItem.titleView = topLabel
        
        
    }
 
    
/// call in selector to go to detail view controller
    @objc func detailDidtaped() {
   
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        detailVC.user = partnerUser
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
    

    
    ///send message info to firebase
    func sendToFirebase(dict: Dictionary<String, Any>) {
        let date: Double = Date().timeIntervalSince1970
        var value = dict
        value["from"] = Api.User.currentUserId
        value["to"] = partnerId
        value["date"] = date
        value["read"] = true
        Api.Message.sendMessage(from: Api.User.currentUserId, to: partnerId, value: value)
        
    }
    
}

/// hide the send button if no text imput
extension ChatViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let spacing = CharacterSet.whitespacesAndNewlines
        if !textView.text.trimmingCharacters(in: spacing).isEmpty {
            _ = textView.text.trimmingCharacters(in: spacing)
            sendBtn.isEnabled = true
            sendBtn.setTitleColor(.black, for: UIControl.State.normal)
            placeholderLbl.isHidden = true
        } else {
            sendBtn.isEnabled = false
            sendBtn.setTitleColor(.lightGray, for: UIControl.State.normal)
            placeholderLbl.isHidden = false
        }
        
    }
}

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            handleImageSelectedForInfo(info)
        }
    
    
    
    func handleImageSelectedForInfo(_ info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker: UIImage?
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImageFromPicker = imageSelected
        }
        
        if let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImageFromPicker = imageOriginal
        }
        
        // save photo data
        let imageName = NSUUID().uuidString
        StorageService.savePhotoMessage(image: selectedImageFromPicker, id: imageName) { [ unowned self ] (result) in
            switch result {
            case .success(let data):
                if let dict = data as? [String: Any] {
                    self.sendToFirebase(dict: dict)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            self.picker.dismiss(animated: true, completion: nil)
        }
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell") as! MessageTableViewCell

        cell.configureCell(uid: Api.User.currentUserId, message: messages[indexPath.row], image: imagePartner)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 0
        let message = messages[indexPath.row]
        let text = message.text
        if !text.isEmpty {
            height = text.estimateFrameForText(text).height + 60
        }
        
        let heightMessage = message.height
        let widthMessage = message.width
        if heightMessage != 0, widthMessage != 0 {
            height = CGFloat(heightMessage / widthMessage * 250)
        }
        return height
    }
    
}

