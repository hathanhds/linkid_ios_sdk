//
//  Screen2ViewController.swift
//  AppTest
//
//  Created by ThanhNTH on 04/04/2024.
//

import UIKit

class Screen2ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

