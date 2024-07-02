//
//  RewardDetailViewController.swift
//  LinkIDApp
//
//  Created by Phan Tuan Anh on 17/04/2024.
//

import UIKit
import WebKit
import EasyTipView
import SwiftyAttributes

class EgiftRewardDetailViewController: BaseViewController {

    class func create(with navigator: Navigator, viewModel: EgiftRewardDetailViewModel) -> Self {
        let vc = UIStoryboard.myReward.instantiateViewController(ofType: EgiftRewardDetailViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc as! Self
    }

    @IBOutlet weak var _ticketView: UIView!
    @IBOutlet weak var _installAppView: UIView!
    @IBOutlet weak var stackContainerView: UIStackView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var egiftCodeContainerView: UIView!
    @IBOutlet weak var brandImageView: UIImageView!

    // Redeem Egift View

    @IBOutlet weak var redeemStackView: UIStackView!
    @IBOutlet weak var redeemCodeLabel: UILabel!
    @IBOutlet weak var redeemSerialLabel: UILabel!
    @IBOutlet weak var memberNameFromLabel: UILabel!
    @IBOutlet weak var sendGiftButton: UIButton!
    @IBOutlet weak var useButton: UIButton!
    @IBOutlet weak var redeemSerialStackView: UIStackView!

    // Used Egift
    @IBOutlet weak var usedStackView: UIStackView!
    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var usedCodeLabel: UILabel!
    @IBOutlet weak var effectiveDateLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var usedSerialLabel: UILabel!
    @IBOutlet weak var qrCodeContainerView: UIView!
    @IBOutlet weak var usedCodeContainerView: UIView!
    @IBOutlet weak var usedSerialContainerView: UIView!
    @IBOutlet weak var reorderButton: UIButton!

    // Header info
    @IBOutlet weak var presentTitleView: UIView!
    @IBOutlet weak var expiredDateInfoButton: UIButton!
    @IBOutlet weak var giftNameLabel: UILabel!
    @IBOutlet weak var expiredDateLabel: UILabel!
    // Mô tả chung
    @IBOutlet weak var giftInfoContainerView: UIView!
    @IBOutlet weak var descriptionStackView: UIStackView!
    @IBOutlet weak var descriptionWebViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionWebView: WKWebView!

    //Hướng dẫn
    @IBOutlet weak var instructionContainerView: UIStackView!
    @IBOutlet weak var instructionWebView: WKWebView!
    @IBOutlet weak var instructionWebViewHeightConstraint: NSLayoutConstraint!

    // Liên hệ
    @IBOutlet weak var contactContainerView: UIStackView!
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var hotlineContainerView: UIView!
    @IBOutlet weak var hotlineButton: UIButton!
    // Điều kiện sử dụng
    @IBOutlet weak var conditionContainerView: UIView!
    @IBOutlet weak var conditionWebView: WKWebView!
    @IBOutlet weak var conditionWebViewHeightConstraint: NSLayoutConstraint!

    // Địa điểm áp dụng
    @IBOutlet weak var locationContainerView: UIView!
    @IBOutlet weak var locationTableView: UITableView!
    @IBOutlet weak var loadMoreLocationButton: UIButton!
    @IBOutlet weak var locationTableViewHeightConstraint: NSLayoutConstraint!


    var viewModel: EgiftRewardDetailViewModel!

    private var isInjectedDescriptionWebView: Bool = false
    private var isInjectedInstructionWebView: Bool = false
    private var isInjectedConditionWebView: Bool = false

    var tipView = EasyTipView(text: "")
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
            guard let self = self else { return }
            _ticketView.drawTicket(
                directionHorizontal: false,
                withCutoutRadius: 10,
                andCornerRadius: 12,
                fillColor: UIColor.white,
                andFrame: CGRect(x: 0, y: 0, width: _ticketView.frame.size.height, height: _ticketView.frame.size.height),
                andTicketPosition: CGPoint(x: _ticketView.frame.size.width, y: viewModel.caculateTicketPosition()))
        }

        useButton.setCommonGradient()
        headerView.setCommonGradient()

