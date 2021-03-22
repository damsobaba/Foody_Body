//
//  ViewController.swift
//  My_Foody_Body
//
//  Created by Adam Mabrouki on 11/02/2021.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var createAccountButton: UIButton!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
       changeButtonsAspect()
    }

    private func changeButtonsAspect(){
        createAccountButton.layer.cornerRadius = 6
    }
    
    
}



