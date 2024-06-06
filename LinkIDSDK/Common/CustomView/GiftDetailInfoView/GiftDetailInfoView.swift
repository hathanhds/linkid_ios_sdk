//
//  GiftDetailInfoView.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 27/05/2024.
//

import Foundation
import UIKit
import WebKit

public class GiftDetailInfoView: UIView, NibLoadable, UITableViewDelegate, UITableViewDataSource {

    // Outlets
    // Mô tả chung
    @IBOutlet weak var giftInfoContainerView: UIView!
    @IBOutlet weak var descriptionStackView: UIStackView!
    @IBOutlet weak var descriptionWebView: WKWebView!
    @IBOutlet weak var webviewHeightConstraint: NSLayoutConstraint!

    //Hướng dẫn
    @IBOutlet weak var instructionContainerStackView: UIStackView!
    @IBOutlet weak var instructionTitleLabel: UILabel!
    @IBOutlet weak var instructionCotentLabel: UILabel!
    // Liên hệ
    @IBOutlet weak var contactContainerView: UIStackView!
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var hotlineContainerView: UIView!
    @IBOutlet weak var hotlineButton: UIButton!
    // Điều kiện sử dụng
    @IBOutlet weak var conditionContainerView: UIView!
    @IBOutlet weak var conditionLabel: UILabel!
    // Địa điểm áp dụng
    @IBOutlet weak var locationContainerView: UIView!
    @IBOutlet weak var locationTableView: UITableView!
    @IBOutlet weak var loadMoreLocationButton: UIButton!
    @IBOutlet weak var locationTableViewHeightConstraint: NSLayoutConstraint!

    // Variables
    var navigator: Navigator!
    var parentController: UIViewController!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupFromNib()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }

    convenience init(navigator: Navigator, parentController: UIViewController) {
        self.init(frame: .zero)
        self.navigator = navigator
        self.parentController = parentController
    }


    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.locationTableView.dequeueCell(ofType: GiftLocationTableViewCell.self, for: indexPath)

        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
            self.parentController.navigationController?.present(vc, animated: true)
        }
    }
}
