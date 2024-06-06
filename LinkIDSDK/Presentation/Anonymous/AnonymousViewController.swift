//
//  Anonymous.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 25/03/2024.
//

import Foundation
import UIKit


class AnonymousViewController: BaseViewController, ViewControllerType {

    typealias ViewModel = AnonymousViewModel

    static func create(with navigator: Navigator, viewModel: AnonymousViewModel) -> Self {
        let vc = UIStoryboard.anonymous.instantiateViewController(ofType: AnonymousViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc as! Self
    }

    var viewModel: AnonymousViewModel!

    // IBOutlet
    @IBOutlet weak var installAppButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func initView() {
        installAppButton.setCommonGradient()
    }
}
