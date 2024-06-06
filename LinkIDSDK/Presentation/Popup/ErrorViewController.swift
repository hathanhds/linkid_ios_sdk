//
//  ErrorViewController.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 19/03/2024.
//

import Foundation
import UIKit

class ErrorViewController: UIViewController {
    var viewModel: ErrorViewModel!
    var navigator: Navigator!

    @IBOutlet weak var bgView: UIView!

    class func create(with navigator: Navigator, viewModel: ErrorViewModel) -> ErrorViewController {
        let vc = UIStoryboard.popup.instantiateViewController(ofType: ErrorViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc
    }

    // Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.acceptAction))
        bgView.addGestureRecognizer(gesture)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.acceptButton.setCommonGradient()
    }

    @IBAction func acceptAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
