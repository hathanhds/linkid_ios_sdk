//
//  RewardDetailViewController.swift
//  LinkIDApp
//
//  Created by Phan Tuan Anh on 17/04/2024.
//

import UIKit
import WebKit
//import iCarousel

class PhysicalRewardDetailViewController: BaseViewController {

    class func create(with navigator: Navigator, viewModel: PhysicalRewardDetailViewModel) -> Self {
        let vc = UIStoryboard.myReward.instantiateViewController(ofType: PhysicalRewardDetailViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc as! Self
    }

    @IBOutlet weak var _ticketView: UIView!
    @IBOutlet weak var _installAppView: UIView!

    @IBOutlet weak var presentTitleView: UIView!

//    @IBOutlet weak var carousel: iCarousel!
    @IBOutlet weak var indexCarouselLabel: UILabel!

    // Thông tin vận chuyển
    @IBOutlet weak var statusCollectionView: UICollectionView!
    @IBOutlet weak var cancelReasonContainerView: UIView!
    @IBOutlet weak var reasonLabel: UILabel!

    // Mô tả chung
    @IBOutlet weak var giftInfoContainerView: UIView!
    @IBOutlet weak var descriptionStackView: UIStackView!
    @IBOutlet weak var descriptionWebView: WKWebView!
    @IBOutlet weak var webviewHeightConstraint: NSLayoutConstraint!

    //Hướng dẫn
    @IBOutlet weak var instructionContainerView: UIStackView!
    @IBOutlet weak var instructionLabel: UILabel!
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


    var viewModel: PhysicalRewardDetailViewModel!
    let headString = "<head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></head>"
    private var isInjected: Bool = false

