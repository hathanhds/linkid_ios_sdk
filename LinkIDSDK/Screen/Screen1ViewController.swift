//
//  Screen1ViewController.swift
//  AppTest
//
//  Created by ThanhNTH on 04/04/2024.
//

import UIKit
/*@_implementationOnly*/ import SVProgressHUD


class Screen1ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func clickAction(_ sender: Any) {
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Custom", bundle: Bundle(for: Screen2ViewController.self))
//        let vc = storyBoard.instantiateViewController(withIdentifier: "\(Screen2ViewController.self)")
//        self.navigationController?.pushViewController(vc, animated: true)
        //
        showLoading()

    }

}

extension UIViewController {

    func showLoading() {
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setDefaultMaskType(.custom)
//        SVProgressHUD.setForegroundColor(.mainColor!)
        SVProgressHUD.setBackgroundColor(.clear)
        SVProgressHUD.setBackgroundLayerColor(.clear)
        SVProgressHUD.setRingThickness(4)
        SVProgressHUD.setCornerRadius(26)
        SVProgressHUD.show()
        self.view.endEditing(true)
    }

    func hideLoading() {
        SVProgressHUD.dismiss()
    }
}

