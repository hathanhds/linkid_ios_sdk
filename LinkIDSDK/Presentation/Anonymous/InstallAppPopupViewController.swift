//
//  InstallAppPopupViewController.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 25/03/2024.
//

import Foundation
import UIKit

class InstallAppPopupViewController: UIViewController {

    static func create(with navigator: Navigator, viewModel: InstallAppPopupViewModel) -> Self {
        let vc = UIStoryboard.anonymous.instantiateViewController(ofType: InstallAppPopupViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc as! Self
    }

    var viewModel: InstallAppPopupViewModel!
    var navigator: Navigator!

    // IBOutlets
    @IBOutlet weak var installAppButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        installAppButton.setGradient(colors: [.cFFD10F!, .cFE9E32!], direction: .right)
    }


    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true)
    }

}
