//
//  DetailViewController.swift
//  My_Foody_Body
//
//  Created by Adam Mabrouki on 19/02/2021.
//
import UIKit
import CoreLocation


class DetailViewController: UIViewController {

    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var genderImage: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var backBtn: UIButton!
   
    @IBOutlet weak var tableView: UITableView!
    

    var user: User!
    var isMatch = false
    
    override func viewDidLoad() {

        usernameLbl.text = user.username
        avatar.image = user.profileImage
      
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




extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            cell.imageView?.image = UIImage(named: "phone")
            cell.textLabel?.text = "123456789"
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
           


            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            cell.textLabel?.text = user.status
            cell.selectionStyle = .none

            return cell
        case 3:
            
            
            print("jdi")


        default:
            break
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3 {
            return 300
        }
        
        return 44
    }
    
    
}

