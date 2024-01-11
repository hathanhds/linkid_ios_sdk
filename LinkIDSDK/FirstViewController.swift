//
//  ViewController.swift
//  ios_proj
//
//  Created by ThanhNTH on 10/01/2024.
//

import UIKit

class FirstViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    

    @IBOutlet weak var clickButton: UIButton!
    
    @IBAction func onCickAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
        self.present(vc, animated: true, completion: nil);
    }
    
}