        // Label quà tặng
        presentTitleView.layer.masksToBounds = true
        presentTitleView.layer.cornerRadius = 12
        presentTitleView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner]
        presentTitleView.setCommonGradient()
    }

    override func initView() {
        descriptionWebView.navigationDelegate = self
        instructionWebView.navigationDelegate = self
        conditionWebView.navigationDelegate = self
        locationTableView.register(cellType: GiftLocationTableViewCell.self)
        self.setUpEasyView(tipView: &tipView)
    }

    override func bindToView() {
        viewModel.output.isLoading.subscribe { [weak self] isLoading in
            guard let self = self else { return }
            if (isLoading) {
                self.stackContainerView.isHidden = true
                self.showLoading()
            } else {
                self.stackContainerView.isHidden = false
                self.hideLoading()
            }
        }.disposed(by: disposeBag)

        // Reward info
        viewModel.output.giftInfo.subscribe(onNext: { [weak self] giftInfo in
            guard let self = self else { return }
            // Ảnh quà
            let brandImage = giftInfo?.brandInfo?.brandImage
            brandImageView.setSDImage(with: brandImage, placeholderImage: .imageLogo)
            if let giftTransaction = giftInfo?.giftTransaction {
                self.scrollView.isHidden = false
                setUpEGiftCodeView(giftInfo: giftInfo)
                // Header info
                giftNameLabel.text = giftTransaction.giftName
                let dateInfo = viewModel.displaydDateInfo(giftInfo: giftInfo)
                expiredDateLabel.text = dateInfo.title
                expiredDateLabel.textColor = dateInfo.color
                presentTitleView.isHidden = giftTransaction.whyHaveIt != WhyHaveRewardType.received.rawValue

                // Thông tin chung
                setUpGeneralInfo(giftTransaction)

                // Địa điểm áp dụng
                if let giftUsageAddress = giftInfo?.giftUsageAddress, giftUsageAddress.count > 0 {
                    locationContainerView.isHidden = false
                    loadMoreLocationButton.isHidden = giftUsageAddress.count < 3
                } else {
                    loadMoreLocationButton.isHidden = true
                    locationContainerView.isHidden = true
                }
                locationTableView.reloadData()
            } else {
                self.scrollView.isHidden = true
            }
        }).disposed(by: disposeBag)

        // Update gift status
        viewModel.output.updateGiftStatusResult.subscribe { [weak self] result in
            guard let self = self else { return }
        }.disposed(by: disposeBag)
        viewModel.output.updateGiftStatusResult.subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                // Do nothing
                break
            case .failure(let res):
                UtilHelper.showAPIErrorPopUp(navigator: navigator,
                    parentVC: self,
                    message: res.message ?? "")
            }
        }).disposed(by: disposeBag)
    }


    func setUpEGiftCodeView(giftInfo: GiftInfoItem?) {
        if let usedStatus = giftInfo?.eGift?.usedStatus, let whyHaveIt = giftInfo?.giftTransaction?.whyHaveIt {
            // Check show egit code view
            // Redeem egift
            if usedStatus == EgiftRewardStatus.redeemed.rawValue && whyHaveIt != WhyHaveRewardType.sent.rawValue {
                setUpRedeemEgiftInfo(giftInfo: giftInfo)
                redeemStackView.isHidden = false
                usedStackView.isHidden = true
            } else {
                // Used egift
                setUpUsedEgiftInfo(giftInfo: giftInfo)
                redeemStackView.isHidden = true
                usedStackView.isHidden = false
            }
        }
    }

    func setUpRedeemEgiftInfo(giftInfo: GiftInfoItem?) {
        let giftTransaction = giftInfo?.giftTransaction
        let code = giftInfo?.eGift?.code
        let serialNo = giftTransaction?.serialNo
        if let code = code, !code.isEmpty, viewModel.isShowMarkUsedButton() {
            redeemCodeLabel.text = code.replacingLastCharacters(with: "XXXX", numberOfReplacedCharacters: 4).uppercased()
            redeemCodeLabel.isHidden = false
        } else {
            redeemCodeLabel.isHidden = true
        }
        if let serialNo = serialNo, !serialNo.isEmpty, viewModel.isShowMarkUsedButton() {
            redeemSerialLabel.text = serialNo.replacingLastCharacters(with: "XXXX", numberOfReplacedCharacters: 4).uppercased()
            redeemSerialStackView.isHidden = false
        } else {
            redeemSerialStackView.isHidden = true
        }

        // Check show hide Send/Use button
        if let whyHaveIt = giftInfo?.giftTransaction?.whyHaveIt {
            sendGiftButton.isHidden = whyHaveIt != WhyHaveRewardType.bought.rawValue
        }
        useButton.isHidden = !viewModel.isShowMarkUsedButton()
    }

    func setUpUsedEgiftInfo(giftInfo: GiftInfoItem?) {
        let giftTransaction = giftInfo?.giftTransaction
        let whyHaveIt = giftTransaction?.whyHaveIt
        let eGift = giftInfo?.eGift
        brandImageView.image = brandImageView.image?.applyColorFilter()
        // Gift code
        if let code = eGift?.code, !code.isEmpty {
            usedCodeLabel.text = code.uppercased()
            usedCodeContainerView.isHidden = false
        } else {
            usedCodeContainerView.isHidden = true
        }
        // Code image
        if let codeImage = giftTransaction?.qrCode {
            qrCodeContainerView.isHidden = false
            qrCodeImageView.setSDImage(with: codeImage)
        } else {
            if let code = eGift?.code, !code.isEmpty {
                qrCodeContainerView.isHidden = false
                qrCodeImageView.image = UtilHelper.generateQRCode(from: eGift?.code ?? "")
            } else {
                qrCodeContainerView.isHidden = true
            }

        }
        // Serial no
        if let serialNo = giftTransaction?.serialNo, !serialNo.isEmpty {
            usedSerialLabel.text = serialNo.uppercased()
            usedSerialContainerView.isHidden = false
        } else {
            usedSerialContainerView.isHidden = true
        }
        if (whyHaveIt == WhyHaveRewardType.sent.rawValue) {
            usedCodeContainerView.isHidden = true
            usedSerialContainerView.isHidden = true
        }
        // Member name from
        if let memberNameFrom = giftInfo?.memberNameFrom, !memberNameFrom.isEmpty, whyHaveIt == WhyHaveRewardType.received.rawValue {
            memberNameFromLabel.text = "Người tặng: \(memberNameFrom)"
            memberNameFromLabel.isHidden = false
        } else {
            memberNameFromLabel.isHidden = true
        }
        // Ngày xuất voucher
        if let effectiveDate = Date.init(fromString: eGift?.expiredDate ?? "", formatter: .yyyyMMddThhmmss)?.toString(formatter: .yyyyMMdd), !effectiveDate.isEmpty {
            effectiveDateLabel.text = "Ngày xuất voucher: \(effectiveDate)"
            effectiveDateLabel.isHidden = false
        } else {
            effectiveDateLabel.isHidden = true
        }

        // Lưu ý
        noteLabel.isHidden = whyHaveIt == WhyHaveRewardType.sent.rawValue
        let attribute1 = "Lưu ý: ".withAttributes([
                .textColor(.cF5574E!),
                .font(.f12s!)
            ])
        let attribute2 = "Không cung cấp ảnh chụp màn hình cho nhân viên để thanh toán.".withAttributes([
                .textColor(.c6D6B7A!),
                .font(.f12r!),
            ])
        noteLabel.attributedText = attribute1 + attribute2

        // Đổi thêm
        let remainingQuantityOfTheGift = giftInfo?.remainingQuantityOfTheGift ?? 0
        let isAvailableToRedeemAgain = giftInfo?.isAvailableToRedeemAgain ?? true
        if (remainingQuantityOfTheGift > 0 && isAvailableToRedeemAgain) {
            reorderButton.isHidden = false
        } else {
            reorderButton.isHidden = true
        }
    }

    // Thông tin chung
    func setUpGeneralInfo(_ giftTransaction: GiftTransaction) {
        // Giới thiệu
        if let description = giftTransaction.giftDescription, !description.isEmpty {
            descriptionStackView.isHidden = false
            descriptionWebView.loadHTMLStringWith(content: description, baseURL: nil)
            descriptionWebView.reload()

        } else {
            descriptionStackView.isHidden = true
        }

        // Hướng dẫn sử dụng
        if let introduce = giftTransaction.introduce, !introduce.isEmpty {
            instructionContainerView.isHidden = false
            instructionWebView.loadHTMLStringWith(content: introduce, baseURL: nil)
            instructionWebView.reload()
        } else {
            instructionContainerView.isHidden = true
        }

        // Liên hệ
        if (!(giftTransaction.contactHotline ?? "").isEmpty || !(giftTransaction.contactEmail ?? "").isEmpty) {
            contactContainerView.isHidden = false
            if let email = giftTransaction.contactEmail, !email.isEmpty {
                emailContainerView.isHidden = false
                emailButton.setTitle(email, for: .normal)
            } else {
                emailContainerView.isHidden = true
            }
            if let hotline = giftTransaction.contactHotline, !hotline.isEmpty {
                hotlineContainerView.isHidden = false
                hotlineButton.setTitle(hotline, for: .normal)
            } else {
                hotlineContainerView.isHidden = true
            }
        } else {
            contactContainerView.isHidden = true
        }
        giftInfoContainerView.isHidden = descriptionStackView.isHidden && instructionContainerView.isHidden && contactContainerView.isHidden
        // Điều kiện áp dụng
        if let condition = giftTransaction.condition {
            conditionContainerView.isHidden = false
            conditionWebView.loadHTMLStringWith(content: condition, baseURL: nil)
            instructionWebView.reload()
        } else {
            conditionContainerView.isHidden = true
        }
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { self.viewModel.updateEgiftStatus()
            }
        })) { [weak self] vc in
            guard let self = self else { return }
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.navigationController?.present(vc, animated: true)
        }
    }

    @IBAction func openEmailAction(_ sender: Any) {
        if let email = viewModel.output.giftInfo.value?.giftTransaction?.contactEmail {
            UtilHelper.openEmail(email: email)
        }
    }

    @IBAction func callHotlineAction(_ sender: Any) {
        if let phone = viewModel.output.giftInfo.value?.giftTransaction?.contactHotline {
            UtilHelper.openPhoneCall(number: phone)
        }
    }

    @IBAction func seeMoreLocationAction(_ sender: Any) {
        self.navigator.show(segue: .giftLocation(giftCode: viewModel.output.giftInfo.value?.giftTransaction?.giftCode ?? "")) { [weak self] vc in
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
        let code = viewModel.output.giftInfo.value?.eGift?.code ?? ""
        UtilHelper.copyToClipboard(text: code) {
            self.showToast(ofType: .success, withMessage: "Sao chép thành công")
        }
    }

    @IBAction func copySerialAction(_ sender: Any) {
        let code = viewModel.output.giftInfo.value?.giftTransaction?.serialNo ?? ""
        UtilHelper.copyToClipboard(text: code) {
            self.showToast(ofType: .success, withMessage: "Sao chép thành công")
        }
    }

    @IBAction func reorderAction(_ sender: Any) {
        let giftId = "\(String(describing: viewModel.output.giftInfo.value?.giftTransaction?.giftId))"
        self.navigator.show(segue: .giftDetail(giftId: giftId)) { [weak self] vc in
            guard let self = self else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}

extension EgiftRewardDetailViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        switch webView {
        case descriptionWebView:
            if (isInjectedDescriptionWebView) {
                return
            }
            isInjectedDescriptionWebView = true
            webView.injectJavascript(superView: self.view, webViewHeightConstraint: descriptionWebViewHeightConstraint)
            break
        case instructionWebView:
            if (isInjectedInstructionWebView) {
                return
            }
            isInjectedInstructionWebView = true
            webView.injectJavascript(superView: self.view, webViewHeightConstraint: instructionWebViewHeightConstraint)
            break
        case conditionWebView:
            if (isInjectedConditionWebView) {
                return
            }
            isInjectedConditionWebView = true
            webView.injectJavascript(superView: self.view, webViewHeightConstraint: conditionWebViewHeightConstraint)
            break
        default: break

        }
    }
}


extension EgiftRewardDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.output.giftInfo.value?.giftUsageAddress?.count ?? 0
        return min(count, 3)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = locationTableView.dequeueCell(ofType: GiftLocationTableViewCell.self, for: indexPath)
        let list = viewModel.output.giftInfo.value?.giftUsageAddress ?? []
        cell.setDataForCell(data: list[indexPath.row], isLastItem: indexPath.row == list.count - 1)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = viewModel.output.giftInfo.value?.giftUsageAddress?[indexPath.row]
        UtilHelper.openGoogleMap(navigator: self.navigator, parentVC: self, address: data?.address ?? "")
    }
}

extension EgiftRewardDetailViewController {

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

extension EgiftRewardDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let shrinkOffset = self.scrollView.contentOffset.y
        let headerViewBottom = self.headerView.frame.origin.y + self.headerView.frame.size.height

        let alpha: CGFloat = {
            let _alpha = (headerViewBottom - shrinkOffset) / headerViewBottom
            return _alpha
        }()
        self.headerView.alpha = 1 - alpha
        self.headerView.isHidden = alpha == 0
    }
}
