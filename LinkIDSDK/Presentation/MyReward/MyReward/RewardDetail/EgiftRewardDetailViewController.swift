//
//  RewardDetailViewController.swift
//  LinkIDApp
//
//  Created by Phan Tuan Anh on 17/04/2024.
//

import UIKit
import WebKit
import EasyTipView

class EgiftRewardDetailViewController: BaseViewController {

    class func create(with navigator: Navigator, viewModel: EgiftRewardDetailViewModel) -> Self {
        let vc = UIStoryboard.myReward.instantiateViewController(ofType: EgiftRewardDetailViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc as! Self
    }

    @IBOutlet weak var _ticketView: UIView!
    @IBOutlet weak var _installAppView: UIView!

    @IBOutlet weak var egiftCodeContainerView: UIView!
    @IBOutlet weak var egiftCodeContainerViewHeightConstant: NSLayoutConstraint!

    @IBOutlet weak var presentTitleView: UIView!
    @IBOutlet weak var expiredDateInfoButton: UIButton!

    // ExtraView
    @IBOutlet var hiddenEgiftView: UIView!
    @IBOutlet var egiftCodeView: UIView!
    @IBOutlet weak var sendGiftButton: UIButton!
    @IBOutlet weak var useButton: UIButton!

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


    var viewModel: EgiftRewardDetailViewModel!
    let headString = "<head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></head>"
    private var isInjected: Bool = false
    var tipView: EasyTipView!
    var counter = 0
    var timer = Timer()

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
                andTicketPosition: CGPoint(x: self!._ticketView.frame.size.width, y: 180))
        }

        useButton.setCommonGradient()
        presentTitleView.setCommonGradient()

        egiftContainerSubAddView(view: egiftCodeView)
    }

    func egiftContainerSubAddView(view: UIView) {
        egiftCodeContainerView.addSubview(view)
        view.center = CGPoint(x: egiftCodeView.bounds.midX, y: egiftCodeView.bounds.midY)
        egiftCodeContainerViewHeightConstant.constant = view.frame.height
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

        presentTitleView.layer.masksToBounds = false
        presentTitleView.layer.cornerRadius = 12
        presentTitleView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner]

        setUpEasyView()
    }

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

    }

// MARK: -Actions
    @IBAction func onBackPressed(_ sender: Any) {
        self.pop()
    }

    @IBAction func sendGiftAction(_ sender: Any) {
        self.navigator.show(segue: .installAppPopup) { [weak self] vc in
            guard let self = self else { return }
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }

    @IBAction func useGiftAction(_ sender: Any) {
        navigator.show(segue: .markUsed(didFinish: {
            // TODO: call api Đã sử dụng
            print("Trượt đã sử dụng và reload data")
        })) { [weak self] vc in
            guard let self = self else { return }
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.navigationController?.present(vc, animated: true)
        }
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

    @IBAction func showInfoExpiredDateAction(_ sender: Any) {
        if let tipView = self.view.subviews.first(where: { $0 is EasyTipView }) as? EasyTipView {
            tipView.dismiss()
        } else {
            startTimmer()
            tipView.show(forView: self.expiredDateInfoButton, withinSuperview: self.view)
        }
    }

    @IBAction func copyGiftCodeAction(_ sender: Any) {
//        self.showToast(fromView: self._ticketView, type: .success, message: "Sao chép thành công")
        self.showToast(ofType: .success, withMessage: "Sao chép thành công Sao chép thành côngSao chép thành côngSao chép thành côngSao chép thành công Sao chép thành côngSao chép thành công")
    }

    @IBAction func copySerialAction(_ sender: Any) {

    }
}

extension EgiftRewardDetailViewController: WKNavigationDelegate {

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

extension EgiftRewardDetailViewController: UITableViewDelegate, UITableViewDataSource {
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

extension EgiftRewardDetailViewController {

    func setUpEasyView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.dimissTipView))
        self.view.addGestureRecognizer(gesture)

        var preferences = EasyTipView.Preferences()
        preferences.drawing.font = .systemFont(ofSize: 14)
        preferences.drawing.foregroundColor = .white
        preferences.drawing.backgroundColor = .c242424!
        preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.bottom
        tipView = EasyTipView(text: "Ưu đãi có giá trị sử dụng đến 23:59 căn cứ theo giờ Việt Nam (GMT+7) và theo hệ thống LYNKID.", preferences: preferences)
    }

    @objc func dimissTipView(sender: UITapGestureRecognizer) {
        tipView.dismiss()
    }


    func startTimmer() {
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timmerAction), userInfo: nil, repeats: true)
    }

    func stopTimmer() {
        counter = 0
        tipView.dismiss()
        timer.invalidate()
    }

    @objc func timmerAction() {
        if (counter > 3) {
            stopTimmer()
            return
        }
        counter += 1
    }
}
