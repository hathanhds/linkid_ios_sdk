//
//  GiftLocationViewController.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 23/05/2024.
//

import UIKit

class GiftLocationViewController: BaseViewController, ViewControllerType {

    static func create(with navigator: Navigator, viewModel: GiftLocationViewModel) -> Self {
        let vc = UIStoryboard.gifts.instantiateViewController(ofType: GiftLocationViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc as! Self
    }

    // Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTF: UITextField!

    // Variables
    var viewModel: GiftLocationViewModel!
    @IBOutlet weak var searchImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func initView() {
        self.title = "Địa điểm áp dụng"
        self.addBackButton()
        searchImageView.setImageColor(color: UIColor.cD8D6DD!)
        tableView.register(cellType: GiftLocationTableViewCell.self)
    }

}

extension GiftLocationViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(ofType: GiftLocationTableViewCell.self, for: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigator.show(segue: .popup(
            dismissable: true,
            type: .twoOption,
            title: "Truy cập Google Map",
            message: "Coppy địa chỉ thành công. Bạn có muốn mở ứng dụng Google Maps để xem địa chỉ không?",
            image: .imgGiftMap!,
            confirmnButton: (title: "Đống ý", action: {
                print("Open google map");
            }),
            cancelButton: (title: "Huỷ", action: nil)
            )) { [weak self] vc in
            guard let self = self else { return }
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.navigationController?.present(vc, animated: true)
        }
    }

}