    let progressIndex = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.input.viewDidLoad.onNext(())
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavigationBar()
        locationTableView.addObserver(self, forKeyPath: "contentSize",
            options: .new, context: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.showNavigationBar()
        locationTableView.removeObserver(self, forKeyPath: "contentSize")
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard
        keyPath == "contentSize",
            let newValue = change?[.newKey] as? CGSize,
            let object = object
            else {
            return
        }
        if object is UITableView {
            let height = newValue.height
            self.locationTableViewHeightConstraint.constant = height
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.async { [weak self] in
            self?._ticketView.drawTicket(
                directionHorizontal: false,
                withCutoutRadius: 10,
                andCornerRadius: 12,
                fillColor: UIColor.white,
                andFrame: CGRect(x: 0, y: 0, width: self!._ticketView.frame.size.width, height: self!._ticketView.frame.size.height),
                andTicketPosition: CGPoint(x: self!._ticketView.frame.size.width, y: 250))
        }
    }

    override func initView() {
        descriptionWebView.navigationDelegate = self
        let content = """
                        <!DOCTYPE html>
                        <html>
                        <body>
                        <p>Older versions of Swift don't allow you to have a single literal over multiple lines but you can add literals together over multiple lines:</p>
                        <p>My first paragraph.</p>
                        <p>My first paragraph.</p>
                        <p>My first paragraph.</p></body></html>
                        """
        descriptionWebView.loadHTMLString(content, baseURL: nil)
        locationTableView.register(cellType: GiftLocationTableViewCell.self)
//        setUpCarousel()
    }

//    func setUpCarousel() {
//        carousel.type = .linear
//        carousel.layer.masksToBounds = false
//        carousel.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
//        carousel.layer.cornerRadius = 12.0
//        carousel.scrollToItem(at: 0, animated: true)
//        carousel.isPagingEnabled = true
//        // Auto scroll
//        _ = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.handleTimer), userInfo: nil, repeats: true)
//        indexCarouselLabel.text = "1/5"
//
//        carousel.reloadData()
//    }

//    @objc func handleTimer() {
//        var newIndex = carousel.currentItemIndex + 1
//        if newIndex > carousel.numberOfItems {
//            newIndex = 0
//        }
//        carousel.scrollToItem(at: newIndex, duration: 0.5)
//    }

    override func bindToView() {
        // Reward info
//        viewModel.output.rewardInfo.subscribe(onNext: { [weak self] rewardInfo in
//            guard let self = self else { return }
//            if let giftTransaction = rewardInfo?.giftTransaction {
//                // Giới thiệu
//                if let description = giftTransaction.description, !description.isEmpty {
//                    descriptionStackView.isHidden = false
//
//                } else {
//                    descriptionStackView.isHidden = true
//                }
//
//                // Hướng dẫn sử dụng
//                if let instruction = giftTransaction.introduce, !instruction.isEmpty {
//                    instructionContainerView.isHidden = false
//                } else {
//                    instructionContainerView.isHidden = true
//                }
//
//                // Liên hệ
//                if (!(giftTransaction.contactHotline ?? "").isEmpty || !(giftTransaction.contactEmail ?? "").isEmpty) {
//                    contactContainerView.isHidden = false
//                    if let email = giftTransaction.contactEmail, !email.isEmpty {
//                        emailContainerView.isHidden = false
//                        emailButton.setTitle(email, for: .normal)
//                    } else {
//                        emailContainerView.isHidden = true
//                    }
//                    if let hotline = giftTransaction.contactHotline, !hotline.isEmpty {
//                        hotlineContainerView.isHidden = false
//                        hotlineButton.setTitle(hotline, for: .normal)
//                    } else {
//                        hotlineContainerView.isHidden = true
//                    }
//                } else {
//                    contactContainerView.isHidden = true
//                }
//                // Điều kiện áp dụng
//                if let condition = giftTransaction.condition {
//                    conditionContainerView.isHidden = false
//                    conditionLabel.text = condition
//                } else {
//                    conditionContainerView.isHidden = true
//                }
//                // Địa điểm áp dụng
//            } else {
//                giftInfoContainerView.isHidden = true
//                contactContainerView.isHidden = true
//                contactContainerView.isHidden = true
//                conditionContainerView.isHidden = true
//                locationContainerView.isHidden = true
//            }
//        }).disposed(by: disposeBag)

        viewModel.output.listProgress.subscribe(onNext: { [weak self] listProgress in
            guard let self = self else { return }
            statusCollectionView.reloadData()
        }).disposed(by: disposeBag)

    }

// MARK: -Actions
    @IBAction func onBackPressed(_ sender: Any) {
        self.pop()
    }

    @IBAction func openEmailAction(_ sender: Any) {
        if let email = viewModel.output.rewardInfo.value?.giftTransaction?.contactEmail {
            UtilHelper.openEmail(email: email)
        }
    }

    @IBAction func callHotlineAction(_ sender: Any) {
        if let phone = viewModel.output.rewardInfo.value?.giftTransaction?.contactHotline {
            UtilHelper.openPhoneCall(number: phone)
        }
    }

    @IBAction func seeMoreLocationAction(_ sender: Any) {
        self.navigator.show(segue: .giftLocation) { [weak self] vc in
            guard let self = self else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }


}

extension PhysicalRewardDetailViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if isInjected == true {
            return
        }
        self.isInjected = true
        // get HTML text
        let js = "document.body.outerHTML"
        webView.evaluateJavaScript(js) { (html, error) in
            webView.loadHTMLStringWith(content: html as! String, baseURL: nil)
        }
        webView.frame.size.height = 1
        webView.frame.size = webView.sizeThatFits(.zero)
        webView.scrollView.isScrollEnabled = false;
        webView.evaluateJavaScript("document.documentElement.scrollHeight") { [weak self] (height, error) in
            guard let height = height as? CGFloat, let self = self else { return }
            webviewHeightConstraint.constant = height
            self.view.updateConstraints()
            self.view.updateConstraintsIfNeeded()

        }
    }
}

extension PhysicalRewardDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = locationTableView.dequeueCell(ofType: GiftLocationTableViewCell.self, for: indexPath)
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

extension PhysicalRewardDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.output.listProgress.value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ofType: PhysicalRewardStatusCollectionViewCell.self, for: indexPath)
        let list = viewModel.output.listProgress.value
        let index = indexPath.row
        cell.setCellForData(isFistItem: index == 0, isLastItem: index == list.count - 1, data: list[index], index: index)
        return cell
    }

    // MARK: - Flow layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let count = CGFloat(viewModel.output.listProgress.value.count)
        let width = collectionView.frame.width / count
        return CGSize(width: width, height: 100.0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}


//extension PhysicalRewardDetailViewController: iCarouselDataSource, iCarouselDelegate {
//
//    // MARK: - iCarousel Datasource
//
//    func numberOfItems(in carousel: iCarousel) -> Int {
////        return self.viewModel.output.banners.value.count
//        return 5
//    }
//
//    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
//        let imageView: UIImageView
//
//        if view != nil {
//            imageView = view as! UIImageView
//        } else {
//            imageView = UIImageView(frame: self.carousel.frame)
//        }
////        let banners = self.viewModel.output.banners.value
//
////        imageView.setSDImage(with: banners[index].article?.linkAvatar)
//        imageView.setSDImage(with: "https://picsum.photos/seed/picsum/200/300")
//        imageView.layer.cornerRadius = 12.0
//        imageView.layer.masksToBounds = true
//
//        return imageView
//    }
//
//    // MARK: - iCarousel Delegate
//
//
//    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
//        switch (option) {
//        case .spacing:
//            return value * 1.05
//        case .visibleItems:
//            return 3.0
//        case .wrap:
//            return 1
//        default:
//            return value
//        }
//    }
//
//    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
//        // TODO: - hanlde open news detail
//    }
//
//    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
////        self.viewModel.output.currentBannerPageControlIndex.accept(carousel.currentItemIndex)
//        self.indexCarouselLabel.text = "\(carousel.currentItemIndex + 1)/5"
//    }
//}
